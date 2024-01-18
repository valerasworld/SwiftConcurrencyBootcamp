//
//  GlobalActorBootcamp.swift
//  SwiftConcurrencyBootcamp2
//
//  Created by Валерий Зазулин on 18.01.2024.
//

import SwiftUI

// @globalActor allows you to isolate code that is not inside of an actor
// onto a global actor!

@globalActor final class MyFirstGlobalActor {
    
    static var shared = MyNewDataManager()
    
}

actor MyNewDataManager {
    
    func getDataFromDataBase() -> [String] {
        return ["One", "Two", "Three", "Four", "Five"]
    }
    
}

//@MainActor 
class GlobalActorBootcampViewModel: ObservableObject {
    
    @MainActor @Published var dataArray: [String] = []
//    @Published var dataArray2: [String] = []
//    @Published var dataArray3: [String] = []
//    @Published var dataArray4: [String] = []
    let manager = MyFirstGlobalActor.shared
    
    @MyFirstGlobalActor func getData()  {
        
        // HEAVY COMPLEX METHODS
        
        Task {
            let data = await manager.getDataFromDataBase()
            await MainActor.run {
                self.dataArray = data
            }
        }
    }
}

struct GlobalActorBootcamp: View {
    
    @StateObject private var viewModel = GlobalActorBootcampViewModel()
   
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await viewModel.getData()
        }
    }
}

#Preview {
    GlobalActorBootcamp()
}
