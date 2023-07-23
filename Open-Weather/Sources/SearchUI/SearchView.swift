import SwiftUI
import SearchKit

public struct SearchView: View {
    
    @StateObject private var viewModel: SearchViewModel
    @Binding private var isPresented: Bool
    
    public init(viewModel: SearchViewModel, isPresented: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._isPresented = isPresented
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
            .searchable(text: $viewModel.searchQuery)
            .navigationTitle("Search For City")
            .toolbar { closeButtonView }
        }
    }
}

// MARK: - Privates

private extension SearchView {
    
    var closeButtonView: some View {
        Button("Close") {
            isPresented = false
        }
        .bold()
    }
}

// MARK: - CitiesView

struct CitiesView: View {
    
    let cities: [SearchViewState.City]
    
    var body: some View {
        VStack {
            List(cities) { city in
                Text(city.name)
            }
            .listStyle(.insetGrouped)
        }
    }
}
