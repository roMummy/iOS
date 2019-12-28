//
//  Landmark.swift
//  Xcode11
//
//  Created by ZQ on 2019/9/30.
//  Copyright © 2019 xieshou. All rights reserved.
//

import SwiftUI
import CoreLocation

struct Landmark: Hashable, Codable, Identifiable {
  var id: Int
  var name: String
  fileprivate var imageName: String
  fileprivate var coordinates: Coordinates
  
  var state: String
  var park: String
  var category: Category
  var isFavorite: Bool
  
  var locationCoordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
  }
  enum Category: String, CaseIterable, Codable, Hashable {
    case featured = "Featured"
    case lakes = "Lakes"
    case rivers = "Rivers"
  }
}

extension Landmark {
  var image: Image {
    Image.init(imageName)
  }
}

struct Coordinates: Hashable, Codable {
  var latitude: Double
  var longitude: Double
}
