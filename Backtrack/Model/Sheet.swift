/*
See LICENSE folder for this sample’s licensing information.
Abstract:
The model for an individual building.
*/

import SwiftUI
import Foundation

struct Sheet: Hashable, Codable, Identifiable {
    var id: Int
    var title: String
    var imageNames: [String]
    var nextId: Int
    var duration: Double
    var body: String
    var button: String
}
