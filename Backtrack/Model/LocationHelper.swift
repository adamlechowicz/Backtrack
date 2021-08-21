//
//  LocationHelper.swift
//  Backtrack
//
//  Created by Adam Lechowicz on 7/2/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import Combine
import MapKit
import UIKit
import CoreLocation

class LocationHelper: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    private let userDefaults = UserDefaults.standard
    private var lastLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined
    @Published var active: Bool = false
    @Published var iCloudAvail: Bool = false
    @Published var iCloudActive: Bool = true
    @Published var currentDevice: String = ""
    @Published var distanceFilterVal: Int = 200
    
    private var fh: URL? = nil

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.pausesLocationUpdatesAutomatically = false
        
        // get User Settings from local account, which will be synced with iCloud
        if userDefaults.value(forKey: "sync") == nil { // set default values at first launch
            userDefaults.set("Backtrack", forKey: "sync")
            userDefaults.set(200, forKey: "syncDistanceFilter")
            userDefaults.set(false, forKey: "syncActive")
            userDefaults.set(true, forKey: "synciCloudActive")
        }
        
        self.iCloudActive = userDefaults.bool(forKey: "synciCloudActive")
        self.active = userDefaults.bool(forKey: "syncActive")
        self.currentDevice = userDefaults.string(forKey: "syncLoggingDevice") ?? ""
        self.distanceFilterVal = userDefaults.integer(forKey: "syncDistanceFilter")
        self.locationManager.distanceFilter = CLLocationDistance(self.distanceFilterVal)
        
        do{
            var dir = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)
            
            let currentToken = FileManager.default.ubiquityIdentityToken
            if (currentToken != nil){ self.iCloudAvail = true }
            
            if (self.iCloudAvail && self.iCloudActive){
                dir = (FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents"))!
            }
            
            self.fh = dir.appendingPathComponent("backtrack.csv")
            
            if !FileManager.default.fileExists(atPath: self.fh!.path) {
                let s = "DateTime,Latitude,Longitude,Device\n"
                try s.write(to: self.fh!, atomically: true, encoding: .utf8)
            }

        } catch let error as NSError {
            NSLog("Problem opening the appropriate file: \(error)")
        }
        if (self.active && (self.currentDevice == UIDevice.current.name)){ self.start() }
    }
    
    public func start(){
        self.currentDevice = UIDevice.current.name
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
        }
        self.active = true
        userDefaults.set(UIDevice.current.name, forKey: "syncLoggingDevice")
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
            userDefaults.set(false, forKey: "syncActive")
            setApplicationIconName("Blue")
        } else {
            self.start()
            userDefaults.set(true, forKey: "syncActive")
            setApplicationIconName("Green")
        }
        userDefaults.synchronize()
    }
    
    public func iCloudToggle(){
        if self.iCloudActive {
            do{
                self.iCloudActive = false
                userDefaults.set(false, forKey: "synciCloudActive")
                let dir = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)
                self.fh = dir.appendingPathComponent("backtrack.csv")
            } catch let error as NSError {
                NSLog("Problem opening the appropriate file: \(error)")
            }
        } else {
            do{
                self.iCloudActive = true
                userDefaults.set(true, forKey: "synciCloudActive")
                let dir = (FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents"))!
                self.fh = dir.appendingPathComponent("backtrack.csv")
            }
        }
        userDefaults.synchronize()
    }
    
    public func setLocationFilter(_ value: Int){
        self.distanceFilterVal = value
        self.locationManager.distanceFilter = CLLocationDistance(value)
        userDefaults.set(value, forKey: "syncDistanceFilter")
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
        
        if (locValue.latitude == lastLocation.latitude && locValue.longitude == lastLocation.latitude){
            return
        }
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: now)
        
        let s = String(format: "%@,%f,%f,%@\n", dateString, locValue.latitude, locValue.longitude, self.currentDevice)
        
        if (self.fh != nil){
            if let fileHandle = FileHandle(forWritingAtPath: self.fh!.path) {
                defer {
                    fileHandle.closeFile()
                }
                fileHandle.seekToEndOfFile()
                fileHandle.write(s.data(using: String.Encoding.utf8)!)
            }
        }
        self.lastLocation = locValue
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("ERROR - No Location Received")
    }
}


func setApplicationIconName(_ iconName: String?) {
    if UIApplication.shared.responds(to: #selector(getter: UIApplication.supportsAlternateIcons)) && UIApplication.shared.supportsAlternateIcons {
        
        typealias setAlternateIconName = @convention(c) (NSObject, Selector, NSString?, @escaping (NSError) -> ()) -> ()
            
        let selectorString = "_setAlternateIconName:completionHandler:"
            
        let selector = NSSelectorFromString(selectorString)
        let imp = UIApplication.shared.method(for: selector)
        let method = unsafeBitCast(imp, to: setAlternateIconName.self)
        method(UIApplication.shared, selector, iconName as NSString?, { _ in })
    }
}
