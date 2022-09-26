import UIKit

var greeting = "Hello, playground"

// MARK: - OOP

// protocol Event: Hashable {}
// class State<E: Event> {
//    weak var stateMachine: StateMachine<E>?
//
//    func trigger(event: E) {}
//
//    func enter() {
//        stateMachine?.currentState = self
//    }
//
//    func exit() {}
// }
// class StateMachine<E: Event> {
//    typealias FSMState = State<E>
//    var currentState: FSMState!
//
//    private var states: [FSMState] = []
//
//    init(initialState: FSMState) {
//        currentState = initialState
//    }
//
//    func setupStates(_states: [FSMState]) {
//        states = _states
//        states.forEach {$0.stateMachine = self}
//    }
//
//    func trigger(event: E) {
//        currentState.trigger(event: event)
//    }
//
//    func enter(_ stateClass: AnyClass) {
//        states.forEach {
//            if type(of: $0) == stateClass {
//                $0.enter()
//            }
//        }
//    }
// }

// enum RoleEvent: Event {
//    case clickRunButton
//    case clickWalkButton
// }
//
// class RunState: State<RoleEvent> {
//    override func trigger(event: RoleEvent) {
//        super.trigger(event: event)
//        switch event {
//        case .clickRunButton:
//            break
//        case .clickWalkButton:
//            self.exit()
//            stateMachine?.enter(WalkState.self)
//        }
//    }
//
//    override func enter() {
//        super.enter()
//        print("run enter")
//    }
//
//    override func exit() {
//        super.exit()
//        print("run exit")
//    }
// }
// class WalkState: State<RoleEvent> {
//    override func trigger(event: RoleEvent) {
//        super.trigger(event: event)
//        switch event {
//        case .clickRunButton:
//            self.exit()
//            stateMachine?.enter(RunState.self)
//        case .clickWalkButton:
//            break
//        }
//    }
//
//    override func enter() {
//        super.enter()
//        print("walk enter")
//    }
//
//    override func exit() {
//        super.exit()
//        print("walk exit")
//    }
// }

// let run = RunState()
// let walk = WalkState()

// let stateMachine = StateMachine(initialState: run)
// stateMachine.setupStates(_states: [run, walk])
//
// stateMachine.trigger(event: .clickRunButton)

// MARK: - 函数式

protocol Event: Hashable {}
protocol State: Hashable {}
public enum TransitionResult {
    case success
    case failure
}
public typealias ExecutionBlock = () -> Void
public typealias TransitionBlock = ((TransitionResult) -> Void)
public struct Transition<State, Event> {
    public let event: Event
    public let source: State
    public let destination: State
    let preAction: ExecutionBlock?
    let postAction: ExecutionBlock?

    public init(with event: Event,
                from: State,
                to: State,
                preBlock: ExecutionBlock?,
                postBlock: ExecutionBlock?) {
        self.event = event
        source = from
        destination = to
        preAction = preBlock
        postAction = postBlock
    }

    func executePreAction() {
        preAction?()
    }

    func executePostAction() {
        postAction?()
    }
}

class StateMachine<State: Hashable, Event: Hashable> {
    public var currentState: State {
        return {
            workingQueue.sync {
                return internalCurrentState
            }
        }()
    }

    private var internalCurrentState: State
    private var transitionsByEvent: [Event: [Transition<State, Event>]] = [:]

    private let lockQueue: DispatchQueue
    private let workingQueue: DispatchQueue
    private let callbackQueue: DispatchQueue
    public init(initialState: State, callbackQueue: DispatchQueue? = nil) {
        internalCurrentState = initialState
        lockQueue = DispatchQueue(label: "queue.lock")
        workingQueue = DispatchQueue(label: "queue.working")
        self.callbackQueue = callbackQueue ?? .main
    }

    public func add(transition: Transition<State, Event>) {
        lockQueue.sync {
            if let transitions = self.transitionsByEvent[transition.event] {
                let item = transitions.filter { $0.source == transition.source }
                if (item.count > 0) {
                    assertionFailure("Transition with event '\(transition.event)' and source '\(transition.source)' already existing.")
                }
                self.transitionsByEvent[transition.event]?.append(transition)
            } else {
                self.transitionsByEvent[transition.event] = [transition]
            }
        }
    }
    /// 接受事件，做出相应处理
    /// - Parameters:
    ///   - event: 触发的事件
    ///   - execution: 状态转移的过程中需要执行的 操作
    ///   - callBack: 状态转移的回调
    public func process(event: Event, execution: ExecutionBlock? = nil, callback: TransitionBlock? = nil) {
        var transitions: [Transition<State, Event>]?
        lockQueue.sync {
            transitions = self.transitionsByEvent[event]
        }

        workingQueue.async {
            let performableTransitions = transitions?.filter { $0.source == self.internalCurrentState } ?? []
            // 没有注册
            if performableTransitions.count == 0 {
                self.callbackQueue.async { callback?(.failure) }
                return
            }
            
            assert(performableTransitions.count == 1, "Found multiple transitions with event '(event)' and source '(self.internalCurrentState)'.")

            let transition = performableTransitions.first!

            self.callbackQueue.async {
                transition.executePreAction()
            }

            self.callbackQueue.async {
                execution?()
            }
            // 改变状态机状态
            self.internalCurrentState = transition.destination

            self.callbackQueue.async {
                transition.executePostAction()
            }

            self.callbackQueue.async {
                callback?(.success)
            }
        }
    }
}

enum EventType {
    case clickWalkButton
    case clickRunButton
}

enum StateType {
    case walk
    case run
}

typealias StateMachineDefault = StateMachine<StateType, EventType>
typealias TransitionDefault = Transition<StateType, EventType>

let stateMachine = StateMachineDefault.init(initialState: .walk)
let a = TransitionDefault.init(with: .clickWalkButton, from: .run, to: .walk) {
    print("准备walk")
} postBlock: {
    print("开始walk")
}

let b = TransitionDefault.init(with: .clickRunButton, from: .walk, to: .run) {
    print("准备run")
} postBlock: {
    print("开始run")
}

stateMachine.add(transition: a)
stateMachine.add(transition: b)

stateMachine.process(event: .clickRunButton) {
    print("---")
} callback: { result in
    switch result {
    case .success:
        print("转换成功")
    case .failure:
        print("转换失败")
    }
}

// MARK: - 实际案例
/// 键盘状态
enum KeyboardState: State {
    case prepareToEditText   // 准备编辑
    case prepareToRecord     // 准备录音
    case editingText         // 正在编辑
    case showingPannel       // 正在展示pannel
}
/// 触发事件
enum KeyboardEvent: Event {
    case clickSwitchButton    // 点击切换按钮
    case clickMoreButton      // 点击more按钮
    case tapTextField         // 点击输入框
    case vcDidTapped          // 点击控制器空白区域
}

