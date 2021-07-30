//
//  Delegate.swift
//  Backtrack
//
//  Created by Adam Lechowicz on 7/4/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        MKiCloudSync.start(withPrefix: "sync")
        return true
    }
}
