import Foundation

public struct City: Decodable {
    public let name: String
    public let latitude: Double
    public let longitude: Double
    public let country: String
    public let state: String?
}

// MARK: - Conversion

extension City {
    
    init(_ response: CityResponse) {
        self.init(
            name: response.name,
            latitude: response.lat,
            longitude: response.lon,
            country: response.country,
            state: response.state
        )
    }
}
