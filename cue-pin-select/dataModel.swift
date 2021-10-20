//
//  dataModel.swift
//  cue-pin-select
//
//  Created by Jeremy Stein on 10/18/21.
//

import Foundation


// Model
struct DataModel {
    var passphrase: String
    var pin: String
    var cue: String
    
    init() {
        self.passphrase = ""
        self.pin = ""
        self.cue = ""
    }
}
