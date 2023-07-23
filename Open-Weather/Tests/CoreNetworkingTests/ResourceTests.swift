import XCTest
@testable import CoreNetworking

final class ResourceTests: XCTestCase {

    func testWhenResourceIsCreated_thenURLRequestIsCorrect() throws {
        let resource = Resource<Any>(
            makeRequest: {
                var request = URLRequest(url: .apple)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                return request
            },
            transform: { _ in }
        )
        
        do {
            let request = try resource.makeRequest()
            XCTAssertEqual(request.url, .apple)
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        } catch {
            XCTFail()
        }
    }
    
    func testWhenResourceIsCreated_thenDataAndResponseAreTransformedCorrectly() throws {
        let resource = Resource<Any>(
            makeRequest: { URLRequest(url: .apple) },
            transform: { data, response in
                "transformed data"
             }
        )
        
        do {
            let transformedData = try resource.transform((Data(), URLResponse()))
            XCTAssertEqual(transformedData as? String, "transformed data")
        } catch {
            XCTFail()
        }
    }
}

private extension URL {
    static let apple = Self(string: "https://apple.com")!
}
