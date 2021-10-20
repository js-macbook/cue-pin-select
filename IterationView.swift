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
        let nextParagraph: String
        let originalLetter = cue[iteration.id]
        
        // Whether the original letter searched for was found or not.
        switch iteration.foundLetter {
        case true:
            nextParagraph = "Upon finding \(originalLetter.uppercased()), we jump \(iteration.offset) \(iteration.offset != 1 ? "indices" : "index") to the right and record the next three letters for our password."
        case false:
            nextParagraph = "Since there are no \(originalLetter.uppercased())s in our phrase, we repeat the procedure with subsequent letters in the alphabet until we find one in our sentance. If we do this, we find \(String(iteration.searchedForLetter).uppercased()), jump right \(iteration.offset) \(iteration.offset != 1 ? "indices" : "index") to position \(iteration.matchingIndex) and take the next three letters for our password."
        }
        
        // iteration.id is the index in cue and pin used for each algorithm iteration.
        switch iteration.id {
        case 0:
            return "To begin, we scan the passphrase for the letter \(originalLetter.uppercased()), wrapping if we reach the end of the phrase. \n\n \(nextParagraph)"
        case 1:
            return "Starting from the end of the three letters we took, we scan for the next letter, \(originalLetter.uppercased()). \n\n \(nextParagraph)"
        case 2:
            return "Next, we scan for the third letter, \(originalLetter.uppercased()), in the same fashion. \n\n \(nextParagraph)"
        default:
            return "Finally, we scan for the last letter, \(originalLetter.uppercased()). \n\n \(nextParagraph)"
        }
    }
}
