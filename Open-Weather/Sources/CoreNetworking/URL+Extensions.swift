import Foundation

public extension URL {
    
    func appendingPathComponents(_ components: String...) -> URL {
        components.reduce(self) { $0.appendingPathComponent($1) }
    }
    
    mutating func modify(_ modification: (inout URLComponents) -> ()) throws {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            throw URLError(.badURL)
        }
        modification(&components)
        guard let url = components.url else { throw URLError(.badURL) }
        self = url
    }
}
