//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

extension Notification {
    struct UserInfoKey<ValueType>: Hashable {
        let key: String
    }
    func getUserInfo<T>(for key: Notification.UserInfoKey<T>) -> T {
        return userInfo![key] as! T
    }
}
extension Notification.Name {
    static let toDoStoreDidChangeNotification = Notification.Name(rawValue: "com.app.ToDoStoreDidChangeNotification")
}

extension Notification.UserInfoKey {
    static var toDoStoreDidChangedBehaviorKey: Notification.UserInfoKey<ToDoStore.ChangeBehavior> {
        return Notification.UserInfoKey(key: "com.app.com.app.ToDoStoreDidChangeNotification.ChangeBehavior")
    }
}

extension NotificationCenter {
    func post<T>(name aname: NSNotification.Name, object anObject: Any?, typedUserInfo aUserInfo: [Notification.UserInfoKey<T>: T]? = nil) {
        post(name: aname, object: anObject, userInfo: aUserInfo)
    }
}

struct ToDoItem {
    let id: UUID
    let title: String
    
    init(title: String) {
        self.id = UUID()
        self.title = title
    }
}
extension ToDoItem: Equatable {
    public static func == (lhs: ToDoItem, rhs: ToDoItem) -> Bool {
        return lhs.id == lhs.id
    }
}

extension ToDoItem: Hashable {
    var hashValue: Int {
        return self.id.hashValue
    }
}

class ToDoStore {
    static let shared = ToDoStore()
    
//    private(set) var items: [ToDoItem] = []
    private init(){}
    
    enum ChangeBehavior {
        case add([Int])
        case remove([Int])
        case reload
    }
    
    static func diff(original: [ToDoItem], now: [ToDoItem]) -> ChangeBehavior {
        let originalSet = Set<ToDoItem>(original)
        let nowSet = Set<ToDoItem>(now)
        
        if originalSet.isSubset(of: nowSet) {//append
            let added = nowSet.subtracting(originalSet)
            let indexes = added.compactMap {now.index(of: $0)}
            return .add(indexes)
        }else if (nowSet.isSubset(of: originalSet)) {// remove
            let removed = originalSet.subtracting(nowSet)
            let indexes = removed.compactMap {original.index(of: $0)}
            return .remove(indexes)
        }else {
            return .reload
        }
        
    }
    
    private var items: [ToDoItem] = [] {
        didSet {
            let behavior = ToDoStore.diff(original: oldValue, now: items)
            NotificationCenter.default.post(name: .toDoStoreDidChangeNotification, object: self, typedUserInfo: [.toDoStoreDidChangedBehaviorKey: behavior])
        }
    }
    
    func append(item: ToDoItem) {
        items.append(item)
    }
    
    @discardableResult
    func remove(item: ToDoItem) -> (isRemoved: Bool, oldItme: ToDoItem?) {
        guard let index = items.index(of: item) else {
            return (false, nil)
        }
        items.remove(at: index)
        return (true, item)
    }
    
    func remove(at index: Int) {
        items.remove(at: index)
    }
    
    func edit(original: ToDoItem, new: ToDoItem) {
        guard let index = items.index(of: original) else {
            return
        }
        items[index] = new
    }
    
    var count: Int {
        return items.count
    }
    
    func item(at index: Int) -> ToDoItem {
        return  items[index]
    }
    
//    func getAll(completion: @escaping ([ToDoItem]?, Error?) -> Void?) {
//        NetworkService.getExistingToDoItems { response, error in
//            if let error = error {
//                completion?(nil, error)
//            } else {
//                self.items = response.items
//                completion?(response.items, nil)
//            }
//        }
//    }
    
}


private let cellIdentifier = "ToDoItemCell"

class ToDoListViewController: UITableViewController {
    var items: [ToDoItem] = []
    weak var addButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        addButton = navigationItem.rightBarButtonItem
        
        // 添加通知 接受模型数据变更
        NotificationCenter.default.addObserver(self, selector: #selector(todoItemsDidChange), name: .toDoStoreDidChangeNotification, object: nil)
    }
    
    // 界面更新
    private func syncTableView (for behavior: ToDoStore.ChangeBehavior) {
        switch behavior {
        case .add(let indexes):
            let indexPathes = indexes.map{IndexPath.init(row: $0, section: 0)}
            tableView.insertRows(at: indexPathes, with: .automatic)
        case .remove(let indexes):
            let indexPathes = indexes.map{IndexPath.init(row: $0, section: 0)}
            tableView.deleteRows(at: indexPathes, with: .automatic)
        case .reload:
            tableView.reloadData()
        }
    }
    private func updateAddButtonState() {
        addButton?.isEnabled = ToDoStore.shared.count < 10
    }
    
    @objc func todoItemsDidChange(_ notification: Notification) {
        let behavior = notification.getUserInfo(for: .toDoStoreDidChangedBehaviorKey)
        // 更新界面
        syncTableView(for: behavior)
        // 更新按钮
        updateAddButtonState()
    }
    
    @objc func addButtonPressed(_ sender: Any) {
        let store = ToDoStore.shared
        let newCount = store.count + 1
        let title = "ToDo Item \(newCount)"
        
        store.append(item: .init(title: title))
    }
}

extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, view, done in
            
            ToDoStore.shared.remove(at: indexPath.row)
            done(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

let navigationViewController = UINavigationController(rootViewController: ToDoListViewController())
PlaygroundPage.current.liveView = navigationViewController
