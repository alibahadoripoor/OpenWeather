import Foundation

public struct WeatherData {
    public let coordinate: Coordinate
    public let weather: [Weather]
    public let main: Main
    public let name: String
}

public struct Coordinate {
    public let longitude: Double
    public let latitude: Double
}

public struct Weather {
    public let id: Int
    public let main: String
    public let description: String
    public let icon: String
}

public struct Main {
    public let temperature: Double
    public let feelsLike: Double
    public let temperatureMin: Double
    public let temperatureMax: Double
    public let pressure: Int
    public let humidity: Int
}
