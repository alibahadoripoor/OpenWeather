import Foundation
import Combine
import CoreModel
import SearchKit

public final class WeatherViewModel: ObservableObject {
    
    private let weatherService: WeatherServiceProtocol
    private let locationService: LocationServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    var currentLocation: LocationService.Location?
    
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
        guard let location = currentLocation else { return }
        await updateViewState(.loading)
        
        do {
            let weatherData = try await weatherService.fetchWeatherData(forLocation: location)
            await updateViewState(.weather(.init(weatherData)))
        } catch {
            await updateViewState(.failure(.serverError))
        }
    }
    
    public func fetchWeatherData(forCity city: City) async {
        await updateViewState(.loading)
        
        do {
            let weatherData = try await weatherService.fetchWeatherData(forCity: city)
            await updateViewState(.weather(.init(weatherData)))
        } catch {
            await updateViewState(.failure(.serverError))
        }
    }
    
    public func searchViewModel() -> SearchViewModel {
        let searchViewModel = SearchViewModel(cityService: CityService())
            
        searchViewModel.$selectedCity
            .sink { [weak self] city in
                guard let self = self, let city = city else { return }
                Task { await self.fetchWeatherData(forCity: city) }
            }
            .store(in: &cancellables)
        
        return searchViewModel
    }
}

// MARK: - Privates

private extension WeatherViewModel {
    
    func handleLocationResult(_ result: LocationService.LocationResult) {
        switch result {
        case .success(let location):
            self.currentLocation = location
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
