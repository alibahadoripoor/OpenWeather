import SwiftUI
import WeatherKit

public struct WeatherView: View {
    
    @StateObject private var viewModel: WeatherViewModel
    
    public init(viewModel: WeatherViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        EmptyView()
    }
}
