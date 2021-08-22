/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Storage for model data.
*/

import Foundation
import Combine
import CoreLocation

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
    
    @Published var data = [DataPoint(id: Date(), device:"Test", coordinates: DataPoint.Coordinates(latitude:42.175898, longitude: -72.509578))]
    @Published var dateBoundaries: ClosedRange<Date> = Date()...Date()
    @Published var ready: Bool = false
    
    private var stringData: String = ""
    private var startDate: Date? = nil
    private var endDate: Date? = nil
    
    init(_ helper: LocationHelper){
        locHelper = helper
        fh = locHelper.getFileURL()
        setDateBoundaries()
    }
    
    public func setInterval(_ start: Date, _ end: Date){
        self.startDate = start
        self.endDate = end
        self.getDataForInterval()
    }
    
    private func setDateBoundaries(){
        if(fh == nil){
            return
        }
        if(stringData == ""){
            //convert into one long string
            do {
                self.stringData = try String(contentsOfFile: fh!.path)
            } catch {
                print(error)
                return
            }
        }
        //split string into array of "rows" of data. Each row is a string.
        var rows = self.stringData.components(separatedBy: "\n")
        //remove header row
        rows.removeFirst()
        
        //get lower boundary
        let first = rows[0]
        var columns = first.components(separatedBy: ",")
        let lowerBound = getDate(columns[0])!
        
        //get upper boundary
        let last = rows[rows.count-2]
        columns = last.components(separatedBy: ",")
        let upperBound = getDate(columns[0])!
        
        self.dateBoundaries = lowerBound...upperBound
        self.ready = true
    }
    
    public func getDataForInterval(){
        self.data = [DataPoint]()
        
        if(startDate == nil || fh == nil){
            return
        }
        
        if(stringData == ""){
            //convert into one long string
            do {
                self.stringData = try String(contentsOfFile: fh!.path)
            } catch {
                print(error)
                return
            }
        }
        
        //split that string into array of "rows" of data. Each row is a string.
        var rows = self.stringData.components(separatedBy: "\n")
        
        //remove header row
        rows.removeFirst()
        
        //now loop around each row, and append to data based on whether it's in the interval
        for row in rows {
            let columns = row.components(separatedBy: ",")
            //check that there are enough columns
            if columns.count == 4 {
                let date = getDate(columns[0])
                if (date! < startDate!){ //don't append if before start date
                    continue
                }
                if (date! > endDate!){ //don't append if after end date
                    break
                }
                let coord = DataPoint.Coordinates(latitude: Double(columns[1]) ?? 0, longitude:Double(columns[2]) ?? 0)
                let device = columns[3]
                
                self.data.append(DataPoint(id: date!, device: device, coordinates: coord))
            }
        }
    }
}

func getDate(_ dateString: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.locale = Locale.current
    return dateFormatter.date(from: dateString)
}

//func load<T: Decodable>(_ filename: String) -> T {
//    let data: Data
//
//    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
//        else {
//            fatalError("Couldn't find \(filename) in main bundle.")
//    }
//
//    do {
//        data = try Data(contentsOf: file)
//    } catch {
//        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
//    }
//
//    do {
//        let decoder = JSONDecoder()
//        return try decoder.decode(T.self, from: data)
//    } catch {
//        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
//    }
//}

