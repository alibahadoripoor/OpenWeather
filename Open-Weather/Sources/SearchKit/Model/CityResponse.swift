import Foundation

struct CityResponse: Decodable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
}
