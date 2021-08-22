/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The top-level definition of the Landmarks app.
*/

import SwiftUI

@main
struct BacktrackApp: App {
    @StateObject private var locHelper = LocationHelper()
    private var modelData: ModelData?
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init(){
        self.modelData = ModelData(locHelper)
    }
    
    var body: some Scene {
        WindowGroup {
            AppView().environmentObject(locHelper).environmentObject(modelData!)
        }
    }
}
