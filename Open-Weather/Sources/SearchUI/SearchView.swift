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
                case .initial: EmptyView()
                case .cities(let cities): EmptyView()
                case .failure(let failure): EmptyView()
                }
            }
        }
    }
}
