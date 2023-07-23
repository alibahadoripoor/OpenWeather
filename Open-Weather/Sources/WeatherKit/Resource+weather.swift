import Foundation
import CoreNetworking
import CoreModel

extension Resource where Value == WeatherData {
    
    static func weather(forLocation location: LocationService.Location) -> Self {
        Self(makeRequest: {
            var url = try networkEnvironment.baseURL.appendingPathComponents("/data/2.5/weather")
            let appId = try networkEnvironment.appId
            try url.modify { components in
                components.queryItems = [
                    URLQueryItem(name: "lat", value: "\(location.latitude)"),
                    URLQueryItem(name: "lon", value: "\(location.longitude)"),
                    URLQueryItem(name: "units", value: "metric"),
                    URLQueryItem(name: "appid", value: appId)
                ]
            }
            return URLRequest(url: url)
        }, transform: { (data, response) in
            try response.check()
            let responseData = try JSONDecoder().decode(WeatherDataResponse.self, from: data)
            return WeatherData(responseData)
        })
    }
    
    static func weather(forCity city: City) -> Self {
        Self(makeRequest: {
            var url = try networkEnvironment.baseURL.appendingPathComponents("/data/2.5/weather")
            let appId = try networkEnvironment.appId
            try url.modify { components in
                components.queryItems = [
                    URLQueryItem(name: "q", value: query(for: city)),
                    URLQueryItem(name: "units", value: "metric"),
                    URLQueryItem(name: "appid", value: appId)
                ]
            }
            return URLRequest(url: url)
        }, transform: { (data, response) in
            try response.check()
            let responseData = try JSONDecoder().decode(WeatherDataResponse.self, from: data)
            return WeatherData(responseData)
        })
    }
    
    private static func query(for city: City) -> String {
        guard let state = city.state else {
            return "\(city.name), \(city.country)"
        }
        return "\(city.name), \(state), \(city.country)"
    }
}
