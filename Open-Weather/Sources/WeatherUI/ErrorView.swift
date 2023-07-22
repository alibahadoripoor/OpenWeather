import SwiftUI
import WeatherKit

struct ErrorView: View {
    
    let message: String
    let buttonLabel: String
    let action: () -> Void
    
    var body: some View {
        VStack {
            Text(message)
                .font(.title)
                .multilineTextAlignment(.center)
            
            Button(action: action) {
                Text(buttonLabel)
                    .padding(.horizontal, 64)
            }
            .buttonStyle(BlueButtonStyle())
        }
        .padding()
    }
}

private struct BlueButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 32))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

