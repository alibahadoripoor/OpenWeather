import Foundation
import Combine
import CoreLocation

public protocol LocationServiceProtocol: AnyObject {
    var onUpdate: PassthroughSubject<LocationService.LocationResult, Never> { get }
    func startUpdatingLocation()
}

final public class LocationService: NSObject, LocationServiceProtocol {

    private let locationManager: CLLocationManager
    
    public typealias LocationResult = Result<Coordinate, Error>
    public let onUpdate = PassthroughSubject<LocationResult, Never>()
    
    public override init() {
        locationManager = CLLocationManager()
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    public func startUpdatingLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let coordinate = Coordinate(location: location)
            onUpdate.send(.success(coordinate))
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onUpdate.send(.failure(error))
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
