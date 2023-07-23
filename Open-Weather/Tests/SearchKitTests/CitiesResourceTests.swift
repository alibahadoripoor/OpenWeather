import XCTest
@testable import CoreNetworking
@testable import SearchKit

final class CitiesResourceTests: XCTestCase {
    
    func test_whenResourceIsCreated_thenRequestIsAsExpected() throws {
        let request = try Resource.cities(for: "Berlin").makeRequest()
        
        let url = try XCTUnwrap(request.url)
        XCTAssertEqual(url.scheme, "https")
        XCTAssertEqual(url.host, "api.openweathermap.org")
        XCTAssertEqual(url.pathComponents.count, 4)
        XCTAssertEqual(url.pathComponents[0], "/")
        XCTAssertEqual(url.pathComponents[1], "geo")
        XCTAssertEqual(url.pathComponents[2], "1.0")
        XCTAssertEqual(url.pathComponents[3], "direct")
        
        let query = try XCTUnwrap(url.query)
        XCTAssertTrue(query.contains("q=Berlin"))
        XCTAssertTrue(query.contains("limit=5"))
        let appId = try networkEnvironment.appId
        XCTAssertTrue(query.contains("appid=\(appId)"))
        
        XCTAssertEqual(request.httpMethod, "GET")
    }
    
    func test_whenResourceIsCreated_thenTransformedDataIsAsExpected() throws {
        let jsonData = try Bundle.module.jsonData(forResource: "Cities")
        let cities = try Resource.cities(for: "London").transform((jsonData, URLResponse()))
        
        XCTAssertEqual(cities.count, 5)

        XCTAssertEqual(cities[0].name, "London")
        XCTAssertEqual(cities[0].country, "GB")
        XCTAssertEqual(cities[0].latitude, 51.5073219)
        XCTAssertEqual(cities[0].longitude, -0.1276474)
        XCTAssertEqual(cities[0].state, "England")
    }
}
