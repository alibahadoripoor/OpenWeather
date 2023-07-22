import SwiftUI
import WeatherKit

public struct WeatherView: View {
    
    @StateObject private var viewModel: WeatherViewModel
    
    public init(viewModel: WeatherViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        NavigationStack {
            Group {
                switch viewModel.viewState {
                case .none: EmptyView()
                case .loading: ProgressView()
                case let .weather(weatherData):
                    EmptyView()
                case let .failure(message, buttonLabel):
                    ErrorView(
                        message: message,
                        buttonLabel: buttonLabel,
                        action: viewModel.updateLocation
                    )
                }
            }
        }
        .onAppear(perform: viewModel.updateLocation)
    }
}

// MARK: - Statics

public extension WeatherView {
    
    static func create() -> WeatherView {
        WeatherView(viewModel: WeatherViewModel(
            weatherService: WeatherService(),
            locationService: LocationService()
        ))
    }
}
