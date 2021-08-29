/*
See LICENSE for this file’s licensing information.
 
Abstract:
Helpers for loading images and data from JSON.
*/

import UIKit
import SwiftUI
import CoreLocation
import AVFoundation

//load data for informational sheets from JSON file in package
var sheetData: [Sheet] = load("sheetData.json")

//define function to load from JSON
func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    //pick the file from the main bundle
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    //get data from file
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    //decode data from file
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
