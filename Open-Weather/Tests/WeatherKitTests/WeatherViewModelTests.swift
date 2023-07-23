import XCTest
import Combine
@testable import CoreModel
@testable import CoreNetworking
@testable import WeatherKit

final class WeatherViewModelTests: XCTestCase {
    
    private var viewModel: WeatherViewModel!
    private let mockLocationService = MockLocationService()
    private let mockWeatherService = MockWeatherService()
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        viewModel = WeatherViewModel(
            weatherService: mockWeatherService,
            locationService: mockLocationService
        )
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
    }
    
    func test_whenLocationUpdatedSuccessfully_thenCoordinateIsPublishedCorrectly() {
        let expectation = expectation(description: "Location updated")
        
        mockLocationService.onUpdate
            .sink { result in
                if case .success(let coordinate) = result {
                    XCTAssertEqual(coordinate.latitude, 20)
                    XCTAssertEqual(coordinate.longitude, 10)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.updateLocation()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_whenLocationUpdateFailed_thenMockErrorIsPublished() {
        let expectation = expectation(description: "Location updated failed")
        
        mockLocationService.result = .failure(MockError())
        
        mockLocationService.onUpdate
            .sink { result in
                if case .failure(let error) = result {
                    XCTAssertTrue(error is MockError)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.updateLocation()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_whenLocationUpdateFailedWithAccessDeniedError_thenAccessDeniedErrorIsPublished() {
        let expectation = expectation(description: "Location updated failed")
        
        mockLocationService.result = .failure(LocationService.AccessDeniedError())
        
        mockLocationService.onUpdate
            .sink { result in
                if case .failure(let error) = result {
                    XCTAssertTrue(error is LocationService.AccessDeniedError)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.updateLocation()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_whenWeatherDataFetched_thenViewStateIsWeather_withExpectedWeatherData() async {
        viewModel.currentLocation = .stub
        await viewModel.fetchWeatherData()
        
        guard case .weather(let weather) = viewModel.viewState else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(weather.cityName, "Zocca")
        XCTAssertEqual(weather.description, "Moderate Rain\nH:25°C L:14°C")
        XCTAssertEqual(weather.iconUrl?.absoluteString, "https://openweathermap.org/img/wn/10d@2x.png")
        XCTAssertEqual(weather.temperature, "20°C")

        XCTAssertEqual(weather.tiles.count, 4)
        
        XCTAssertEqual(weather.tiles[0].name, "FEELSLIKE")
        XCTAssertEqual(weather.tiles[0].description, "15°C")
        XCTAssertEqual(weather.tiles[0].imageName, "thermometer.medium")

        XCTAssertEqual(weather.tiles[1].name, "HUMIDITY")
        XCTAssertEqual(weather.tiles[1].description, "64 %")
        XCTAssertEqual(weather.tiles[1].imageName, "humidity")

        XCTAssertEqual(weather.tiles[2].name, "WINDSPEED")
        XCTAssertEqual(weather.tiles[2].description, "20\nkm/h")
        XCTAssertEqual(weather.tiles[2].imageName, "wind")

        XCTAssertEqual(weather.tiles[3].name, "PRESSURE")
        XCTAssertEqual(weather.tiles[3].description, "1015 hPa")
        XCTAssertEqual(weather.tiles[3].imageName, "gauge.medium")
    }
    
    func test_whenFetchingWeatherDataFailed_thenViewStateIsFailure_andFailureTypeIsServerError() async {
        viewModel.currentLocation = .stub
        mockWeatherService.isResultSuccess = false
        
        await viewModel.fetchWeatherData()
        
        guard case .failure(.serverError(let failure)) = viewModel.viewState else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(failure.title, "Network Error")
        XCTAssertEqual(failure.message, "Something went wrong, please try again!")
        XCTAssertEqual(failure.buttonLabel, "Try Again")
    }
}

// MARK: - MockLocationService

final private class MockLocationService: LocationServiceProtocol {

    var result: LocationService.LocationResult = .success(.stub)
    var onUpdate = PassthroughSubject<LocationService.LocationResult, Never>()
    
    func startUpdatingLocation() {
        onUpdate.send(result)
    }
}

// MARK: - MockWeatherService

final private class MockWeatherService: WeatherServiceProtocol {
    
    var isResultSuccess: Bool = true
    
    func fetchWeatherData(forLocation location: LocationService.Location) async throws -> WeatherData {
        if isResultSuccess {
            let jsonData = try Bundle.module.jsonData(forResource: "WeatherData")
            return try Resource.weather(forLocation: .stub).transform((jsonData, URLResponse()))
        } else {
            throw MockError()
        }
    }
    
    func fetchWeatherData(forCity city: City) async throws -> WeatherData {
        if isResultSuccess {
            let jsonData = try Bundle.module.jsonData(forResource: "WeatherData")
            return try Resource.weather(forCity: .stub).transform((jsonData, URLResponse()))
        } else {
            throw MockError()
        }
    }
}

// MARK: - Coordinate

private extension LocationService.Location {
    static let stub = Self(latitude: 20, longitude: 10)
}

// MARK: - City

private extension City {
    static let stub = City(
        id: "id",
        name: "Berlin",
        latitude: 10,
        longitude: 20,
        country: "DE",
        state: nil
    )
}

// MARK: - MockError

struct MockError: Error {}
