//
//  MVVMBootcamp.swift
//  SwiftConcurrencyBootcamp2
//
//  Created by Валерий Зазулин on 19.01.2024.
//

// How to implement the MVVM pattern in Swift projects
// and leverage the benefits of concurrency for seamless user experiences.

import SwiftUI

final class MyManagerClass {
 
    func getData() async throws -> String {
        "Some Data!"
    }
    
}

actor MyManagerActor {
    
    func getData() async throws -> String {
        "Some Data!"
    }
    
}

@MainActor
final class MVVMBootcampViewModel: ObservableObject {
    
    let managerClass = MyManagerClass()
    let managerActor = MyManagerActor()
    
    @Published private(set) var myData: String = "Starting Text!"
    private var tasks: [Task<Void, Never>] = []
    
    func cancelTasks() {
        tasks.forEach { $0.cancel() }
        tasks = []
    }
    
    func onCallToActionButtonPressed() {
        let task =  Task {
            do {
//                myData = try await managerClass.getData()
                myData = try await managerActor.getData()

            } catch {
                print(error)
            }
        }
        tasks.append(task)
    }
        
}

struct MVVMBootcamp: View {
    
    @StateObject private var viewModel = MVVMBootcampViewModel()
    
    var body: some View {
        VStack {
            Button(viewModel.myData) {
                viewModel.onCallToActionButtonPressed()
            }
        }
        .onDisappear {
            
        }
    }
}

#Preview {
    MVVMBootcamp()
}
