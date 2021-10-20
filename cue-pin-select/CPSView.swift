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
        NavigationView {
            Form {
                Section(header: Text("4 character secrets"), footer: Text("Random Pin").foregroundColor(.blue).onTapGesture {
                    self.pin = randomPin()
                }) {
                    TextField("Alphabetic cue", text: self.$cue)
                        .disableAutocorrection(true)
                    TextField("Numeric PIN", text: self.$pin)
                }
                Section(header: Text("Passphrase"), footer: Text("Random Passphrase").foregroundColor(Color.blue).onTapGesture {
                    self.passphrase = generatePassphrase()
                }) {
                    TextEditor(text: self.$passphrase)
                        .disableAutocorrection(true)
                }
                Button(action: {
                    if self.cue.count == 4 && self.pin.count == 4 && self.passphrase.count >= 20 {
                        cps.setCue(cue: String(self.cue.prefix(4)).lowercased())
                        cps.setPin(pin: String(self.pin.prefix(4)).lowercased())
                        cps.setPassphrase(passphrase: String(self.passphrase.prefix(45)).lowercased())
                        self.showResult = true
                    } else {
                        
                    }
                }, label: {
                    Text("Generate Password")
                        .foregroundColor((self.cue.count == 4 && self.pin.count == 4 && self.passphrase.count >= 20) ? Color.blue : Color.gray)
                })
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
        .sheet(isPresented: $showResult) {
            ResultView(cps: cps)
        }
    }
    
    func generatePassphrase() -> String {
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
    
    func randomPin() -> String {
        let possibleNumbers = "0123456789"
        var result: String = ""
        
        for _ in 0..<4 {
            result += String(possibleNumbers.randomElement()!)
        }
        
        return result
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CPSView(cps: CPSModel())
    }
}



