import Foundation
import Combine

public final class WeatherViewModel: ObservableObject {
    
    private let weatherService: WeatherServiceProtocol
    private let locationService: LocationServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var currentCoordinate: Coordinate?
    
    @Published public private(set) var viewState: ViewState = .none

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
        locationService.requestLocationAuthorization()
        locationService.startUpdatingLocation()
    }
    
    func fetchWeatherData(for coordinate: Coordinate) async {
        await updateViewState(.loading)
        
        do {
            let weatherData = try await weatherService.fetchWeatherData(for: coordinate)
            await updateViewState(.weather(weatherData))
        } catch {
            await updateViewState(.failure(error.localizedDescription))
        }
    }
    
    private func handleLocationResult(_ result: LocationService.CoordinateResult) {
        Task {
            switch result {
            case .success(let coordinate):
                self.currentCoordinate = coordinate
                await self.fetchWeatherData(for: coordinate)
            case .failure(let error):
                await updateViewState(.failure(error.localizedDescription))
            }
        }
    }
    
    @MainActor
    private func updateViewState(_ viewState: ViewState) {
        self.viewState = viewState
    }
    
    public enum ViewState {
        case none
        case loading
        case weather(WeatherData)
        case failure(String)
    }
}

