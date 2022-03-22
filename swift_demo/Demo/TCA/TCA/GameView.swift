//
//  GameView.swift
//  TCA
//
//  Created by FSKJ on 2022/3/18.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct GameState: Equatable {
    var counter: Counter = .init()
    var timer: TimerState = .init()
}

enum GameAction {
    case counter(CounterAction)
    case timer(TimerAction)
}

struct GameEnvironment {}

let gameReducer = Reducer<GameState, GameAction, GameEnvironment>.combine(
    counterReducer.pullback(
        state: \.counter,
        action: /GameAction.counter,
        environment: {_ in .live}
    ),
    timerReducer.pullback(
        state: \.timer,
        action: /GameAction.timer,
        environment: {_ in .live}
    )
)

struct GameView: View {
    let store: Store<GameState, GameAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                TimerLabelView(store: store.scope(state: \.timer, action: GameAction.timer))
                ContentView(store: store.scope(state: \.counter, action: GameAction.counter))
            }.onAppear {
                viewStore.send(.timer(.start))
            }
        }
    }
}
