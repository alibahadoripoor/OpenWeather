import Foundation
import Combine

public final class SearchViewModel: ObservableObject {
    
    private let cityService: CityServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var cities: [City] = []
    
    @Published public private(set) var viewState: SearchViewState = .initial
    @Published public private(set) var selectedCity: City?
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
            cities = try await cityService.fetchCities(for: query)
            await updateUI(.cities(cities.map(SearchViewState.City.init)))
        } catch {
            await updateUI(.failure(.serverError))
        }
    }
    
    public func citySelected(_ id: String) {
        selectedCity = cities.first { $0.id == id }
        print(selectedCity)
    }
    
    @MainActor
    private func updateUI(_ viewState: SearchViewState) {
        self.viewState = viewState
    }
}
