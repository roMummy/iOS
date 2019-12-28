//
//  ContentView.swift
//  Xcode11
//
//  Created by ZQ on 2019/9/29.
//  Copyright © 2019 xieshou. All rights reserved.
//

import SwiftUI
import Combine

struct LandmarkDetail: View {
  @EnvironmentObject var userData: UserData
  var landmark: Landmark
  
  var landmarkIndex: Int {
    userData.landmarks.firstIndex(where: {$0.id == landmark.id})!
  }
  
  var body: some View {
    VStack {
      MapView(coordinate: landmark.locationCoordinate)
        .edgesIgnoringSafeArea(.top)
        .frame(height: 300)
      
      CircleImage(image: landmark.image)
        .offset(y: -100)
        .padding(.bottom, -100)
      
      VStack(alignment: .leading) {
        HStack {
          Text(landmark.name)
          .font(.title)
          .foregroundColor(.red)
          
          Button(action: {
            self.userData.landmarks[self.landmarkIndex].isFavorite.toggle()
          }) {
            if self.userData.landmarks[self.landmarkIndex].isFavorite {
              Image(systemName: "star.fill")
                .foregroundColor(Color.yellow)
            } else {
              Image(systemName: "star.fill")
                .foregroundColor(Color.gray)
            }
          }
        }
                
        HStack {
          Text(landmark.park)
            .font(.subheadline)
          Spacer()
          Text(landmark.state)
            .font(.subheadline)
        }
      }
      .padding()
      
      Spacer()
    }
    .navigationBarTitle(Text(landmark.name), displayMode: .inline)
  }
}

struct LandmarkDetail_Previews: PreviewProvider {
  static var previews: some View {
    LandmarkDetail(landmark: landmarkData[0])
      .environmentObject(UserData())
  }
}
