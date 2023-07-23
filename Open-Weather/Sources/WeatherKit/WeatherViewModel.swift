import Foundation
import Combine
import SearchKit

public final class WeatherViewModel: ObservableObject {
    
    private let weatherService: WeatherServiceProtocol
    private let locationService: LocationServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    var currentCoordinate: Coordinate?
    
    @Published public private(set) var viewState: WeatherViewState = .none

    public init(
        weatherService: WeatherServiceProtocol,
        locationService: LocationServiceProtocol
    ) {
        self.weatherService = weatherService
        self.locationService = locationService
        
        self.locationService.onUpdate
            .sink { [weak self] result in
                self?.handleLocationResult(result)
            }
            .store(in: &cancellables)
    }
    
    public func updateLocation() {
        locationService.startUpdatingLocation()
    }
    
    @Sendable
    public func fetchWeatherData() async {
        guard let coordinate = currentCoordinate else { return }
        await updateViewState(.loading)
        
        do {
            let weatherData = try await weatherService.fetchWeatherData(for: coordinate)
            await updateViewState(.weather(.init(weatherData)))
        } catch {
            await updateViewState(.failure(.serverError))
        }
    }
    
    public func searchViewModel() -> SearchViewModel {
        SearchViewModel(cityService: CityService())
    }
}

// MARK: - Privates

private extension WeatherViewModel {
    
    func handleLocationResult(_ result: LocationService.CoordinateResult) {
        switch result {
        case .success(let coordinate):
            self.currentCoordinate = coordinate
            Task {
                await self.fetchWeatherData()
            }
            
        case .failure(let error):
            if error is LocationService.AccessDeniedError {
                Task { await updateViewState(.failure(.accessDenied)) }
            }
        }
    }
    
    @MainActor
    func updateViewState(_ viewState: WeatherViewState) {
        self.viewState = viewState
    }
}
