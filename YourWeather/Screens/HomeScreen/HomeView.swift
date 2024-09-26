//
//  HomeView.swift
//  YourWeather
//
//  Created by Julian Martinez on 9/26/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(AppCoordinator.self) private var coordinator

    var body: some View {
        VStack {
            Text("Welcome to Your Weather App")
                .font(.largeTitle)
                .padding()

            Button(action: {
                coordinator.push(to: .weather)
            }) {
                Text("Go to Weather")
                    .font(.title2)
                    .padding()
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(AppCoordinator(container: DIContainer.makeDefault()))
}
