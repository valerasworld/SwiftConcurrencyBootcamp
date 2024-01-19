//
//  SendableBootcamp.swift
//  SwiftConcurrencyBootcamp2
//
//  Created by Валерий Зазулин on 19.01.2024.
//


// The Sendable protocol lets us tell the compiler
// whether or not an object is safe to send into an asynchronous context.
// For our purposes, this will mean whether or not we can safely send an object into an Actor!

// VALUE TYPES are Thread safe by default

// REFERENCE TYPES such as class HAVE TO:
//    - conform to Sendable
//    - be thread safe (locks/queues)
//    - be a `final class`
//    - be immutable (unless they are marked with @unchecked (dangerous!))

import SwiftUI

actor CurrentUserManager {
 
    func updateDatabase(userInfo: MyClassUserInfo) {
        
    }
}

struct MyUserInfo: Sendable {
    var name: String
}

final class MyClassUserInfo: @unchecked Sendable {
    private var name: String
    let queue = DispatchQueue(label: "com.MyApp.MyClassUserInfo")
    
    init(name: String) {
        self.name = name
    }
    
    func updateName(name: String) {
        queue.async {
            self.name = name
        }
    }
}

class SendableBootcampViewModel: ObservableObject {
    
    let manager = CurrentUserManager()
    
    func updateCurrentUserInfo() async {
        let info = MyClassUserInfo(name: "Info")
        await manager.updateDatabase(userInfo: info)
    }
    
}

struct SendableBootcamp: View {
    
    @StateObject private var viewModel = SendableBootcampViewModel()
    
    var body: some View {
        Text("Hello, World!")
            .task {
                
            }
    }
}

#Preview {
    SendableBootcamp()
}
