//
//  IterationView.swift
//  cue-pin-select
//
//  Created by Jeremy Stein on 10/19/21.
//

import SwiftUI

struct IterationView: View {
    var iteration: CPSModel.Iteration
    var cps: CPSModel
    
    
    var body: some View {
        let passphrase = cps.getPassphrase().replacingOccurrences(of: " ", with: "").lowercased()
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Cue: \(String(cps.getCue().prefix(iteration.id)))\(Text(String(cps.getCue()).dropLast(3 - iteration.id).dropFirst(iteration.id)).foregroundColor(chunkColor(int: iteration.id)))\(String(cps.getCue().dropFirst(iteration.id + 1)))")
                Spacer()
                Text("Pin: \(String(cps.getPin().prefix(iteration.id)))\(Text(String(cps.getPin()).dropLast(3 - iteration.id).dropFirst(iteration.id)).foregroundColor(chunkColor(int: iteration.id)))\(String(cps.getPin().dropFirst(iteration.id + 1)))")
            }
            HStack(spacing: 0) {
                Spacer()
                if iteration.matchingIndex <= passphrase.count - 3 {
                    Text(passphrase.prefix(iteration.matchingIndex))
                    Text(passphrase.dropFirst(iteration.matchingIndex).prefix(3))
                        .foregroundColor(chunkColor(int: iteration.id))
                    Text(passphrase.suffix(passphrase.count - iteration.matchingIndex - 3))
                } else {
                    Text(passphrase.prefix(3 - (passphrase.count - iteration.matchingIndex)))
                        .foregroundColor(chunkColor(int: iteration.id))
                    Text(passphrase.dropLast(passphrase.count - iteration.matchingIndex).dropFirst(3 - (passphrase.count - iteration.matchingIndex)))
                    Text(passphrase.suffix(passphrase.count - iteration.matchingIndex))
                        .foregroundColor(chunkColor(int: iteration.id))
                }
                Spacer()
            }
            .transition(.opacity)
            .font(.footnote)
            Divider()
            Text(scanningText(iteration: iteration, cue: cps.getCue()))
        }
    }
    
    
    func scanningText(iteration: CPSModel.Iteration, cue: String) -> String {
        let sentance: String
        let originalLetter = cue[iteration.id]
        
        if iteration.foundLetter {
            sentance = "Upon finding \(originalLetter.uppercased()), we take it along with the following two letters for our password."
        } else {
            sentance = "Since there are no \(originalLetter.uppercased())s in our phrase, we repeat the procedure with subsequent letters in the alphabet until we find one in our sentance. If we do this, we find \(String(iteration.searchedForLetter).uppercased()) at position \(iteration.matchingIndex) of our phrase and we will take it and the next two letters."
        }
        
        if iteration.id == 0 {
            return "To begin, we move \(iteration.offset) \(iteration.offset != 1 ? "indices" : "index") into the passphrase and start scanning for the letter \(originalLetter.uppercased()), wrapping if we reach the end of the phrase. \n\n \(sentance)"
        } else if iteration.id == 1 {
            return "Next, we move \(iteration.offset) \(iteration.offset != 1 ? "indices" : "index") to the right from our previous scan position and start to scan for the next letter, \(originalLetter.uppercased()). \n\n \(sentance)"
        } else if iteration.id == 2 {
            return "Next, we move \(iteration.offset) \(iteration.offset != 1 ? "indices" : "index") to the right from our previous scan position and start to scan for the third letter, \(originalLetter.uppercased()). \n\n \(sentance)"
        } else {
            return "Next, we move \(iteration.offset) \(iteration.offset != 1 ? "indices" : "index") to the right from our previous scan position and scan for the final letter, \(originalLetter.uppercased()). \n\n \(sentance)"
        }
    }
    
    
    
    
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
}

//struct IterationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultView(cps: CPSModel())
//    }
//}
