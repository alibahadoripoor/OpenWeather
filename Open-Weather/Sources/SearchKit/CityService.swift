import Foundation
import CoreNetworking
import CoreModel

public protocol CityServiceProtocol {
    func fetchCities(for query: String) async throws -> [City]
}

final public class CityService: CityServiceProtocol {
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func fetchCities(for query: String) async throws -> [City] {
        try await session.fetch(.cities(for: query))
    }
}
