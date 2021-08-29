/*
See LICENSE for licensing information.

Abstract:
Helper to get and log location data from iOS
*/

import Foundation
import Combine
import MapKit
import UIKit
import CoreLocation

class LocationHelper: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    private let userDefaults = UserDefaults.standard
    private var lastLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    private var currentDevice: String = UIDevice.current.name
    
    //set default values for configuration parameters (overwritten in init block)
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined
    @Published var active: Bool = false
    @Published var iCloudAvail: Bool = false  //default to false (assume iCloud is not available)
    @Published var iCloudActive: Bool = true  //default to true (if iCloud is avail, use it)
    @Published var distanceFilterVal: Int = 200
    @Published var initialSetup: Bool = false
    
    private var fh: URL? = nil

    override init() {
        super.init()
        //set up CLLocationManager to send us location updates continously (while active)
        self.locationManager.delegate = self
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.pausesLocationUpdatesAutomatically = false
        
        // get user settings from local account - trigger initial setup if first time running
        if userDefaults.value(forKey: "bktrack") == nil {
            // set default values at first launch, trigger initial setup
            userDefaults.set("Backtrack", forKey: "bktrack")
            userDefaults.set(200, forKey: "distanceFilter")
            userDefaults.set(false, forKey: "active")
            userDefaults.set(true, forKey: "iCloudActive")
            self.initialSetup = true
            userDefaults.synchronize()
        }
        
        //get settings from UserDefaults, overwrite initial values
        self.iCloudActive = userDefaults.bool(forKey: "iCloudActive")
        self.active = userDefaults.bool(forKey: "active")
        self.distanceFilterVal = userDefaults.integer(forKey: "distanceFilter")
        self.locationManager.distanceFilter = CLLocationDistance(self.distanceFilterVal)
        
        do{
            //get file URL for local storage (Documents directory)
            var dir = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)
            
            //check if iCloud is available on this device
            let currentToken = FileManager.default.ubiquityIdentityToken
            if (currentToken != nil){
                self.iCloudAvail = true
            } else {
                userDefaults.set(false, forKey: "iCloudActive")
                self.iCloudActive = false
            }
            
            //if iCloud is available and it's set to be active...
            if (self.iCloudAvail && self.iCloudActive){
                //get the directory for Backtrack inside private iCloud Drive
                dir = (FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents"))!
            }
            
            //set file handle by choosing backtrack.csv within the chosen directory
            self.fh = dir.appendingPathComponent("backtrack.csv")
            
            //if the file doesn't exist, initialize it with a header
            if !FileManager.default.fileExists(atPath: self.fh!.path) {
                let s = "DateTime,Latitude,Longitude,Device\n"
                try s.write(to: self.fh!, atomically: true, encoding: .utf8)
            }

        } catch let error as NSError {
            //for any error, log it to the console
            NSLog("Problem opening the appropriate file: \(error)")
        }
        //if we're supposed to be active, start logging as soon as the app starts
        if (self.active){ self.start() }
    }
    
    public func start(){
        //set the desired accuracy for location tracking
        //we choose kCLLocationAccuracyKilometer so that we receive location updates in the background indefinitely (until manually stopped)
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
        }
        self.active = true  //publish that location updating is active
    }
    
    public func stop(){
        //set location manager to stop updating locations
        if CLLocationManager.locationServicesEnabled(){
            self.locationManager.stopUpdatingLocation()
            self.locationManager.stopMonitoringSignificantLocationChanges()
        }
        self.active = false  //publish that location updating is no longer active
    }
    
    //simple toggle function that chooses the correct function to call based on our status
    public func toggle(){
        if self.active {
            self.stop()
            userDefaults.set(false, forKey: "active")
            setApplicationIconName("Blue")
        } else {
            self.start()
            userDefaults.set(true, forKey: "active")
            setApplicationIconName("Green")
        }
        userDefaults.synchronize()
    }
    
    //this function can only be called if iCloud is available on this device
    public func iCloudToggle(){
        if self.iCloudActive {
            do{
                self.iCloudActive = false
                userDefaults.set(false, forKey: "iCloudActive")
                
                //get the directory and path to file for local storage
                let dir = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)
                self.fh = dir.appendingPathComponent("backtrack.csv")
                
                //if the file doesn't exist, initialize it with a header
                if !FileManager.default.fileExists(atPath: self.fh!.path) {
                    let s = "DateTime,Latitude,Longitude,Device\n"
                    try s.write(to: self.fh!, atomically: true, encoding: .utf8)
                }
            } catch let error as NSError {
                NSLog("Problem opening the appropriate file: \(error)")
            }
        } else {
            do{
                self.iCloudActive = true
                userDefaults.set(true, forKey: "iCloudActive")
                
                //get the path to file for Backtrack in private iCloud Drive
                let dir = (FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents"))!
                self.fh = dir.appendingPathComponent("backtrack.csv")
                
                //if the file doesn't exist, initialize it with a header
                if !FileManager.default.fileExists(atPath: self.fh!.path) {
                    let s = "DateTime,Latitude,Longitude,Device\n"
                    try s.write(to: self.fh!, atomically: true, encoding: .utf8)
                }
            } catch let error as NSError {
                NSLog("Problem opening the appropriate file: \(error)")
            }
        }
        userDefaults.synchronize()
    }
    
    //set the filter for the location manager (from UI Picker)
    public func setLocationFilter(_ value: Int){
        self.distanceFilterVal = value
        self.locationManager.distanceFilter = CLLocationDistance(value)
        userDefaults.set(value, forKey: "distanceFilter")
        userDefaults.synchronize()
    }

    //get the initial authorization to access device location
    public func requestAuth() {
        self.locationManager.requestAlwaysAuthorization()
    }
    
    //return the location (URL) of logging file
    public func getFileURL() -> URL{
        return self.fh!
    }
}

extension LocationHelper: CLLocationManagerDelegate {

    //update auth status whenever it changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorisationStatus = status
    }
    
    //MAIN LOCATION UPDATE FUNCTION
    //iOS calls this function WHENEVER it passes a new location to Backtrack's location manager.
    //We use this function to parse the incoming data and log it directly to the CSV file
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //locValue is the updated location (in longitude and latitude)
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        //Log to the console for debug purposes (disabled to reduce overhead)
        //NSLog("locations = \(locValue.latitude) \(locValue.longitude)")
        
        //check if this location is the same as the last one we logged
        //(iOS will sometimes call this function twice in quick succession, so we filter out duplicates)
        if (locValue.latitude == lastLocation.latitude && locValue.longitude == lastLocation.latitude){
            return
        }
        
        //get the current time and format it into string format
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: now)
        
        //build a CSV string from the date, lat, long, and name of the current device
        let s = String(format: "%@,%f,%f,%@\n", dateString, locValue.latitude, locValue.longitude, self.currentDevice)
        
        //if the file handle isn't null (which it definitely shouldn't be), write to it
        //this file handle will be the iCloud file if iCloudActive = true, local storage otherwise
        if (self.fh != nil){
            if let fileHandle = FileHandle(forWritingAtPath: self.fh!.path) {
                defer {
                    fileHandle.closeFile()  //close the file after we've written to it
                }
                fileHandle.seekToEndOfFile()  //append to the end of the file
                fileHandle.write(s.data(using: String.Encoding.utf8)!)  //write to file
            }
        }
        self.lastLocation = locValue  //keep this value around to avoid logging duplicates
    }
    
    //if the location manager failed for whatever reason, give up and log to console
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
