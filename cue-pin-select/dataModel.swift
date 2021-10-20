//
//  dataModel.swift
//  cue-pin-select
//
//  Created by Jeremy Stein on 10/18/21.
//

import Foundation


/// Model for MVVM app.
struct DataModel {
    /// A secret passphrase containing alphabetic characters, typically 6 characters long
    var passphrase: String
    
    /// A four digit pin number
    var pin: String
    
    /// A four letter string
    var cue: String
    
    /**
     Initializes the app data model.
     
     - Returns: a new model with with empty user input strings.
     */
    init() {
        self.passphrase = ""
        self.pin = ""
        self.cue = ""
    }
}
