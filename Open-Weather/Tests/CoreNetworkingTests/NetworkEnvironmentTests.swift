import XCTest
@testable import CoreNetworking

final class NetworkEnvironmentTests: XCTestCase {
    
    func test_expectedNetworkEnvironmentBaseURL() throws {
        do {
            let urlString = try networkEnvironment.baseURL.absoluteString
            XCTAssertEqual(urlString, "https://api.openweathermap.org")
        } catch {
            XCTFail()
        }
    }
    
    func test_networkEnvironmentAppIdExist() {
        XCTAssertNoThrow(try networkEnvironment.appId)
    }
}
