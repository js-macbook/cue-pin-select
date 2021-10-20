//
//  ResultView.swift
//  cue-pin-select
//
//  Created by Jeremy Stein on 10/19/21.
//

import SwiftUI

struct ResultView: View {
    @ObservedObject var cps: CPSModel
    @Environment(\.presentationMode) var presentationMode
    @State var resultStep = 0
    @State var copied = false
    
    var body: some View {
        let finalResult = password().reduce("") { $0 + $1.passwordChunk }
        VStack {
            resultHeader
            .padding()
            .background(chunkColor(int: resultStep))
            if resultStep < 4 {
                IterationView(iteration: password()[resultStep], cps: cps)
                    .padding()
            } else {
                VStack(spacing: 10) {
                    HStack {
                        Text("Cue: \(cps.getCue())")
                        Spacer()
                        Text("Pin: \(cps.getPin())")
                    }
                    HStack {
                        Spacer()
                        Text("\(cps.getPassphrase().replacingOccurrences(of: " ", with: "").lowercased())")
                            .font(.footnote)
                        Spacer()
                    }
                    Divider()
                    Text("Accumulating all of our letters, we get our final password:")
                    Text(finalResult)
                        .font(.largeTitle)
                        .foregroundColor(chunkColor(int: resultStep))
                        .padding()
                        .contextMenu {
                                Button(action: {
                                    UIPasteboard.general.string = finalResult
                                }) {
                                    Text("Copy to clipboard")
                                    Image(systemName: "doc.on.doc")
                                }
                             }
                }
                .padding()
            }
            Spacer()
        }
    }
    
    var resultHeader: some View {
        HStack {
            leftButton
                .padding()
            Spacer()
            Text(resultStep < 4 ? "Step \(resultStep + 1):" : "Result:")
                .font(.largeTitle)
                .foregroundColor(.white)
            Spacer()
            rightButton
                .padding()
        }
    }
    
    var leftButton: some View {
        Button(action: {
            withAnimation {
                self.resultStep -= self.resultStep > 0 ? 1 : 0
            }
        }, label: {
            Image(systemName: "chevron.left")
                .foregroundColor(self.resultStep > 0 ? .white : .clear)
        })
    }
    
    var rightButton: some View {
        Button(action: {
            withAnimation {
                self.resultStep += self.resultStep <= 3 ? 1 : 0
            }
        }, label: {
            Image(systemName: "chevron.right")
                .foregroundColor(self.resultStep <= 3 ? .white : .clear)
        })
    }
    
    func intToString(int: Int) -> String {
        if int == 0 {
            return "first"
        } else if int == 1 {
            return "second"
        } else if int == 2 {
            return "third"
        } else {
            return "fourth"
        }
    }
    
    func password() -> [CPSModel.Iteration] {
        return cps.generatedPassword(
            passphrase: cps.getPassphrase(),
            cue: cps.getCue(),
            pin: cps.getPin()
        )
    }
}

//struct ResultView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultView(cps: CPSModel())
//    }
//}
