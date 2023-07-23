import Foundation

public extension Bundle {
    
    func jsonData(forResource resource: String) throws -> Data {
        guard let url = url(forResource: resource, withExtension: "json") else {
            throw URLError(.fileDoesNotExist)
        }
        return try Data(contentsOf: url)
    }
}
