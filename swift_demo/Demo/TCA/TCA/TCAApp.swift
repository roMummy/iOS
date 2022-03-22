//
//  TCAApp.swift
//  TCA
//
//  Created by FSKJ on 2022/3/18.
//

import ComposableArchitecture
import SwiftUI

@main
struct TCAApp: App {
    var body: some Scene {
        WindowGroup {
            GameView(
                store: Store(
                    initialState: GameState(),
                    reducer: gameReducer,
                    environment: GameEnvironment()
                )
            )
        }
    }
}
