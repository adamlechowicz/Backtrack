/*
See LICENSE for licensing information.
 
Storage and helper for model data, loading from CSV, and current informational sheet
*/

import Foundation
import Combine
import CoreLocation

//Definition of a location data point
struct DataPoint: Identifiable {
    var id: Date
    var device: String
    var coordinates: Coordinates
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }
    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
}

final class ModelData: ObservableObject {
    
    private var locHelper: LocationHelper
    private var fh: URL? = nil
        
    //location data vars
        //current data for selected date (initialized to be empty)
    @Published var data = [DataPoint]()
        //encode boundaries of saved data
    @Published var dateBoundaries: ClosedRange<Date> = Date()...Date()
        //this is false until we verify there is data logged in the selected location
    @Published var ready: Bool = false //
        //we flip this boolean value back and forth based on whether the selected data is ready
    @Published var dataReady: Bool = true
    
    //informational sheet vars
    @Published var showSheet: Bool = false
    @Published var sheetId: Int = 0
    
    //targetDate is the date for which we want to visualize data
    private var targetDate: Date? = nil
    
    init(_ helper: LocationHelper){
        locHelper = helper
        fh = locHelper.getFileURL() //get file handle for "backtrack.csv" file
        setDateBoundaries() //set the boundaries for begin and end date from the data in the file
        
        //if initial setup is true, show the first informational sheet for the setup screens
        if(self.locHelper.initialSetup){
            self.sheetId = 0
            self.showSheet = true
        }
    }
    
    public func setDate(_ date: Date){
        self.dataReady = false
        self.targetDate = date  //set the target date
        self.getDataForDate()
    }
    
    private func setDateBoundaries(){
        if(fh == nil){
            return
        }
        //convert file into one long string
        var stringData: String
        
        do {
            stringData = try String(contentsOfFile: fh!.path)
        } catch {
            print(error)
            return
        }
        //split string into array of "rows" of data. Each row is a string.
        var rows = stringData.components(separatedBy: "\n")
        //remove header row
        rows.removeFirst()
        
        //get lower boundary
        let first = rows[0]  //lower boundary is the first data point
        var columns = first.components(separatedBy: ",")
        let lowerBound = getDate(columns[0]) ?? Date(timeIntervalSince1970: 0)
        
        if(lowerBound == Date(timeIntervalSince1970: 0)){
            return
        }
        
        //get upper boundary
        let last = rows[rows.count-2]  //upper boundary is the last data point
        columns = last.components(separatedBy: ",")
        let upperBound = getDate(columns[0]) ?? Date()
        
        self.dateBoundaries = lowerBound...upperBound
        self.ready = true
    }
    
    public func getDataForDate(){ //collect the data for a chosen date
        self.data = [DataPoint]()
        
        if(targetDate == nil || fh == nil){ //if targetDate or file is nil, return
            return
        }
        
        //convert into one long string
        var stringData: String
        
        do {
            stringData = try String(contentsOfFile: fh!.path)
        } catch {
            print(error)
            return
        }
                
        //split that string into array of "rows" of data. Each row is a string.
        var rows = stringData.components(separatedBy: "\n")
        //remove header row
        rows.removeFirst()
        
        //get a "limit" at which point we should stop iterating through file
        let limiterDate = Calendar.current.date(byAdding: .day, value: -1, to: targetDate!)
        
        //now loop around each row (from end of file to beginning for speed reasons),
        //append data based on whether it's contained in the target day
        for row in rows.reversed() {
            let columns = row.components(separatedBy: ",")
            //check that there are enough columns
            if columns.count == 4 {
                let date = getDate(columns[0])!
                if (date < limiterDate!){
                    break  //we've gone past the target data, stop iterating
                }
                if (Calendar.current.compare(date, to: targetDate!, toGranularity: .day) != .orderedSame){
                    continue  //don't append if not in target date
                }
                let coord = DataPoint.Coordinates(latitude: Double(columns[1]) ?? 0, longitude:Double(columns[2]) ?? 0)
                let device = columns[3]
                
                self.data.append(DataPoint(id: date, device: device, coordinates: coord))
            }
        }
        self.dataReady = true
    }
    
    public func setSheet(_ id: Int){
        self.sheetId = id  //set the id of the sheet user is trying to look at
    }
    
    public func toggleSheet(){
        self.showSheet = !self.showSheet  //toggle whether or not sheet is visible
    }
}

func getDate(_ dateString: String) -> Date? {  //convert string to Date data type
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.locale = Locale.current
    return dateFormatter.date(from: dateString)
}

