/*
See LICENSE for this file's licensing information.

Abstract:
Just some SwiftUI button styles for easy usage.
*/

import Foundation
import SwiftUI

struct ItemButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .shadow(radius: (configuration.isPressed ? 2.0 : 5.0), x: 2.0, y: 2.0)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct TopButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .shadow(radius: (configuration.isPressed ? 5.0 : 10.0), x: 5.0, y: 5.0)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct RowButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .shadow(radius: (configuration.isPressed ? 0.0 : 3.0), x: (configuration.isPressed ? 0.0 : 3.0), y: (configuration.isPressed ? 0.0 : 3.0))
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct SimpleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.5 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
