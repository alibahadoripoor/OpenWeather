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
                    let _ = print(weatherData.name)
                    EmptyView()
                case let .failure(failureType):
                    WeatherFailureView(
                        failureType: failureType,
                        retry: viewModel.fetchWeatherData
                    )
                }
            }
            .toolbar { searchButtonView }
        }
        .onAppear(perform: viewModel.updateLocation)
    }
    
    private var searchButtonView: some View {
        Button {
            // Opening the search screen
        } label: {
            HStack {
                Text("Search for city")
                Image(systemName: "magnifyingglass")
            }
        }
        .foregroundColor(.primary)
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
