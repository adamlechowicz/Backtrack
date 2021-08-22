//
//  AppView.swift
//  Backtrack
//
//  Created by Adam Lechowicz on 4/9/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

struct AppView: View {
    @State private var selection = 1
    //@EnvironmentObject var model: Model
    @EnvironmentObject var locHelper: LocationHelper
    
    var body: some View {
        TabView(selection: $selection) {
            ConfigView(toggle_iCloudOn: self.locHelper.iCloudActive, filter_selection: self.locHelper.distanceFilterVal)
                .tabItem {
                    Image(systemName: "gearshape.2.fill")
                    Text("Config")
                }
                .tag(1)
            DataView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("View Data")
                }
                .tag(2)
        }.onAppear(){
            if(self.locHelper.authorisationStatus != .authorizedAlways){
                self.locHelper.requestAuth(always: true)
            }
            do{
                let dir = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)
                let fh = dir.appendingPathComponent("test.txt")
                NSLog(fh.absoluteString)
                do {
                    try "Hello World".write(to: fh, atomically: true, encoding: .utf8)
                } catch {
                    NSLog("Error")
                }
            } catch let error as NSError {
                NSLog("Problem opening the appropriate file: \(error)")
            }
        }
        .accentColor(self.locHelper.active ? Color(UIColor(named: "EmeraldGreen") ?? .green) : Color(UIColor(named: "OceanBlue") ?? .blue))
        
    }
}



struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView().environmentObject(LocationHelper()).environmentObject(ModelData(LocationHelper()))
    }
}
