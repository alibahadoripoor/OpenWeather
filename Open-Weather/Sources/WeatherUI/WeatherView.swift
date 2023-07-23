import SwiftUI
import WeatherKit
import SearchUI

public struct WeatherView: View {
    
    @StateObject private var viewModel: WeatherViewModel
    @State private var isSearchViewPresented = false
    
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
        .fullScreenCover(isPresented: $isSearchViewPresented) {
            SearchView(
                viewModel: viewModel.searchViewModel(),
                isPresented: $isSearchViewPresented
            )
        }
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
    
    var searchButtonView: some View {
        Button {
            isSearchViewPresented = true
        } label: {
            HStack {
                Text("Search for city")
                Image(systemName: "magnifyingglass")
            }
            .bold()
        }
    }
}
