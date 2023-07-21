import Foundation

public extension URLResponse {
    
    func check() throws {
        if let httpResponse = self as? HTTPURLResponse, !(200..<300).contains(httpResponse.statusCode) {
            throw NetworkError.server("Invalid response")
        }
    }
}
