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
    private var lastLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined
    @Published var active: Bool = false
    @Published var currentDevice: String = "PlaceholderDevice"
    
    private var fh: URL? = nil
    private var cloudFh: URL? = nil

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager.distanceFilter = 200
        do{
            let dir = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)
            let currentToken = FileManager.default.ubiquityIdentityToken
            if (currentToken == nil){
                NSLog("no good!")
            }
//            let driveURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
            self.fh = dir.appendingPathComponent("backtrack.csv")
            var containerUrl: URL? {
                return FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
            }
            // check for container existence
//            if let driveURL = containerUrl, !FileManager.default.fileExists(atPath: driveURL.path, isDirectory: nil) {
//                do {
//                    try FileManager.default.createDirectory(at: driveURL, withIntermediateDirectories: true, attributes: nil)
//                }
//                catch {
//                    print(error.localizedDescription)
//                }
//            }
//
//            NSLog(driveURL?.absoluteString ?? "no URL")
            
            if !FileManager.default.fileExists(atPath: self.fh!.path) {
                let s = "DateTime,Latitude,Longitude,Device\n"
                try s.write(to: self.fh!, atomically: true, encoding: .utf8)
            }
//            if !FileManager.default.fileExists(atPath: self.cloudFh!.path) {
//                let s = "DateTime,Latitude,Longitude,Device\n"
//                try s.write(to: self.fh!, atomically: true, encoding: .utf8)
//            }
        } catch let error as NSError {
            NSLog("Problem opening the appropriate file: \(error)")
        }
        self.currentDevice = UIDevice.current.name
    }
    
    public func start(){
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
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
            setApplicationIconName("Blue")
        } else {
            self.start()
            setApplicationIconName("Green")
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
//            if let fileHandle = FileHandle(forWritingAtPath: self.cloudFh!.path) {
//                defer {
//                    fileHandle.closeFile()
//                }
//                fileHandle.seekToEndOfFile()
//                fileHandle.write(s.data(using: String.Encoding.utf8)!)
//            }
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
