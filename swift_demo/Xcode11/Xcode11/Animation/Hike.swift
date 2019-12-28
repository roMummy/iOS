//
//  Hike.swift
//  Xcode11
//
//  Created by ZQ on 2019/10/14.
//  Copyright © 2019 xieshou. All rights reserved.
//

import SwiftUI

struct Hike: Codable, Hashable, Identifiable {
  var name: String
  var id: Int
  var distance: Double
  var difficulty: Int
  var observations: [Observation]
  
  static var formatter = LengthFormatter()

  var distanceText: String {
      return Hike.formatter
          .string(fromValue: distance, unit: .kilometer)
  }
  
  struct Observation: Codable, Hashable {
    var distanceFromStart: Double
    
    var elevation: Range<Double>
    var pace: Range<Double>
    var heartRate: Range<Double>
  }
}
