import UIKit

/// soucre: https://onevcat.com/2020/11/codable-default/

var str = "Hello, playground"

protocol DefaultValue {
  associatedtype Value: Decodable
  static var defaultValue: Value {get}
}

@propertyWrapper
struct Default<T: DefaultValue> {
  var wrappedValue: T.Value
}
extension Default: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    wrappedValue = (try? container.decode(T.Value.self)) ?? T.defaultValue
  }
}
//extension Default: Encodable {
//  func encode(to encoder: Encoder) throws {
//    var container = try encoder.singleValueContainer()
//    wrappedValue = container.encode(to: T.Value.self) as! T.Value
//  }
//}

extension KeyedDecodingContainer {
  func decode<T>(_ type: Default<T>.Type,
                 forKey key: Key) throws -> Default<T> where T: DefaultValue {
    try decodeIfPresent(type, forKey: key) ?? Default(wrappedValue: T.defaultValue)
  }
}

extension Bool: DefaultValue {
  static var defaultValue = false
}

extension Bool {
  struct False: DefaultValue {
    static let defaultValue = false
  }
  struct True: DefaultValue {
    static var defaultValue = true
  }
}
extension Default {
  typealias False = Default<Bool.False>
  typealias True = Default<Bool.True>
}

enum State: String, Decodable {
  case unknown
  case streaming
  case archived
}
extension State: DefaultValue {
  static var defaultValue = State.unknown
}
extension State {
  struct Unknown: DefaultValue {
    static var defaultValue = State.unknown
  }
}
extension Default {
  typealias Unknown = Default<State.Unknown>
}

struct Item: Decodable {
  
  @Default.False
  var commentEnabled: Bool
  
  @Default.Unknown
  var state: State
  
  var type: Type?
}
struct Type: RawRepresentable, Decodable {
  static let streaming = Type(rawValue: "streaming")
  static let archived = Type(rawValue: "archived")
  
  var rawValue: String
}

let json = "{\"id\": 12345, \"title\": \"My First Video\", \"state\": \"streamingg\", \"type\": \"streamingg\"}"

let item = try JSONDecoder().decode(Item.self, from: json.data(using: .utf8)!)

print(item.commentEnabled)
print(item.state)
print(item.type?.rawValue ?? "")
//print(item.type == .archived)

