import Foundation

/// Global network environment
public var networkEnvironment: NetworkEnvironment = .production

public enum NetworkEnvironment {
    case production
    // A development case can be added here in the future
}

public extension NetworkEnvironment {
    
    var baseURL: URL {
        get throws {
            switch self {
            case .production:
                return try .production
            }
        }
    }
    
    var appId: String {
        get throws {
            do {
                let tokenData = try Bundle.module.jsonData(forResource: "Token")
                let token = try JSONDecoder().decode(Token.self, from: tokenData)
                return token.appId
            } catch {
                throw NetworkEnvironmentError.badToken
            }
        }
    }
}

private extension URL {
    static var production: URL {
        get throws {
            guard let url = URL(string: "https://api.openweathermap.org") else {
                throw NetworkEnvironmentError.badBaseURL
            }
            return url
        }
    }
}

public enum NetworkEnvironmentError: Error {
    case badBaseURL
    case badToken
}
