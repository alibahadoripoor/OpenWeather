import Foundation

public struct City {
    public let id: String
    public let name: String
    public let latitude: Double
    public let longitude: Double
    public let country: String
    public let state: String?
}

// MARK: - Conversion

public extension City {
    
    init(_ response: CityResponse) {
        self.init(
            id: UUID().uuidString,
            name: response.name,
            latitude: response.lat,
            longitude: response.lon,
            country: response.country,
            state: response.state
        )
    }
}
