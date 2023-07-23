import Foundation
import Combine

public final class SearchViewModel: ObservableObject {
    
    private let cityService: CityServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published public private(set) var viewState: SearchViewState = .initial
    @Published public var searchQuery: String = ""

    public init(cityService: CityServiceProtocol) {
        self.cityService = cityService
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] query in
                guard let self = self else { return }
                Task { await self.searchCities(query) }
            }
            .store(in: &cancellables)
    }
    
    public func searchCities(_ query: String) async {
        do {
            let cities = try await cityService.fetchCities(for: query)
            await updateUI(.cities(cities.map(SearchViewState.City.init)))
        } catch {
            await updateUI(.failure(.serverError))
        }
    }
    
    @MainActor
    func updateUI(_ viewState: SearchViewState) {
        self.viewState = viewState
    }
}


