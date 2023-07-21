import Foundation
import CoreNetworking

extension Resource where Value == WeatherData {
    
    static var weather: Self {
        Self(makeRequest: {
            let url = networkEnvironment.baseURL.appendingPathComponent("photos")
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            return request
        }, transform: { (data, response) in
            try response.check()
            let responseData = try JSONDecoder().decode(WeatherDataResponse.self, from: data)
            return WeatherData(responseData)
        })
    }
}
