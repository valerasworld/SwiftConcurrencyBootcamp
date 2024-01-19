//
//  AsyncPublisherBootcamp.swift
//  SwiftConcurrencyBootcamp2
//
//  Created by Валерий Зазулин on 19.01.2024.
//

import SwiftUI
import Combine

// AsyncPublisher helps to bridge the gap between Combine and Swift Concurrency.
// This becomes a major factor when migrating applications
// that were previously not set up for Async/Await,
// specifically, if we use the @Published property wrapper often
// and want to convert the publisher into an AsyncPublisher.

class AsyncPublisherDataManager {
    
    @Published var myData: [String] = []
    
    func addData() async {
        myData.append("Apple")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Banana")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Orange")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Watermelon")

    }
    
}

class AsyncPublisherBootcampViewModel: ObservableObject {
    
    @MainActor @Published var dataArray: [String] = []
    let manager = AsyncPublisherDataManager()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        Task {
            // code below the loop will never be executed,
            // because it will listen to the updates forever
            // if we need more than one subscriber,
            // we need to use separate Tasks
            for await value in manager.$myData.values {
                await MainActor.run {
                    self.dataArray = value
                }
            }
        }
        
// COMBINE WAY:
//        manager.$myData
//            .receive(on: DispatchQueue.main, options: nil)
//            .sink { dataArray in
//                self.dataArray = dataArray
//            }
//            .store(in: &cancellables)
    }
    
    func start() async {
        await manager.addData()
    }
    
}

struct AsyncPublisherBootcamp: View {
    
    @StateObject private var viewModel = AsyncPublisherBootcampViewModel()
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.dataArray, id: \.self) {
                Text($0)
                    .font(.headline)
            }
        }
        .task {
            await viewModel.start()
        }
    }
}

#Preview {
    AsyncPublisherBootcamp()
}
