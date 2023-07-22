import Foundation
import Combine

public final class WeatherViewModel: ObservableObject {
    
    private let weatherService: WeatherServiceProtocol
    private let locationService: LocationServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
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
            await updateViewState(.failure(Alerts.oops, "Try Again"))
        }
    }
    
    public enum ViewState {
        case none
        case loading
        case weather(WeatherData)
        case failure(_ message: String, _ buttonLabel: String)
    }
}

// MARK: -

private extension WeatherViewModel {
    
    func handleLocationResult(_ result: LocationService.CoordinateResult) {
        switch result {
        case .success(let coordinate):
            Task {
                await self.fetchWeatherData(for: coordinate)
            }
            
        case .failure(let error):
            if error is LocationService.AccessDeniedError {
                Task {
                    await updateViewState(.failure(Alerts.accessDenied, "Share Location"))
                }
            }
        }
    }
    
    @MainActor
    func updateViewState(_ viewState: ViewState) {
        self.viewState = viewState
    }
}

// MARK: -

private struct Alerts {
    static let accessDenied = "We need to access your location to provide weather updates."
    static let oops = "Oops... Something went wrong, please try again!"
}
