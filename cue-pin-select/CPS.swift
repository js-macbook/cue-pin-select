//
//  CPS.swift
//  cue-pin-select
//
//  Created by Jeremy Stein on 10/18/21.
//

import SwiftUI


/**
 cue-pin-select ViewModel for MVVM app.
 
 Provides an interface between the data model and the views.
 */
class CPSModel: ObservableObject {
    @Published private(set) var dataModel: DataModel
    
    init() {
        dataModel = DataModel()
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
    
    /**
     Generates a strong, random password from simple primitives using an algorithm that is human computable.
     The algorithm is adapted from the [cue-pin-select paper](https://hal.archives-ouvertes.fr/hal-01781231/file/Cue_Pin_Select__a_Secure_and_Usable_Offline_Password_Scheme%20%286%29.pdf).
     
     - Parameters:
        - passphrase: A string 30-50 characters long.
        - cue: A four letter string.
        - pin : A  four digit string.
     
     - Returns: An array of Iteration structs
     */
    func generatedPassword(passphrase: String, cue: String, pin: String) -> [Iteration] {
        // We convert the strings to arrays for easier iteration and subscripting.
        let loopPassphrase = Array(passphrase.replacingOccurrences(of: " ", with: "").lowercased())
        let loopPin = Array(pin)
        let loopCue = Array(cue)
        var passphraseIndex = 0
        var cuePinIndex = 0
        var result = Array<Iteration>()
        
        // Iterate through each letter in cue and number in pin.
        while cuePinIndex < 4 {
            let indexOffset = loopPin[cuePinIndex].wholeNumberValue!
            var letter = loopCue[cuePinIndex]
            var foundLetter = true // Flag for whether the letter was found the first time through the passphrase.
            
            while firstMatchingIndex(passphrase: loopPassphrase, letter: letter, startingIndex: passphraseIndex) == -1 {
                letter =  nextLetter[letter]!
                foundLetter = false
            }
            
            // We modulo so the index wraps and we add one to the indexOffset because
            // we start the slice on the next letter after the offset.
            let matchingIndex = (firstMatchingIndex(passphrase: loopPassphrase, letter: letter, startingIndex: passphraseIndex) + indexOffset + 1) % loopPassphrase.count
            
            let slice = getStringSlice(string: String(loopPassphrase), index: matchingIndex)
            
            result.append(Iteration(searchedForLetter: letter, passwordChunk: slice, offset: indexOffset, foundLetter: foundLetter, matchingIndex: matchingIndex, id: cuePinIndex))
            
            // We update the passphraseIndex for the next iteration to where we took our slice from.
            passphraseIndex = (matchingIndex + 1) % loopPassphrase.count
            cuePinIndex += 1
        }
        return result
    }
    
    /// Returns a three character string slice starting at the given index and wrapping if it slices near the end.
    func getStringSlice(string: String, index: Int) -> String {
        var result = ""
        for i in 0..<3 {
            let wrappedIndex = (i + index) % string.count
            result = result + String(string[wrappedIndex])
        }
        return result
    }
    
    /**
     Searches passphrase for a given character.
     
     - Parameters:
        - passphrase: A character array through which to search.
        - letter: The character to search for.
        - startingIndex: Integer index in the array to start the search at.
     
     - Returns: The integer position of the character in the passphrase, or -1 if the character was not found.
     */
    func firstMatchingIndex(passphrase: [Character], letter: Character, startingIndex: Int) -> Int {
        for i in 0..<passphrase.count {
            let wrappedIndex = (i + startingIndex) % passphrase.count
            if passphrase[wrappedIndex] == letter {
                return wrappedIndex
            }
        }
        return -1
    }
    
    
    /**
     Mapping from one lowercase letter to the next.
     
     - Examples:
        - nextLetter["b"] -> "c"
        - nextLetter["z"] -> "a"
     */
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
    
    /**
     Struct containing data about one iteration through the password generation algorithm
     
     Fields:
        - searchedForLetter: The cue letter that was searched for.
        - passwordChunk: Three letter string generated by the iteration.
        - offset: The offset, AKA the pin number digit for the iteration.
        - foundLetter: Whether the algorithm found the original search letter or not.
        - matchingIndex: The index in the passphrase that the letter was found at.
        - id: The iteration number, either 1, 2, 3, or 4.
     */
    struct Iteration: Identifiable {
        var searchedForLetter: Character
        var passwordChunk: String
        var offset: Int
        var foundLetter: Bool
        var matchingIndex: Int
        var id: Int
    }
}


// Extending the string protocol to accept integer subscripts.
extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
