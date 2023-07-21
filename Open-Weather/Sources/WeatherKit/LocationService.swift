import Foundation
import Combine
import CoreLocation

public protocol LocationServiceProtocol: AnyObject {
    var onUpdate: PassthroughSubject<LocationService.LocationResult, Never> { get }
    func requestLocationAuthorization()
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

    public func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    public func startUpdatingLocation() {
        /// Monitor only the significant location changes as weather conditions are unlikely to change dramatically in short distances.
        /// This way we also save system resources. The trad off here would be setting the location update distance manually
        /// using `locationManager.distanceFilter` 
        locationManager.startMonitoringSignificantLocationChanges()
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
