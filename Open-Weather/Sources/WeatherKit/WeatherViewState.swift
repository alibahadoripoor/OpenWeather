import Foundation
import CoreNetworking

public enum WeatherViewState {
    case none
    case loading
    case weather(Weather)
    case failure(FailureType)
    
    public struct Weather {
        public let cityName: String
        public let temperature: String
        public let description: String
        public let iconUrl: URL?
        public let tiles: [Tile]
        
        public struct Tile: Hashable {
            public let name: String
            public let description: String
            public let imageName: String
        }
    }
    
    public enum FailureType {
        case accessDenied(FailureContent)
        case serverError(FailureContent)
        
        public struct FailureContent {
            public let title: String
            public let message: String
            public let buttonLabel: String
        }
    }
}

// MARK: - Conversion

extension WeatherViewState.Weather {
    
    init(_ weatherData: WeatherData) {
        self.init(
            cityName: weatherData.name,
            temperature: "\(Int(weatherData.main.temperature))°C",
            description: .description(for: weatherData),
            iconUrl: .iconUrl(for: weatherData),
            tiles: .tiles(for: weatherData)
        )
    }
}

// MARK: - FailureType extensions

extension WeatherViewState.FailureType {
    
    static var serverError: Self {
        .serverError(.init(
            title: Strings.networkError,
            message: Strings.tryAgainMessage,
            buttonLabel: Strings.tryAgain
        ))
    }
    
    static var accessDenied: Self {
        .accessDenied(.init(
            title: Strings.accessDenied,
            message: Strings.accessDeniedMessage,
            buttonLabel: Strings.openSettings
        ))
    }
    
    private struct Strings {
        static let accessDenied = "Access Denied"
        static let accessDeniedMessage = "We need to access your location. Please check your location service settings and try again!"
        static let networkError = "Network Error"
        static let tryAgainMessage = "Something went wrong, please try again!"
        static let tryAgain = "Try Again"
        static let openSettings = "Open System Settings"
    }
}

private extension URL {
    
    static func iconUrl(for weatherData: WeatherData) -> URL? {
        guard let weather = weatherData.weather.first else { return nil }
        return URL(string: "https://openweathermap.org/img/wn/\(weather.icon)@2x.png")
    }
}

private extension String {
    
    static func description(for weatherData: WeatherData) -> String {
        let maxTemp = Int(weatherData.main.temperatureMax)
        let minTemp = Int(weatherData.main.temperatureMin)
        let minAndMaxTemp = "H:\(maxTemp)°C L:\(minTemp)°C"

        if let weather = weatherData.weather.first {
            return "\(weather.description.capitalized)\n\(minAndMaxTemp)"
        } else {
            return minAndMaxTemp
        }
    }
}

private extension Array where Element == WeatherViewState.Weather.Tile {
    
    static func tiles(for weatherData: WeatherData) -> Self {
        [
            .init(
                name: "FEELSLIKE",
                description: "\(Int(weatherData.main.feelsLike))°C",
                imageName: "thermometer.medium"
            ),
            .init(
                name: "HUMIDITY",
                description: "\(Int(weatherData.main.humidity)) %",
                imageName: "humidity"
            ),
            .init(
                name: "WINDSPEED",
                description: "\(Int(convertWindSpeedToKPH(weatherData.wind.speed))) km/h",
                imageName: "wind"
            ),
            .init(
                name: "PRESSURE",
                description: "\(Int(weatherData.main.pressure)) hPa",
                imageName: "gauge.medium"
            )
        ]
    }
    
    static private func convertWindSpeedToKPH(_ windSpeed: Double) -> Double {
        return windSpeed * 3.6
    }
}
