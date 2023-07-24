# OpenWeather

This is a simple weather app built using Swift and SwiftUI. It allows users to access real-time or forecasted weather data for their current location or any other location of their choice.

## Architecture

The project is modularised into different libraries, each with its own responsibility:

* Core: Core-type modules such as CoreNetworking are the foundation of the application. They contain basic functionalities and utilities that other modules build upon.
* Kit: Kit-type modules such as WeatherKit extend the Cores with additional functionalities needed for a specific feature. They contain Models, ViewModels, Networking bridges, and all the other logics related to the feature.
* UI: UI-type modules such as WeatherUI are the user interface module. They build upon both Core and Kit to provide the user interface for the application.

Additional modules like CoreModel, CoreAssets, SearchKit, and SearchUI have also been included, showing the flexibility and scalability of the architecture.


## Technologies Used

This project uses the following technologies:

* SwiftUI for building the user interface in a declarative way.
* Swift Package Manager for managing dependencies in a modular way.
* MVVM Architecture: The project follows the Model-View-ViewModel design pattern, allowing for efficient separation of concerns and easier testing.
* Combine: This app uses the Combine framework for handling asynchronous events, providing a streamlined way of updating view states based on changes in underlying data.
* Async/Await: This app utilizes Swift's native async/await syntax for handling asynchronous tasks. This makes the code cleaner, easier to read, and more performant.
* OpenWeatherMap API: This app fetches weather data from the OpenWeatherMap API. Please refer to the API Key section below for how to provide your own API key.


## User Interface

There are two screens in the app:

* The first screen shows the current weather for the user's current location or a user-selected location.
* The second screen contains a search bar, where users can search for a location and select it to display its weather data on the first screen.

| Dark | Light |
| ---- | ---- |
| <img src="https://github.com/alibahadoripoor/OpenWeather/assets/64734165/20d9d2c6-38b6-4cba-8322-a4118f0cfe36" width="300"> | <img src="https://github.com/alibahadoripoor/OpenWeather/assets/64734165/45b122c1-7794-494c-8595-3ca6f292cdb0" width="300"> |


## API Key

In order to fetch weather data, this app uses the OpenWeatherMap API, which requires an API key. To provide your own API key:

* Sign up for a free account at OpenWeatherMap to get your API key.
* Create a Token.json file at OpenWeather/Open-Weather/Sources/CoreNetworking/Secrets.
* In the Token.json file, add the following JSON structure:
```
{
    "appId": "YOUR_APPID"
}
```
The Token.json file is included in the .gitignore file to prevent the API key from being committed to version control for security reasons.


## Improvements

The app still requires more improvements such as supporting multiple temperature units and adding more test coverage. 
