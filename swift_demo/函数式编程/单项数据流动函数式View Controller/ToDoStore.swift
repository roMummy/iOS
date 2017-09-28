//
//  ToDoStore.swift
//  TODO
//
//  Created by Max on 17/8/4.
//  Copyright © 2017年 lml. All rights reserved.
//

import UIKit
import Foundation

let dummy = [
    "Buy the milk",
    "Take my dog",
    "Rent a car"
]
struct ToDoStore {
    static let shared = ToDoStore()
    func getToDoItems(completionHandler:(([String]) -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { 
            completionHandler?(dummy)
        }
    }
}

