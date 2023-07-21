import Foundation

/// Global network environment
public var networkEnvironment: NetworkEnvironment = .production

public enum NetworkEnvironment {
    case production
    // A development case can be added here in the future
}

public extension NetworkEnvironment {
    
    var baseURL: URL {
        switch self {
        case .production:
            return .production
        }
    }
}

private extension URL {
    static let production = URL(string: "http://api.openweathermap.org")!
}
