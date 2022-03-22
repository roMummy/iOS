//
//  TCATests.swift
//  TCATests
//
//  Created by FSKJ on 2022/3/18.
//

import XCTest
@testable import TCA
import ComposableArchitecture

extension CounterEnvironment {
    static let test = CounterEnvironment(generateRandom: {_ in 5}, uuid: UUID.init)
}


class TCATests: XCTestCase {
    var store: TestStore<Counter, Counter, CounterAction, CounterAction, CounterEnvironment>?
    
    override func setUp() {
        store = TestStore(
            initialState: Counter(count: Int.random(in: -100...100)),
            reducer: counterReducer,
            environment: .test
        )
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

//    func testReset() throws {
//        store?.send(.playNext, { state in
//            state = Counter(count: 0, secret: 5)
//        })
//    }
}
