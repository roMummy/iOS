import UIKit

var str = "Hello, playground"


//class ChatOption {
//  var name: String?
//  var users: [String]?
//  var tags: [String]?
//
//  static func withName(name: String) -> ((_ opt: ChatOption) -> Void) {
//    return { opt in
//      opt.name = name
//    }
//  }
//
//  static func withUsers(users: [String]) -> ((_ opt: ChatOption) -> Void) {
//    return { opt in
//      opt.users = users
//    }
//  }
//
//  static func withTags(tags: [String]) -> ((_ opt: ChatOption) -> Void) {
//    return { opt in
//      opt.tags = tags
//    }
//  }
//}
//
//func createChat(opts: [(ChatOption) -> Void]) {
//  let option = ChatOption()
//  for opt in opts {
//    opt(option)
//  }
//  print("\(option.name), \(option.users), \(option.tags)")
//}
//
////func createChat(opts: ((ChatOption) -> Void) ...) {
////  createChat(opts: opts)
////}
//
//
//createChat(opts: [ChatOption.withName(name: "张三"),
//                  ChatOption.withUsers(users: ["1","2"]),
//                  ChatOption.withTags(tags: ["tag1","tag2"])
//                  ])


class ChatListOption {
  var chatIds: [String] = []
  
  static func withIds(ids: [String]) -> ((_ opt: ChatListOption) -> Void) {
    return { opt in
      
    }
  }
  
  static func withUsers(users: [String]) -> ((_ opt: ChatListOption) -> Void) {
    return { opt in
      
    }
  }
  
  static func withTags(tags: [String]) -> ((_ opt: ChatListOption) -> Void) {
    return { opt in
      
    }
  }
  
  static func merge(opts: [(ChatListOption) -> Void]) {
    guard !opts.isEmpty else {
      return
    }
    var opts = opts
    let opt = opts.removeFirst()
    
    opt(ChatListOption())
  }
}

func createChatList(opts: [(ChatListOption) -> Void]) -> [String] {
  let option = ChatListOption()
  for opt in opts {
    opt(option)
  }
  print(option.chatIds)
  return option.chatIds
}
