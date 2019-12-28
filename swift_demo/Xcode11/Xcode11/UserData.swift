//
//  UserData.swift
//  Xcode11
//
//  Created by ZQ on 2019/10/10.
//  Copyright © 2019 xieshou. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class UserData: ObservableObject {
  @Published var showFavoritesOnly = false
  @Published var landmarks = landmarkData
  
}


