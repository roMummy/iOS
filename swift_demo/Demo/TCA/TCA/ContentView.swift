//
//  ContentView.swift
//  TCA
//
//  Created by FSKJ on 2022/3/18.
//

/// 组合架构
/// - from: https://onevcat.com/2021/12/tca-1/

import ComposableArchitecture
import SwiftUI

struct Counter: Equatable, Identifiable {
    var count: Int = 0
    var secret = Int.random(in: -100 ... 100)
    
    var id: UUID = UUID()
}

extension Counter {
    var color: Color {
        if count >= 0 {
            return .green
        } else {
            return .red
        }
    }

    var countString: String {
        get { String(count) }
        set { count = Int(newValue) ?? count }
    }
    var countFloat: Float {
        get {Float(count)}
        set {count = Int(newValue)}
    }
}

extension Counter {
    enum CheckResult {
        case lower, equal, higher
    }

    var checkResult: CheckResult {
        if count < secret { return .lower }
        if count > secret { return .higher }
        return .equal
    }
}

enum CounterAction {
    case increment
    case decrement
    case setCount(String)
    case slidingCount(Float)
    case playNext
}

struct CounterEnvironment {
    var generateRandom: (ClosedRange<Int>) -> Int
    var uuid: () -> UUID

    static let live = CounterEnvironment(generateRandom: Int.random, uuid: UUID.init)
}

let counterReducer = Reducer<Counter, CounterAction, CounterEnvironment>.init { state, action, environment in
    switch action {
    case .increment:
        state.count += 1
        return .none
    case .decrement:
        state.count -= 1
        return .none
    case .playNext:
        state.secret = environment.generateRandom(-100...100)
        state.id = environment.uuid()
        return .none
    case let .setCount(text):
        state.countString = text
        return .none
    case let .slidingCount(float):
        state.countFloat = float
        return .none
    }
}.debug()

struct ContentView: View {
    let store: Store<Counter, CounterAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                checkLabel(with: viewStore.checkResult)
                HStack {
                    Button("-") {
                        viewStore.send(.decrement)
                    }
                    TextField(
                        String(viewStore.count),
                        text: viewStore.binding(
                            get: \.countString,
                            send: CounterAction.setCount
                        )
                    )
                    .frame(width: 40)
                    .foregroundColor(viewStore.color)

                    Button("+") {
                        viewStore.send(.increment)
                    }
                }
                Slider.init(
                    value: viewStore.binding(
                        get: \.countFloat,
                        send: CounterAction.slidingCount
                    ),
                    in: -100...100
                )
                Button("Next") {
                    viewStore.send(.playNext)
                }
            }.frame(width: 150)
        }
    }

    func checkLabel(with checkResult: Counter.CheckResult) -> some View {
        switch checkResult {
        case .lower:
            return Label("Lower", systemImage: "lessthan.circle")
                .foregroundColor(.red)
        case .equal:
            return Label("Correct", systemImage: "checkmark.circle")
                .foregroundColor(.green)
        case .higher:
            return Label("Higher", systemImage: "greaterthan.circle")
                .foregroundColor(.red)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store<Counter, CounterAction>.init(
            initialState: Counter(),
            reducer: counterReducer,
            environment: .live
        )
        )
    }
}
