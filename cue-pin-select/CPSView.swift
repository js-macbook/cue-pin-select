//
//  CPSView.swift
//  cue-pin-select
//
//  Created by Jeremy Stein on 10/18/21.
//

import SwiftUI

struct CPSView: View {
    @ObservedObject var cps: CPSModel
    @State var cue = ""
    @State var pin = ""
    @State var passphrase = ""
    @State var showResult = false
    
    var body: some View {
        navBody
        .sheet(isPresented: $showResult) {
            ResultView(cps: cps)
        }
    }
    
    var navBody: some View {
        NavigationView {
            Form {
                fourCharacterSecretsSection
                passphraseSection
                submitButton
            }
            .navigationTitle("Cue-Pin-Select")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    NavigationLink(destination: {
                        AboutView()
                            .navigationTitle(Text("About"))
                            .padding(.horizontal)
                    }) {
                        Text("About")
                    }
                }
            }
        }
    }
    
    var fourCharacterSecretsSection: some View {
        Section(header: Text("4 character secrets"), footer: Text("Random Pin").foregroundColor(.blue).onTapGesture {
            self.pin = randomPin()
        }) {
            TextField("Alphabetic cue", text: self.$cue)
                .disableAutocorrection(true)
            TextField("Numeric PIN", text: self.$pin)
        }
    }
    
    var passphraseSection: some View {
        Section(header: Text("Passphrase"), footer: Text("Random Passphrase").foregroundColor(Color.blue).onTapGesture {
            self.passphrase = randomPassphrase()
        }) {
            TextEditor(text: self.$passphrase)
                .disableAutocorrection(true)
        }
    }
    
    var submitButton: some View {
        Button(action: {
            if textFieldConstraintsMet {
                // We redundantly prefix the cue and pin because during development
                // there may be discrepancies between the view and the model when we dont
                // start with empty strings during model initialization.
                cps.setCue(cue: String(self.cue.prefix(CONSTANTS.cueCharCount)).lowercased())
                cps.setPin(pin: String(self.pin.prefix(CONSTANTS.pinCharCount)).lowercased())
                cps.setPassphrase(passphrase: String(self.passphrase.prefix(CONSTANTS.maxPhraseLength)).lowercased())
                self.showResult = true
            }
        }, label: {
            Text("Generate Password")
                .foregroundColor(textFieldConstraintsMet ? Color.blue : Color.gray)
        })
    }
    
    /// Computed var checking whether the primitives meet prerequirements for the password algorithm
    var textFieldConstraintsMet: Bool {
        self.cue.count == CONSTANTS.cueCharCount
        && self.pin.count == CONSTANTS.pinCharCount
        && self.passphrase.count >= CONSTANTS.minPhraseLength
    }
    
    func randomPin() -> String {
        var result: String = ""
        for _ in 0..<4 {
            result += String(CONSTANTS.digitStrings.randomElement()!)
        }
        return result
    }
    
    func randomPassphrase() -> String {
        // TODO: import wordlist from textfile containing thousands of words.
        let possibleWords = [
        "cleaver",
        "math",
        "artistry",
        "dance",
        "tulip",
        "walrus",
        "maple",
        "syrup",
        "taxes",
        "bitcoin",
        "china",
        "european",
        "waxing",
        "banana",
        "irish",
        "candle",
        "dinner",
        "stripes",
        "yankee",
        "august",
        "nancy",
        "joyful",
        "tempest",
        "shylock",
        "vagrant",
        "bully",
        "bashful",
        "ardent",
        "brave",
        "cowardly",
        "dastardly",
        "ancient",
        "blue",
        "grim",
        "clover",
        "penguin",
        "xylaphone",
        "menace"
        ]
        
        var result: String = ""
        for _ in 0..<6 {
            result += possibleWords.randomElement()! + " "
        }
        return result
    }
    
    struct CONSTANTS {
        static let cueCharCount = 4
        static let pinCharCount = 4
        static let minPhraseLength = 20
        static let maxPhraseLength = 52
        static let digitStrings = "0123456789"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CPSView(cps: CPSModel())
    }
}



