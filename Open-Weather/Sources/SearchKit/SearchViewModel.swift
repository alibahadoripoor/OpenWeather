import Foundation
import Combine

public final class SearchViewModel: ObservableObject {
    
    private let cityService: CityServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published public private(set) var viewState: SearchViewState = .initial
    @Published public var searchQuery: String = ""

    public init(cityService: CityServiceProtocol) {
        self.cityService = cityService
    }
    
    @Sendable
    public func fetchCities(for query: String) async {
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


