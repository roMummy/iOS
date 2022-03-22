//
//  TimerLabelTests.swift
//  TCATests
//
//  Created by FSKJ on 2022/3/18.
//

import XCTest
import ComposableArchitecture
@testable import TCA


class TimerLabelTests: XCTestCase {
    let scheduler = DispatchQueue.test
    
    func testTimerUpdate() throws {
        let store = TestStore(
            initialState: TimerState(),
            reducer: timerReducer,
            environment: TimerEnvironment(
                date: {Date(timeIntervalSince1970: 100)},
                mainQueue: scheduler.eraseToAnyScheduler()
            )
        )
        
        store.send(.start) {
            $0.started = Date(timeIntervalSince1970: 100)
        }
        
        scheduler.advance(by: .milliseconds(35))
        store.receive(.timeUpdated) {
            $0.duration = 0.01
        }
        store.receive(.timeUpdated) {
            $0.duration = 0.02
        }
        store.receive(.timeUpdated) {
            $0.duration = 0.03
        }
        store.send(.stop)
    }
}
