//
//  BadgeSymbol.swift
//  Xcode11
//
//  Created by ZQ on 2019/10/11.
//  Copyright © 2019 xieshou. All rights reserved.
//

import SwiftUI

struct BadgeSymbol: View {
  static let symbolColor = Color(red: 79.0 / 255, green: 79.0 / 255, blue: 191.0 / 255)
  
  var body: some View {
    GeometryReader { geometry in
      Path { path in
        let width = min(geometry.size.width, geometry.size.height)
        let height = width * 0.75
        let spacing = width * 0.03
        let middle = width / 2
        let topWidth = 0.226 * width
        let topHeight = 0.488 * height
        
        path.addLines([
          .init(x: middle, y: spacing),
          .init(x: middle - topWidth, y: topHeight - spacing),
          .init(x: middle, y: topHeight / 2 + spacing),
          .init(x: middle + topWidth, y: topHeight - spacing),
          .init(x: middle, y: spacing)
        ])
        
        path.move(to: .init(x: middle, y: topHeight / 2 + spacing * 3))
        
        path.addLines([
          .init(x: middle - topWidth, y: topHeight + spacing),
          .init(x: spacing, y: height - spacing),
          .init(x: width - spacing, y: height - spacing),
          .init(x: middle + topWidth, y: topHeight + spacing),
          .init(x: middle , y: topHeight / 2 + spacing * 3)
        ])
      }
      .fill(Self.symbolColor)
    }
  }
}

struct BadgeSymbol_Previews: PreviewProvider {
  static var previews: some View {
    BadgeSymbol()
  }
}
