//
//  ConfigView.swift
//  Backtrack
//
//  Created by Adam Lechowicz on 7/4/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import SwiftUI

struct ConfigView: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var locHelper: LocationHelper
    @Environment(\.colorScheme) var colorScheme
    @State var toggle_iCloudOn: Bool
    
    let screenWidth = UIScreen.main.bounds.size.width
    
    var body: some View {
        VStack{
            HStack{
                Toggle(isOn: $toggle_iCloudOn, label: {
                    Image(systemName: "icloud.fill")
                    Text("iCloud Logging: ")
                    Text(toggle_iCloudOn ? "ON" : "OFF")
                        .bold().foregroundColor(self.locHelper.active ? Color(UIColor(named: "EmeraldGreen") ?? .green) : Color(UIColor(named: "OceanBlue") ?? .blue))
                })
                    .onChange(of: toggle_iCloudOn, perform: { value in
                        self.locHelper.iCloudToggle()
                    })
            }.disabled(!self.locHelper.iCloudAvail).padding(.all).toggleStyle(SwitchToggleStyle(tint: (self.locHelper.active ? .green : .blue)))
            Button(action:{
                self.locHelper.doSomethingStupid()
                self.locHelper.toggle()
                    }){
                HStack {
                    Text(self.locHelper.active ? "Stop Backtracking" : "Start Backtracking").foregroundColor(self.locHelper.active ? .black : .white)
                }
                    .padding(.horizontal, 40.0)
                    .padding(.vertical, 15.0)
                    .background(Color(self.locHelper.active ? .green : .blue))
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(17.0)
            }.buttonStyle(SimpleButtonStyle())
        }.onAppear(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                
            }
        }
        .navigationBarTitle("Home", displayMode: .large)
    }
    
}


struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView(toggle_iCloudOn: false).previewDevice("iPhone 8").environmentObject(ModelData()).environmentObject(LocationHelper())
    }
}

