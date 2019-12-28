//
//  Data.swift
//  Xcode11
//
//  Created by ZQ on 2019/10/10.
//  Copyright © 2019 xieshou. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation


let landmarkData: [Landmark] = load("landmarkData.geojson")

func load<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
  let data: Data
  
  guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
    fatalError("error")
  }
  
  do {
    data = try Data(contentsOf: file)
  } catch {
    fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
  }
  
  do {
    let decoder = JSONDecoder()
    return try decoder.decode(T.self, from: data)
  } catch {
    fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
  }
}
