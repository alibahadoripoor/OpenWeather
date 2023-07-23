import SwiftUI
import CoreAssets
import WeatherKit

struct WeatherContentView: View {
    
    let weather: WeatherViewState.Weather
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HeaderView(weather: weather)
                TilesView(tiles: weather.tiles)
            }
        }
        .background(backgroundImageView)
    }
}

// MARK: - Privates

private extension WeatherContentView {
    
    var backgroundImageView: some View {
        backgroundImage
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
    }
    
    private var backgroundImage: Image {
        colorScheme == .dark ? Image.darkBackground : Image.lightBackground
    }
}

// MARK: - HeaderView

private struct HeaderView: View {
    let weather: WeatherViewState.Weather
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(weather.cityName)
                    .font(.headline)
                    .bold()
                    .padding(.top)
                    .foregroundColor(.init(uiColor: .label))
                
                Text(weather.temperature)
                    .font(.system(size: 60))
                    .foregroundColor(.init(uiColor: .label))

                Text(weather.description)
                    .font(.subheadline)
                    .padding(.bottom)
                    .foregroundColor(.init(uiColor: .label))
            }
            .padding(.horizontal)
            
            Spacer()
            
            AsyncImage(url: weather.iconUrl)
                .background(Circle().fill(.blue))
                .padding(.horizontal)
                .shadow(radius: 5)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.init(uiColor: .secondarySystemBackground))
                .blur(radius: 0)
                .opacity(0.8)
        )
        .padding()
    }
}

// MARK: - TilesView

private struct TilesView: View {
    let tiles: [WeatherViewState.Weather.Tile]
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: 16) {
            ForEach(tiles, id: \.self) { tile in
                TileView(
                    name: tile.name,
                    description: tile.description,
                    imageName: tile.imageName
                )
            }
        }
        .padding()
    }
    
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    }
}

// MARK: - TileView

private struct TileView: View {

    let name: String
    let description: String
    let imageName: String
    
    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                Image(systemName: imageName)
                    .font(.headline)
                Text(name)
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
            }

            VStack {
                Text(description)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
            .padding(.top)
            .maxPossibleSize()
        }
        .maxPossibleSize()
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.init(uiColor: .secondarySystemBackground))
                .blur(radius: 0)
                .opacity(0.8)
        )
        .aspectRatio(1, contentMode: .fill)
    }
}

// MARK: - 

private extension View {
    
    func maxPossibleSize() -> some View {
        frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
}
