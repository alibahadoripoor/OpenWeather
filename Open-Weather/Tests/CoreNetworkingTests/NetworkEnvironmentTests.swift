import XCTest
@testable import CoreNetworking

final class NetworkEnvironmentTests: XCTestCase {
    
    func test_expectedNetworkEnvironmentBaseURL() throws {
        XCTAssertEqual(networkEnvironment.baseURL.absoluteString, "http://api.openweathermap.org")
    }
}
