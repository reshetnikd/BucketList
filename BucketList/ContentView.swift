//
//  ContentView.swift
//  BucketList
//
//  Created by Dmitry Reshetnik on 16.03.2020.
//  Copyright © 2020 Dmitry Reshetnik. All rights reserved.
//

import SwiftUI
import LocalAuthentication

enum LoadingState {
    case loading, success, failed
}

struct LoadingView: View {
    var body: some View {
        Text("Loading...")
    }
}

struct SuccessView: View {
    var body: some View {
        Text("Success!")
    }
}

struct FailedView: View {
    var body: some View {
        Text("Failed.")
    }
}

struct User: Identifiable, Comparable {
    let id = UUID()
    let firstName: String
    let lastName: String
    
    static func < (lhs: User, rhs: User) -> Bool {
        lhs.lastName < rhs.lastName
    }
}

struct ContentView: View {
    let values = [1, 5, 3, 6, 2, 9].sorted()
    let users = [
        User(firstName: "Arnold", lastName: "Rimmer"),
        User(firstName: "Kristine", lastName: "Kochanski"),
        User(firstName: "David", lastName: "Lister")
    ].sorted()
    var loadingState = LoadingState.loading
    @State private var isUnlocked = false
    
    var body: some View {
        VStack {
            if self.isUnlocked {
                MapView()
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("Locked")
            }
        }
        .onAppear(perform: authenticate)
//        Group {
//            if loadingState == .loading {
//                LoadingView()
//            } else if loadingState == .success {
//                SuccessView()
//            } else if loadingState == .failed {
//                FailedView()
//            }
//        }
//        List(users) { user in
//            Text("\(user.lastName), \(user.firstName)")
//                .onTapGesture {
//                    let str = "Test Message"
//                    let fileName = "message.txt"
//                    FileManager.writeToDocumentsDirectory(data: str, file: fileName)
//                }
//        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authenticated successfully
                DispatchQueue.main.async {
                    if success {
                        // authenticated successfully
                        self.isUnlocked = true
                    } else {
                        // there was a problem
                    }
                }
            }
        } else {
            // no biometrics
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension FileManager {
    static func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = self.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    static func writeToDocumentsDirectory<T: StringProtocol>(data: T, file: String) {
        let url = self.getDocumentsDirectory().appendingPathComponent(file)
        
        do {
            try data.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
    }
}
