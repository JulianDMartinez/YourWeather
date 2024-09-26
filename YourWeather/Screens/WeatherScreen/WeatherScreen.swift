//
//  WeatherScreen.swift
//  YourWeather
//
//  Created by Julian Martinez on 9/23/24.
//

import SwiftUI

struct WeatherScreen: View {
    @Environment(AppCoordinator.self) private var coordinator
    
    @State var viewModel: WeatherScreenViewModel

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else {
                if let weather = viewModel.weatherResponse {
                    VStack(spacing: 16) {
                        Text(weather.name)
                            .font(.largeTitle)
                            .bold()
                        if let icon = viewModel.weatherIcon {
                            Image(uiImage: icon)
                                .resizable()
                                .frame(width: 100, height: 100)
                        }
                        Text("\(Int(weather.main.temp))°F")
                            .font(.system(size: 50))
                        Text(weather.weather.first?.description.capitalized ?? "")
                            .font(.title2)
                    }
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    Text("Search for a city to get weather information.")
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            HStack {
                TextField("Enter city name", text: $viewModel.city)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    Task {
                        await viewModel.fetchWeatherByCity()
                    }
                }) {
                    Text("Search")
                }
            }
            .padding()

            Button(action: {
                viewModel.fetchWeatherByLocationForInteraction()
            }) {
                Text("Use Current Location")
            }
            .padding()

            Button("Back to Home") {
                coordinator.popToRoot()
            }
            .padding()
        }
        .task {
            viewModel.loadLastSearchedCity()
        }
        .padding()
    }
}

#Preview {
    let diContainer = DIContainer.makeDefault()
    
    WeatherScreen(
        viewModel: WeatherScreenViewModel(
            container: diContainer
        )
    )
    .environment(AppCoordinator(container: diContainer))
}
    
