//
//  LandmarkList.swift
//  Xcode11
//
//  Created by ZQ on 2019/10/10.
//  Copyright © 2019 xieshou. All rights reserved.
//

import SwiftUI

struct LandmarkList: View {
  @EnvironmentObject var userData: UserData
  
  var body: some View {
    NavigationView {
      List {
        
        Toggle(isOn: $userData.showFavoritesOnly) {
          Text("Favorites only")
        }
        
        ForEach(userData.landmarks) { (landmark: Landmark) in
          if !self.userData.showFavoritesOnly || landmark.isFavorite {
            NavigationLink(destination: LandmarkDetail(landmark: landmark)) {
              LandmarkRow(landmark: landmark)
            }
          }
        }
        
      }
      .navigationBarTitle(Text("Landmarks"))
    }
    
  }
  
}

struct LandmarkList_Previews: PreviewProvider {
  static var previews: some View {
//    LandmarkList().previewDevice(PreviewDevice(rawValue: "iPhone SE"))
    ForEach(["iPhone SE", "iPhone XS Max"], id: \.self) { deviceName in
      LandmarkList()
        .environmentObject(UserData())
        .previewDevice(PreviewDevice(rawValue: deviceName))
        .previewDisplayName(deviceName)
    }
  }
}
