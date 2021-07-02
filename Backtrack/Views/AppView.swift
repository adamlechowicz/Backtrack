//
//  AppView.swift
//  UMass Architecture
//
//  Created by Adam Lechowicz on 4/9/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

struct AppView: View {
    @State private var selection = 2
    //@EnvironmentObject var model: Model
    //@EnvironmentObject var player: Player
    
    var body: some View {
        TabView(selection: $selection) {
            LandmarkList()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Index")
                }
                .tag(1)
            LandmarkList()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(2)
        }
        .accentColor(.green)
        
    }
}



struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .environmentObject(ModelData())
    }
}
