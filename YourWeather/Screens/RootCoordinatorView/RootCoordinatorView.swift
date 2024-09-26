//
//  CoordinatorView.swift
//  YourWeather
//
//  Created by Julian Martinez on 9/26/24.
//

import SwiftUI

struct RootCoordinatorView: View {
    @State private var coordinator: AppCoordinator

    init(container: DIContainer) {
        _coordinator = State(wrappedValue: AppCoordinator(container: container))
    }

    var body: some View {
        NavigationStack(path: $coordinator.paths) {
            coordinator.buildView(for: .home)
                .navigationDestination(for: AppRoute.self) { route in
                    coordinator.buildView(for: route)
                }
        }
    }
}
