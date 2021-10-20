//
//  AboutView.swift
//  cue-pin-select
//
//  Created by Jeremy Stein on 10/19/21.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Group {
                    Text("Passwords are often the weakest link in account security. Most people make insecure, easy to guess passwords and then reuse them across multiple accounts. A solution to this is to make more secure passwords. This can be done simply by making very long and random passwords, though this makes remembering your passwords very difficult.")
                    Text("A naive solution to password memorization is to simply write down the passwords for all of your accounts with a pen and paper. This can be kind of inconvenient, so another strategy is to use a password manager on your computer. Both of these strategies allow the generation of strong, secure passwords, but they also represent a single point of failure. If someone steals your sheet of paper or accesses your password manager, your passwords are toast.")
                    Text("Enter cue-pin-select. This is a password generation algorithm that is simple enough to be easily human computable while being secure enough to be uncrackable. Instead of complex, unintelligible cryptographic primitives, cue-pin-select uses three simple secrets:")
                    Text("1. A pin: an unchanging four digit number.")
                        .padding(.horizontal)
                    Text("2. A cue: a four character string of text specific to the account you are making a password for.")
                        .padding(.horizontal)
                    Text("3. A passphrase: an unchanging sentance of random words.")
                        .padding(.horizontal)
                }
                Group {
                    Text("With these primitives in hand, we can then generate a strong password using only our brains. The algorithm is as follows:")
                    Text("1. First, take the first digit of your pin and move that many indices into your passphrase.")
                        .padding(.horizontal)
                    Text("2. Next, take the first letter of your cue. Start scanning through your passphrase until you see this letter. If you reach the end of the phrase, wrap back to the beginning and continue until you reach where you started.")
                        .padding(.horizontal)
                    Text("3. When you reach the cue letter, take it and the next two letters in your passphrase. These three letters will be the first three letters of your password.")
                        .padding(.horizontal)
                    Text("3.5. If you didn't find the cue letter, restart the scan from the same position using the next letter in the alphabet, with A being the next letter after Z. Continue to do so until you successfully find a letter and get a three letter slice from your passphrase.")
                        .padding(.horizontal)
                    Text("4. Now, repeat this exact process for each subsequent number in your pin and letter in your cue, except instead of starting from the beginning of the sentance and moving in by your pin digit, move starting from where you left off with the previous scan. For instance, if you found your first letter at index 10 of your sentance, move right starting from this index when you jump indices and start scanning.")
                        .padding(.horizontal)
                }
                Text("This can be sort of complicated at first blush, but according to preliminary studies, people can learn and implement this algorithm with less than 5 minutes of instruction. When using it to make a password, it takes about 5 seconds for well trained users to execute the algorithm.")
                Text("To make it easy for you while you practice, you can use this app to check your work. Simply enter your cue, pin, and passphrase and it will walk you through the steps for password generation.")
                Text("The goal is to eventaully move away from using the app once you have mastered the technique. At that point, all you have to do is remember your pin and passphrase and then which cue you came up with for each account. This can be safely written down, since if anyone steals your paper full of cues they won't be able to guess your passwords unless they also know your secret pin and phrase.")
            }
            .padding(.vertical)
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
