import Foundation

public struct WeatherDataResponse: Decodable {
    public let coord: CoordinateResponse
    public let weather: [WeatherResponse]
    public let main: MainResponse
    public let wind: WindResponse
    public let name: String
}

public struct CoordinateResponse: Decodable {
    public let lon: Double
    public let lat: Double
}

public struct WeatherResponse: Decodable {
    public let id: Int
    public let main: String
    public let description: String
    public let icon: String
}

public struct MainResponse: Decodable {
    public let temperature: Double
    public let feelsLike: Double
    public let temperatureMin: Double
    public let temperatureMax: Double
    public let pressure: Int
    public let humidity: Int

    public enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
        case temperatureMin = "temp_min"
        case temperatureMax = "temp_max"
        case pressure
        case humidity
    }
}

public struct WindResponse: Decodable {
    public let speed: Double
    public let deg: Int
    public let gust: Double?
}
