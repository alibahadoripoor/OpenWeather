import Foundation

public extension URLSession {
    
    /// Fetches the given resource using its `makeRequest` function to create the
    /// URL request and `transform` to create the value to return.
    ///
    /// - Parameter resource: The resource to fetch
    /// - Returns: The value
    func fetch<Value>(_ resource: Resource<Value>) async throws -> Value {
        let result = try await data(for: resource.makeRequest())
        return try resource.transform(result)
    }
}
