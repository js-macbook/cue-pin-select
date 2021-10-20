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
            HStack {
                Button(action: {
                    withAnimation {
                        self.resultStep -= self.resultStep > 0 ? 1 : 0
                    }
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(self.resultStep > 0 ? .white : .clear)
                })
                    .padding()
                Spacer()
                Text(resultStep < 4 ? "Step \(resultStep + 1):" : "Result:")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    withAnimation {
                        self.resultStep += self.resultStep <= 3 ? 1 : 0
                    }
                }, label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(self.resultStep <= 3 ? .white : .clear)
                })
                    .padding()
            }
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
    
    func foundLetterString(iteration: CPSModel.Iteration) -> String {
        "hello"
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

//struct ResultView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultView(cps: CPSModel())
//    }
//}
