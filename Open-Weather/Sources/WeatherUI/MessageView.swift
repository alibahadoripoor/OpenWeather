import SwiftUI
import WeatherKit

struct MessageView: View {
    
    let title: String
    let message: String
    let buttonLabel: String
    let action: (() -> Void)
    
    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
            
            Text(message)
                .font(.title3)
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
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

