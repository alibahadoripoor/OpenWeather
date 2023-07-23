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
                case .weather(let weather):
                    WeatherContentView(weather: weather)
                case .failure(let failure):
                    WeatherFailureView(
                        failure: failure,
                        retry: viewModel.fetchWeatherData
                    )
                }
            }
            .toolbar { searchButtonView }
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

// MARK: - Privates

private extension WeatherView {
    
    private var searchButtonView: some View {
        Button {
            // Opening the search screen
        } label: {
            HStack {
                Text("Search for city")
                Image(systemName: "magnifyingglass")
            }
            .bold()
        }
        .foregroundColor(.blue)
    }
}
