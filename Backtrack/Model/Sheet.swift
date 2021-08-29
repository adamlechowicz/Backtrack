/*
See LICENSE for this files’s licensing information.
 
Abstract:
Data model for an informational sheet.
*/

import SwiftUI
import Foundation

//Definition/structure of an informational sheet
struct Sheet: Hashable, Codable, Identifiable {
    var id: Int
    var title: String
    var imageNames: [String]
    var nextId: Int
    var duration: Double
    var body: String
    var button: String
}
