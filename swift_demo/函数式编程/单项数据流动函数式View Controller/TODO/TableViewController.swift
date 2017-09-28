//
//  TableViewController.swift
//  TODO
//
//  Created by Max on 17/8/4.
//  Copyright © 2017年 lml. All rights reserved.
//

import UIKit

let inputCellReuseId = "inputCell"
let todoCellResueId = "todoCell"

protocol ActionType {}
protocol StateType {}
protocol CommandType {}

class TableViewController: UITableViewController {

    struct State: StateType {
        var dataSource = TabelViewControllerDataSource(todos: [], owner: nil)
        var text: String = ""
    }
    
    enum Action: ActionType {
        case updataText(text: String)
        case addToDos(items: [String])
        case removeToDo(index: Int)
        case loadToDos
    }
    
    enum Command: CommandType {
        case loadToDos(completion: ([String]) -> Void)
    }
    
    var store: Store<Action, State, Command>!
    
    lazy var reducer: (State, Action) -> (state: State, command: Command?) = {
        [weak self] (state: State, action: Action) in
        
        var state = state
        var command: Command? = nil
        
        switch action {
        case .updataText(let text):
            state.text = text
        case .addToDos(let items):
            state.dataSource = TabelViewControllerDataSource(todos: items + state.dataSource.todos, owner: state.dataSource.owner)
        case .removeToDo(let index):
            state.dataSource.todos.remove(at: index)
        case .loadToDos:
            command = Command.loadToDos { self?.store.dispatch(.addToDos(items: $0))
            }
        }
        return (state, command)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置nav rightBar的初始状态
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let dataSource = TabelViewControllerDataSource(todos: [], owner: self)
        store = Store<Action, State, Command>(reducer: reducer, initialState: State(dataSource: dataSource, text: ""))
        
        //订阅 store
        store.subscribe {
            [weak self] state, previousState, command in
            self?.stateDidChanged(state: state, previousState: previousState, command: command)
        }
        
        //初始化UI
        stateDidChanged(state: store.state, previousState: nil, command: nil)
        
        //开始异步加载 ToDos
        store.dispatch(.loadToDos)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismiss(animated: true, completion: nil)
        }
        //获取数据
        
//        ToDoStore.shared.getToDoItems {(data) in
//            self.state = State(todos: self.state.todos + data, text: self.state.text)
//        }
        //注册cell
        self.tableView.register(TableViewInputCell.self, forCellReuseIdentifier: inputCellReuseId)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: todoCellResueId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func stateDidChanged(state: State, previousState: State?, command: Command?) {
        
        if let command = command {
            switch command {
            case .loadToDos(let handler):
                ToDoStore.shared.getToDoItems(completionHandler: handler)
        }
        //状态不一样 更新UI
        if previousState == nil || previousState!.dataSource.todos != state.dataSource.todos {
            let dataSource = state.dataSource
            self.tableView.dataSource = dataSource
            self.tableView.reloadData()
            title = "TODO - (\(dataSource.todos.count))"
        }
        
        if previousState == nil  || previousState!.text != state.text {
            let isItemLengthEnough = state.text.characters.count >= 3
            navigationItem.rightBarButtonItem?.isEnabled = isItemLengthEnough
            
            let inputIndexPath = IndexPath(row: 0, section:TabelViewControllerDataSource.Section.input.rawValue)
            let inputCell = self.tableView.cellForRow(at: inputIndexPath) as? TableViewInputCell
            inputCell?.textField.text = state.text
            }
        }
    }
   
    //移除待办
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == TabelViewControllerDataSource.Section.todos.rawValue else {
            return
        }
//        todos.remove(at: indexPath.row)
//        title = "TODO - (\(todos.count))"
//        tableView.reloadData()
//        state.todos.remove(at: indexPath.row)
        store.dispatch(.removeToDo(index: indexPath.row))
    }
    
    //添加待办
   @IBAction func addButtonPressed(_ sender: Any) {
        store.dispatch(.addToDos(items: [store.state.text]))
        store.dispatch(.updataText(text: ""))
    }
    
}

extension TableViewController: TableViewInputCellDelegate {
    func inputChanged(cell: TableViewInputCell, text: String) {
        store.dispatch(.updataText(text: text))
    }
}





