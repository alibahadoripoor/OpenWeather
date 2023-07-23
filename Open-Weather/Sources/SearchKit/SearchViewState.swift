import Foundation
import CoreModel

public enum SearchViewState {
    case initial
    case cities([City])
    case failure(FailureContent)
    
    public struct City: Identifiable, Hashable, Equatable {
        public let id: String
        public let name: String
    }
    
    /// This can be unified with the `WeatherViewState.Failure.FailureContent`
    /// as a single model in a higher level module.
    public struct FailureContent {
        public let title: String
        public let message: String
        public let buttonLabel: String
    }
}

extension SearchViewState.City {
     
    init(_ city: City) {
        var name: String {
            guard let state = city.state else {
                return "\(city.name), \(city.country)"
            }
            return "\(city.name), \(state), \(city.country)"
        }
        
        self.init(id: city.id, name: name)
    }
}

extension SearchViewState.FailureContent {
    
    static var serverError: Self {
        .init(
            title: Strings.networkError,
            message: Strings.tryAgainMessage,
            buttonLabel: Strings.tryAgain
        )
    }
    
    /// All the Strings should be localised in a higher level module that can be used by
    /// both WeatherKit and SearchKit modules
    private struct Strings {
        static let networkError = "Network Error"
        static let tryAgainMessage = "Something went wrong, please try again!"
        static let tryAgain = "Try Again"
    }
}
