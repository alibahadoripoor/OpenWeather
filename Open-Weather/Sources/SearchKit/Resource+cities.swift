import Foundation
import CoreNetworking
import CoreModel

extension Resource where Value == [City] {
    
    static func cities(for query: String) -> Self {
        Self(makeRequest: {
            var url = try networkEnvironment.baseURL.appendingPathComponents("/geo/1.0/direct")
            let appId = try networkEnvironment.appId
            try url.modify { components in
                components.queryItems = [
                    URLQueryItem(name: "q", value: query),
                    URLQueryItem(name: "limit", value: "5"),
                    URLQueryItem(name: "appid", value: appId)
                ]
            }
            return URLRequest(url: url)
        }, transform: { (data, response) in
            try response.check()
            return try JSONDecoder().decode([CityResponse].self, from: data)
                .map(City.init)
        })
    }
}
