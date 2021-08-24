/*
See LICENSE folder for licensing information.

Abstract:
The top-level definition of Backtrack.
*/

import SwiftUI

@main
struct BacktrackApp: App {
    private var locHelper = LocationHelper()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            AppView().environmentObject(locHelper).environmentObject(ModelData(locHelper))
        }
    }
}
