import Foundation
import Combine

public final class WeatherViewModel: ObservableObject {
    
    private let weatherService: WeatherServiceProtocol
    private let locationService: LocationServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    var currentCoordinate: Coordinate?
    
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
        locationService.startUpdatingLocation()
    }
    
    @Sendable
    public func fetchWeatherData() async {
        guard let coordinate = currentCoordinate else { return }
        await updateViewState(.loading)
        
        do {
            let weatherData = try await weatherService.fetchWeatherData(for: coordinate)
            await updateViewState(.weather(weatherData))
        } catch {
            await updateViewState(.failure(.serverError))
        }
    }
    
    public enum ViewState {
        case none
        case loading
        case weather(WeatherData)
        case failure(FailureType)
        
        public enum FailureType {
            case accessDenied(FailureContent)
            case serverError(FailureContent)
        }
        
        public struct FailureContent {
            public let title: String
            public let message: String
            public let buttonLabel: String
        }
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
    func updateViewState(_ viewState: ViewState) {
        self.viewState = viewState
    }
    
}

// MARK: - FailureType extensions

private extension WeatherViewModel.ViewState.FailureType {
    
    static var serverError: Self {
        .serverError(.init(
            title: Texts.networkError,
            message: Texts.tryAgainMessage,
            buttonLabel: Texts.tryAgain
        ))
    }
    
    static var accessDenied: Self {
        .accessDenied(.init(
            title: Texts.accessDenied,
            message: Texts.accessDeniedMessage,
            buttonLabel: Texts.openSettings
        ))
    }
    
    private struct Texts {
        static let accessDenied = "Access Denied"
        static let accessDeniedMessage = "We need to access your location. Please check your location service settings and try again!"
        static let networkError = "Network Error"
        static let tryAgainMessage = "Something went wrong, please try again!"
        static let tryAgain = "Try Again"
        static let openSettings = "Open System Settings"
    }
}
