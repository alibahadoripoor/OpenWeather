import Foundation

/// Encapsulates the creation of a network request and the transformation of the / data into a usable type.
public struct Resource<Value> {
    let makeRequest: () throws -> URLRequest
    let transform: ((Data, URLResponse)) throws -> Value
    
    /// Create a resource.
    /// - Parameters:
    ///   - makeRequest: Used to create the URL request.
    ///   - transform: Used to transform the response of the network call.
    public init(
        makeRequest: @escaping () throws -> URLRequest,
        transform: @escaping ((Data, URLResponse)) throws -> Value
    ) {
        self.makeRequest = makeRequest
        self.transform = transform
    }
}
