//
//  LocationHelper.swift
//  Backtrack
//
//  Created by Adam Lechowicz on 7/2/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import Combine
import AVFoundation
import CloudKit
import MapKit
import CoreLocation

class LocationHelper: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined

    override init() {
        super.init()
        self.locationManager.delegate = self
    }

    public func requestAuth(always: Bool = false) {
        if always {
            self.locationManager.requestAlwaysAuthorization()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    public func doSomethingStupid(){
        NSLog("Something Stupid!")
    }
}

extension LocationHelper: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorisationStatus = status
    }
}
