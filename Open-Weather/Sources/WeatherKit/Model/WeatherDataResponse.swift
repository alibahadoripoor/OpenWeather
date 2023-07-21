import Foundation

struct WeatherDataResponse: Decodable {
    let coord: CoordinateResponse
    let weather: [WeatherResponse]
    let main: MainResponse
    let name: String
}

struct CoordinateResponse: Decodable {
    let lon: Double
    let lat: Double
}

struct WeatherResponse: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct MainResponse: Decodable {
    let temperature: Double
    let feelsLike: Double
    let temperatureMin: Double
    let temperatureMax: Double
    let pressure: Int
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
        case temperatureMin = "temp_min"
        case temperatureMax = "temp_max"
        case pressure
        case humidity
    }
}
