//
//  Utils.swift
//  cue-pin-select
//
//  Created by Jeremy Stein on 10/20/21.
//

import SwiftUI


/// Generates a color depending on the current algorithmic step.
func chunkColor(int: Int) -> Color {
    switch int {
    case 0:
        return Color.blue
    case 1:
        return Color.pink
    case 2:
        if #available(iOS 15.0, *) {
            return Color.mint
        } else {
            return Color.green
        }
    case 3:
        if #available(iOS 15.0, *) {
            return Color.indigo
        } else {
            return Color.purple
        }
    default:
        if #available(iOS 15.0, *) {
            return Color.brown
        } else {
            return Color.black
        }
    }
}
