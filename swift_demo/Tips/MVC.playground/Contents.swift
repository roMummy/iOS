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
    static let toDoStoreDidChangedNotification = Notification.Name(rawValue: "com.onevcat.app.ToDoStoreDidChangedNotification")
}
extension Notification.UserInfoKey {
    static var toDoStoreDidChangedChangeBehaviorKey: Notification.UserInfoKey<ToDoStore.ChangeBehavior> {
        return Notification.UserInfoKey(key: "com.onevcat.app.ToDoStoreDidChangedNotification.ChangeBehavior")
    }
}
extension NotificationCenter {
    func post<T>(name aName: NSNotification.Name, object anObject: Any?, typedUserInfo aUserInfo: [Notification.UserInfoKey<T> : T]? = nil) {
        post(name: aName, object: anObject, userInfo: aUserInfo)
    }
}

struct ToDoItem {
    
    typealias ItemId = UUID
    
    let id: ItemId
    let title: String
    
    init(title: String) {
        self.id = ItemId()
        self.title = title
    }
}

class ToDoStore {
    
    enum ChangeBehavior {
        case add([Int])
        case remove([Int])
        case reload
    }
    
    static let shared = ToDoStore()
    
    static func diff(original: [ToDoItem], now: [ToDoItem]) -> ChangeBehavior {
        let originalSet = Set(original)
        let nowSet = Set(now)
        
        if originalSet.isSubset(of: nowSet) { // Appended
            let added = nowSet.subtracting(originalSet)
            let indexes = added.compactMap { now.index(of: $0) }
            return .add(indexes)
        } else if (nowSet.isSubset(of: originalSet)) { // Removed
            let removed = originalSet.subtracting(nowSet)
            let indexes = removed.compactMap { original.index(of: $0) }
            return .remove(indexes)
        } else { // Both appended and removed
            return .reload
        }
    }
    
    private var items: [ToDoItem] = [] {
        didSet {
            let behavior = ToDoStore.diff(original: oldValue, now: items)
            NotificationCenter.default.post(
                name: .toDoStoreDidChangedNotification,
                object: self,
                typedUserInfo: [.toDoStoreDidChangedChangeBehaviorKey: behavior]
            )
        }
    }
    
    private init() {}
    
    func append(item: ToDoItem) {
        items.append(item)
    }
    
    func append(newItems: [ToDoItem]) {
        items.append(contentsOf: newItems)
    }
    
    func remove(item: ToDoItem) {
        guard let index = items.index(of: item) else { return }
        remove(at: index)
    }
    
    func remove(at index: Int) {
        items.remove(at: index)
    }
    
    func edit(original: ToDoItem, new: ToDoItem) {
        guard let index = items.index(of: original) else { return }
        items[index] = new
    }
    
    var count: Int {
        return items.count
    }
    
    func item(at index: Int) -> ToDoItem {
        return items[index]
    }
}

extension ToDoItem: Hashable {
    var hashValue: Int {
        return id.hashValue
    }
}
extension ToDoItem: Equatable {
    public static func == (lhs: ToDoItem, rhs: ToDoItem) -> Bool {
        return lhs.id == rhs.id
    }
}

private let cellIdentifier = "ToDoItemCell"

class ToDoListViewController: UITableViewController {
    
    weak var addButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        addButton = navigationItem.rightBarButtonItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(todoItemsDidChange), name: .toDoStoreDidChangedNotification, object: nil)
    }
    
    private func syncTableView(for behavior: ToDoStore.ChangeBehavior) {
        switch behavior {
        case .add(let indexes):
            let indexPathes = indexes.map { IndexPath(row: $0, section: 0) }
            tableView.insertRows(at: indexPathes, with: .automatic)
        case .remove(let indexes):
            let indexPathes = indexes.map { IndexPath(row: $0, section: 0) }
            tableView.deleteRows(at: indexPathes, with: .automatic)
        case .reload:
            tableView.reloadData()
        }
    }
    
    private func updateAddButtonState() {
        addButton?.isEnabled = ToDoStore.shared.count < 10
    }
    
    @objc func todoItemsDidChange(_ notification: Notification) {
        let behavior = notification.getUserInfo(for: .toDoStoreDidChangedChangeBehaviorKey)
        syncTableView(for: behavior)
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
        return ToDoStore.shared.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = ToDoStore.shared.item(at: indexPath.row).title
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
