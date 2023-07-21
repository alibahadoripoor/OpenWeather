import Foundation
import CoreNetworking

extension Resource where Value == WeatherData {
    
    static func weather(for coordinate: Coordinate) -> Self {
        Self(makeRequest: {
            var url = try networkEnvironment.baseURL.appendingPathComponents("/data/2.5/weather")
            let appId = try networkEnvironment.appId
            try url.modify { components in
                components.queryItems = [
                    URLQueryItem(name: "lat", value: "\(coordinate.latitude)"),
                    URLQueryItem(name: "lon", value: "\(coordinate.longitude)"),
                    URLQueryItem(name: "units", value: "metric"),
                    URLQueryItem(name: "appid", value: appId)
                ]
            }
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            return request
        }, transform: { (data, response) in
            try response.check()
            let responseData = try JSONDecoder().decode(WeatherDataResponse.self, from: data)
            return WeatherData(responseData)
        })
    }
}
