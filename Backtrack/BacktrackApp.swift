/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The top-level definition of the Landmarks app.
*/

import SwiftUI

@main
struct BacktrackApp: App {
    @StateObject private var locHelper = LocationHelper()
    @StateObject private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            AppView().environmentObject(locHelper).environmentObject(modelData)
        }
    }
}
