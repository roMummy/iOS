import UIKit

var str = "Hello, playground"

/// 桥接
protocol Appliance {
  func run()
}

protocol Switch {
  var appliance: Appliance {get set}
  func turnOn()
}

class RemoteControl: Switch {
  var appliance: Appliance
  
  func turnOn() {
    self.appliance.run()
  }
  
  init(appliance: Appliance) {
    self.appliance = appliance
  }
}

class TV: Appliance {
  func run() {
    print("tv run")
  }
}

class Iphone: Appliance {
  func run() {
    print("iphone run")
  }
}

let tvRC = RemoteControl(appliance: TV())
tvRC.turnOn()

let iphoneRC = RemoteControl(appliance: Iphone())
iphoneRC.turnOn()


/// 多重变化混合
//protocol Message {
//  func sendMessage()
//}
//
//protocol UrgencyMessage: Message {
//  func urgency()
//}
//
//class CommonMessageSMS: Message {
//  func sendMessage() {
//    print("SMS")
//  }
//}
//
//class CommonMessageEmail: Message {
//  func sendMessage() {
//    print("Email")
//  }
//}
//
//class UrgencyMessageSMS: UrgencyMessage {
//  func sendMessage() {
//    print("SMS")
//  }
//  func urgency() {
//    print("urgency")
//  }
//}
//
//class UrgencyMessageEmail: UrgencyMessage {
//  func sendMessage() {
//    print("email")
//  }
//  func urgency() {
//    print("urgency email")
//  }
//}

protocol MessageImplement {
  func sendMessage(text: String)
}

class AbstractMessage {
  let messageIm: MessageImplement
  
  init(implement: MessageImplement) {
    self.messageIm = implement
  }
  
  func send(message: String) {
    
  }
}

class CommonMessage: AbstractMessage {
  override func send(message: String) {
    self.messageIm.sendMessage(text: message)
  }
}

class MessageSMS: MessageImplement {
  func sendMessage(text: String) {
    print("sms："+text)
  }
}

let message = MessageSMS()
let a = CommonMessage(implement: message)
a.send(message: "你好")



/**
 桥接模式对比继承的有点是把本来混在一起的两个变化未读分开，让他们独立变化，这样互相不影响，减少了类的数目，也方便扩展，而且可以动态替换功能。比如上面的消息发送功能，同样是发送普通消息，我可以选择手机、email其中的任何一种方式，只需要组合起来就行了，比继承更加灵活。
 */
