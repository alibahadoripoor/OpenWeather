import SwiftUI
import SearchKit

public struct SearchView: View {
    
    @StateObject private var viewModel: SearchViewModel
    
    public init(viewModel: SearchViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        NavigationStack {
            Group {
                switch viewModel.viewState {
                case .initial:
                    EmptyView()
                case .cities(let cities):
                    CitiesView(cities: cities)
                case .failure(let failure):
                    EmptyView()
                }
            }
            .navigationTitle("Search City")
            .searchable(text: $viewModel.searchQuery)
        }
    }
}

// MARK: - CitiesView

struct CitiesView: View {
    
    let cities: [SearchViewState.City]
    
    var body: some View {
        List(cities, id: \.self) { city in
            Text(city.name)
        }
    }
}
