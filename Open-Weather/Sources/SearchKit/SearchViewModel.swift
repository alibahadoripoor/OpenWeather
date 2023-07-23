import Foundation
import Combine

public final class SearchViewModel: ObservableObject {
    
    private let cityService: CityServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published public private(set) var viewState: SearchViewState = .initial

    public init(cityService: CityServiceProtocol) {
        self.cityService = cityService
    }
    
    @Sendable
    public func fetchCities(for query: String) async {
        do {
            let cities = try await cityService.fetchCities(for: query)
            await updateUI(.cities(cities))
        } catch {
            await updateUI(.failure(.serverError))
        }
    }
    
    @MainActor
    func updateUI(_ viewState: SearchViewState) {
        self.viewState = viewState
    }
}


