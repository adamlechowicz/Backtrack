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
    private var curLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined
    @Published var active: Bool = false
    
    private var fh: URL? = nil

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.pausesLocationUpdatesAutomatically = true
        self.locationManager.distanceFilter = 100
        do{
            let dir = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)
            self.fh = dir.appendingPathComponent("backtrack.csv")
        } catch let error as NSError {
            NSLog("Problem opening the appropriate file: \(error)")
        }
    }
    
    public func start(){
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
        }
        self.active = true
    }
    
    public func stop(){
        if CLLocationManager.locationServicesEnabled(){
            self.locationManager.stopUpdatingLocation()
            self.locationManager.stopMonitoringSignificantLocationChanges()
        }
        self.active = false
    }
    
    public func toggle(){
        if self.active {
            self.stop()
        } else {
            self.start()
        }
    }
    
    public func getLocation(){
        locationManager.requestLocation()
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        NSLog("locations = \(locValue.latitude) \(locValue.longitude)")
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: now)
        
        let s = String(format: "%@,%f,%f\n", dateString, locValue.longitude, locValue.latitude)
        if (self.fh != nil){
            do {
                try s.write(to: self.fh!, atomically: true, encoding: .utf8)
            } catch {
                NSLog("Error")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("ERROR - No Location Received")
    }
}
