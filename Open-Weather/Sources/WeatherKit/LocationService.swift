import Foundation
import Combine
import CoreLocation

public protocol LocationServiceProtocol: AnyObject {
    var onUpdate: PassthroughSubject<LocationService.CoordinateResult, Never> { get }
    func startUpdatingLocation()
}

final public class LocationService: NSObject, LocationServiceProtocol {

    private let locationManager: CLLocationManager
    
    public typealias CoordinateResult = Result<Coordinate, Error>
    public let onUpdate = PassthroughSubject<CoordinateResult, Never>()
    
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
            let coordinate = Coordinate(location: location)
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

// MARK: - Coordinate Conversion

private extension Coordinate {
    
    init(location: CLLocation) {
        self.init(
            longitude: location.coordinate.longitude,
            latitude: location.coordinate.latitude
        )
    }
}
