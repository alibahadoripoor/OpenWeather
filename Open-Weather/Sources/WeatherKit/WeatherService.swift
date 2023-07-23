import Foundation
import CoreNetworking
import CoreModel

public protocol WeatherServiceProtocol {
    func fetchWeatherData(forLocation location: LocationService.Location) async throws -> WeatherData
    func fetchWeatherData(forCity city: City) async throws -> WeatherData
}

final public class WeatherService: WeatherServiceProtocol {
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func fetchWeatherData(forLocation location: LocationService.Location) async throws -> WeatherData {
        try await session.fetch(.weather(forLocation: location))
    }
    
    public func fetchWeatherData(forCity city: City) async throws -> WeatherData {
        try await session.fetch(.weather(forCity: city))
    }
}
