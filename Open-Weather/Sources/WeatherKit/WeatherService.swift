import Foundation
import CoreNetworking

public protocol WeatherServiceProtocol {
    func fetchWeatherData(for coordinate: Coordinate) async throws -> WeatherData
}

final public class WeatherService: WeatherServiceProtocol {
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func fetchWeatherData(for coordinate: Coordinate) async throws -> WeatherData {
        try await session.fetch(.weather(for: coordinate))
    }
}
