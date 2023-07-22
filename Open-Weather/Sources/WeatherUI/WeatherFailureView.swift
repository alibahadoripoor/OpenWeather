import SwiftUI
import WeatherKit

struct WeatherFailureView: View {
    
    let failureType: WeatherViewModel.ViewState.FailureType
    let retry: () async -> ()
    
    var body: some View {
        Group {
            switch failureType {
            case let .accessDenied(content):
                MessageView(
                    title: content.title,
                    message: content.message,
                    buttonLabel: content.buttonLabel,
                    action: openSettings
                )
            case let .serverError(content):
                MessageView(
                    title: content.title,
                    message: content.message,
                    buttonLabel: content.buttonLabel,
                    action: { Task { await retry() } }
                )
            }
        }
    }
    
    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
