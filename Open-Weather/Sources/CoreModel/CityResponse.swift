import Foundation

public struct CityResponse: Decodable {
    public let name: String
    public let lat: Double
    public let lon: Double
    public let country: String
    public let state: String?
}
