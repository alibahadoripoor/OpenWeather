import XCTest
import Combine
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
    
    func test_whenDidAppear_andLocationUpdatedSuccessfully_thenCoordinateIsPublishedCorrectly() {
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
        
        viewModel.onAppear()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_whenDidAppear_andLocationUpdateFailed_thenErrorIsPublished() {
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
        
        viewModel.onAppear()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_whenWeatherDataFetched_thenViewStateIsWeather_withExpectedWeatherData() async {
        await viewModel.fetchWeatherData(for: .stub)
        
        guard case .weather(let weather) = viewModel.viewState else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(weather.name, "Zocca")
    }
    
    func test_whenFetchingWeatherDataFailed_thenViewStateIsFailure() async {
        mockWeatherService.isResultSuccess = false
        
        await viewModel.fetchWeatherData(for: .stub)
        
        guard case .failure = viewModel.viewState else {
            XCTFail()
            return
        }
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
    
    func fetchWeatherData(for coordinate: Coordinate) async throws -> WeatherData {
        if isResultSuccess {
            let jsonData = try Bundle.module.jsonData(forResource: "WeatherData")
            return try Resource.weather(for: .stub).transform((jsonData, URLResponse()))
        } else {
            throw MockError()
        }
    }
}

// MARK: - Coordinate

private extension Coordinate {
    static let stub = Coordinate(longitude: 10, latitude: 20)
}

// MARK: - MockError

struct MockError: Error {}
