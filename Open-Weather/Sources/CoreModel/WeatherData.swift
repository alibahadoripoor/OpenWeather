import Foundation

public struct WeatherData {
    internal init(coordinate: Coordinate, weather: [Weather], main: Main, wind: Wind, name: String) {
        self.coordinate = coordinate
        self.weather = weather
        self.main = main
        self.wind = wind
        self.name = name
    }
    
    public let coordinate: Coordinate
    public let weather: [Weather]
    public let main: Main
    public let wind: Wind
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

public struct Wind {
    public let speed: Double
    public let degree: Int
    public let gust: Double?
}

// MARK: - Conversion

public extension WeatherData {
    
    init(_ response: WeatherDataResponse) {
        self.init(
            coordinate: .init(response.coord),
            weather: response.weather.map(Weather.init),
            main: .init(response.main),
            wind: .init(response.wind),
            name: response.name
        )
    }
}

extension Coordinate {
    
    init(_ response: CoordinateResponse) {
        self.init(
            longitude: response.lon,
            latitude: response.lat
        )
    }
}

extension Weather {
    
    init(_ response: WeatherResponse) {
        self.init(
            id: response.id,
            main: response.main,
            description: response.description,
            icon: response.icon
        )
    }
}

extension Main {
    
    init(_ response: MainResponse) {
        self.init(
            temperature: response.temperature,
            feelsLike: response.feelsLike,
            temperatureMin: response.temperatureMin,
            temperatureMax: response.temperatureMax,
            pressure: response.pressure,
            humidity: response.humidity
        )
    }
}

extension Wind {
    
    init(_ response: WindResponse) {
        self.init(
            speed: response.speed,
            degree: response.deg,
            gust: response.gust
        )
    }
}
