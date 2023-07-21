import XCTest
@testable import CoreNetworking
@testable import WeatherKit

final class ResourceTests: XCTestCase {
    
    func test_whenResourceIsCreated_thenRequestIsAsExpected() throws {
        let request = try Resource.weather(for: .stub).makeRequest()
        
        let url = try XCTUnwrap(request.url)
        XCTAssertEqual(url.scheme, "https")
        XCTAssertEqual(url.host, "api.openweathermap.org")
        XCTAssertEqual(url.pathComponents.count, 4)
        XCTAssertEqual(url.pathComponents[0], "/")
        XCTAssertEqual(url.pathComponents[1], "data")
        XCTAssertEqual(url.pathComponents[2], "2.5")
        XCTAssertEqual(url.pathComponents[3], "weather")
        
        let query = try XCTUnwrap(url.query)
        XCTAssertTrue(query.contains("lat=20.0"))
        XCTAssertTrue(query.contains("lon=10.0"))
        XCTAssertTrue(query.contains("units=metric"))
        let appId = try networkEnvironment.appId
        XCTAssertTrue(query.contains("appid=\(appId)"))
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }
    
    
    func test_whenResourceIsCreated_thenTransformedDataIsAsExpected() throws {
        let jsonData = try Bundle.module.jsonData(forResource: "WeatherData")
        let weatherData = try Resource.weather(for: .stub).transform((jsonData, URLResponse()))
        
        XCTAssertEqual(weatherData.name, "Zocca")
        XCTAssertEqual(weatherData.coordinate.latitude, 44.34)
        XCTAssertEqual(weatherData.coordinate.longitude, 10.99)
        XCTAssertEqual(weatherData.weather.count, 1)
        XCTAssertEqual(weatherData.weather.first?.id, 501)
        XCTAssertEqual(weatherData.weather.first?.description, "moderate rain")
        XCTAssertEqual(weatherData.weather.first?.icon, "10d")
        XCTAssertEqual(weatherData.weather.first?.main, "Rain")
        XCTAssertEqual(weatherData.main.feelsLike, 298.74)
        XCTAssertEqual(weatherData.main.humidity, 64)
        XCTAssertEqual(weatherData.main.pressure, 1015)
        XCTAssertEqual(weatherData.main.temperature, 298.48)
        XCTAssertEqual(weatherData.main.temperatureMax, 300.05)
        XCTAssertEqual(weatherData.main.temperatureMin, 297.56)
    }
}

private extension Coordinate {
    static let stub = Coordinate(longitude: 10, latitude: 20)
}
