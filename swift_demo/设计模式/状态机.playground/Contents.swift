import UIKit
import Foundation

protocol StateType: Hashable {}
protocol EventType: Hashable {}

enum State: StateType {
  case connected
  case connecting
  case disconnect
}

enum Event: EventType {
    case getAccount
    case gotoLogin
    case
    case backToIdle
}

struct Transition<S: StateType, E: EventType> {
    
    let event: E
    let fromState: S
    let toState: S
    
    init(event: E, fromState: S, toState: S) {
        self.event = event
        self.fromState = fromState
        self.toState = toState
    }
    
}

class StateMachine<S: StateType, E: EventType> {
    
    private struct Operation<S: StateType, E: EventType> {
        let transition: Transition<S, E>
        let triggerCallback: (Transition<S, E>) -> Void
    }
    
    private var routes = [S: [E: Operation<S, E>]]()
    
    private(set) var currentState: S
    private(set) var lastState: S?
    
    init(_ currentState: S) {
        self.currentState = currentState
    }
    
    func listen(_ event: E, transit fromStates:[S], to toState: S, callback: @escaping (Transition<S, E>) -> Void) {
        for fromState in fromStates {
            listen(event, transit: fromState, to: toState, callback: callback)
        }
    }
    
    func listen(_ event: E, transit fromState: S, to toState: S, callback: @escaping (Transition<S, E>) -> Void) {
        var route = routes[fromState] ?? [:]
        let transition = Transition(event: event, fromState: fromState, toState: toState)
        let operation = Operation(transition: transition, triggerCallback: callback)
        route[event] = operation
        routes[fromState] = route
    }
    
    func trigger(_ event: E) {
        guard let route = routes[currentState]?[event] else { return }
        
        route.triggerCallback(route.transition)
        lastState = currentState
        currentState = route.transition.toState
    }
    
}


let stateMachine = StateMachine<State, Event>(.disconnect)

//stateMachine.listen(.startWork, transit: .idle, to: .work) { (transition) in
//  print(transition.event)
//}
//
//stateMachine.trigger(.startWork)

