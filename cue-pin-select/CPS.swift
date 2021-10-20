//
//  CPS.swift
//  cue-pin-select
//
//  Created by Jeremy Stein on 10/18/21.
//

import SwiftUI


class CPSModel: ObservableObject {
    @Published private(set) var dataModel: DataModel
    
    init() {
        dataModel = DataModel()
    }

    var passphrase: String {
        return dataModel.passphrase
    }
    
    var pin: String {
        return dataModel.pin
    }
    
    var cue: String {
        return dataModel.cue
    }
    
    
    // MARK: - Getters and Setters
    
    func setPassphrase(passphrase: String) {
        dataModel.passphrase = passphrase
    }
    
    func getPassphrase() -> String {
        return dataModel.passphrase
    }
    
    func setPin(pin: String) {
        dataModel.pin = pin
    }
    
    func getPin() -> String {
        return dataModel.pin
    }
    
    func setCue(cue: String) {
        dataModel.cue = cue
    }
    
    func getCue() -> String {
        return dataModel.cue
    }
    
    
    // MARK: - Algorithms
    
    func suggestedPassphrase() -> String {
        return "Suggested Passphrase" // TODO
    }
    
    func generatedPassword(passphrase: String, cue: String, pin: String) -> [Iteration] {
        let loopPassphrase = Array(passphrase.replacingOccurrences(of: " ", with: "").lowercased())
        let loopPin = Array(pin)
        let loopCue = Array(cue)
        var passphraseIndex = 0
        var cuePinIndex = 0
        var result = Array<Iteration>()
        
        
        while cuePinIndex < 4 {
            let indexOffset = loopPin[cuePinIndex].wholeNumberValue!
            var letter = loopCue[cuePinIndex]
            var foundLetter = true
            
            passphraseIndex = passphraseIndex + indexOffset
            
            while firstMatchingIndex(passphrase: loopPassphrase, letter: letter, startingIndex: passphraseIndex) == -1 {
                letter =  nextLetter[letter]!
                foundLetter = false
            }
            
            let matchingIndex = firstMatchingIndex(passphrase: loopPassphrase, letter: letter, startingIndex: passphraseIndex)
            
            let slice = getStringSlice(string: String(loopPassphrase), index: matchingIndex)
            
            result.append(Iteration(searchedForLetter: letter, passwordChunk: slice, offset: indexOffset, foundLetter: foundLetter, matchingIndex: matchingIndex, id: cuePinIndex))
            
            passphraseIndex = matchingIndex
            
            cuePinIndex += 1
        }
        
        
        return result
    }
    
    func getStringSlice(string: String, index: Int) -> String {
        var result = ""
        for i in 0..<3 {
            result = result + String(string[(i + index) % string.count])
        }
        return result
    }
    
    func firstMatchingIndex(passphrase: [Character], letter: Character, startingIndex: Int) -> Int {
        for i in 0..<passphrase.count {
            if passphrase[(i + startingIndex) % passphrase.count] == letter {
                return (i + startingIndex) % passphrase.count
            }
        }
        return -1
    }
    
    
    
    let nextLetter: [Character: Character] = [
        "a": "b",
        "b": "c",
        "c": "d",
        "d": "e",
        "e": "f",
        "f": "g",
        "g": "h",
        "h": "i",
        "i": "j",
        "j": "k",
        "k": "l",
        "l": "m",
        "m": "n",
        "n": "o",
        "o": "p",
        "p": "q",
        "q": "r",
        "r": "s",
        "s": "t",
        "t": "u",
        "u": "v",
        "v": "w",
        "w": "x",
        "x": "y",
        "y": "z",
        "z": "a",
        ]
    
    
    struct Iteration: Identifiable {
        var searchedForLetter: Character
        var passwordChunk: String
        var offset: Int
        var foundLetter: Bool
        var matchingIndex: Int
        var id: Int
    }
}


extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}



let x: String = "The first letter of abcd, a, was found"
