//
//  AppCoordinator.swift
//  YourWeather
//
//  Created by Julian Martinez on 9/26/24.
//

import SwiftUI

@MainActor
@Observable
class AppCoordinator {
    var paths: [AppRoute] = []
    let container: DIContainer

    init(container: DIContainer) {
        self.container = container
    }

    func push(to route: AppRoute) {
        paths.append(route)
    }

    func popToRoot() {
        paths = []
    }

    func popLast() {
        _ = paths.popLast()
    }

    @ViewBuilder
    func buildView(for route: AppRoute) -> some View {
        switch route {
        case .home:
            HomeView()
                .environment(self)
        case .weather:
            WeatherScreen(viewModel: WeatherScreenViewModel(container: container))
                .environment(self)
        }
    }
}
