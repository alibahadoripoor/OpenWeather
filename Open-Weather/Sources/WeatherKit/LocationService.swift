import Foundation
import Combine
import CoreLocation
import CoreModel

public protocol LocationServiceProtocol: AnyObject {
    var onUpdate: PassthroughSubject<LocationService.LocationResult, Never> { get }
    func startUpdatingLocation()
}

final public class LocationService: NSObject, LocationServiceProtocol {

    private let locationManager: CLLocationManager
    
    public typealias LocationResult = Result<Location, Error>
    public let onUpdate = PassthroughSubject<LocationResult, Never>()
    
    public override init() {
        locationManager = CLLocationManager()
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1000
    }

    public func startUpdatingLocation() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied:
            onUpdate.send(.failure(AccessDeniedError()))
        default: break
        }
    }
    
    public struct Location {
        let latitude: Double
        let longitude: Double
    }
    
    public struct AccessDeniedError: Error {}
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied:
            onUpdate.send(.failure(AccessDeniedError()))
        default: break
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let coordinate = Location(clLocation: location)
            onUpdate.send(.success(coordinate))
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            onUpdate.send(.failure(AccessDeniedError()))
        } else {
            onUpdate.send(.failure(error))
        }
    }
}

// MARK: - Location Conversion

private extension LocationService.Location {
    
    init(clLocation: CLLocation) {
        self.init(
            latitude: clLocation.coordinate.latitude,
            longitude: clLocation.coordinate.longitude
        )
    }
}
