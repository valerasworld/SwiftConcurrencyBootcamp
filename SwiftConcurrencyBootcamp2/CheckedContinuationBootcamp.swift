//
//  CheckedContinuationBootcamp.swift
//  SwiftConcurrencyBootcamp2
//
//  Created by Валерий Зазулин on 16.01.2024.
//

import SwiftUI

// Continuations allow us to convert code that is not created for an asynchronous context into code that can easily be integrated into async/await methods.
// withCheckedThrowingContinuation helps to convert some @escaping closures into our Swift Concurrency code.
// This is perfect for SDKs and APIs that are not yet updated for Swift Concurrency!

class CheckedContinuationBootcampNetworkManager {
    
    func getData(url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            throw error
        }
    }
    
    func getData2(url: URL) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    continuation.resume(returning: data)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: URLError(.badURL))
                }
            }
            .resume()
        }
    }
    
    func getHeartImageFromDataBase(completionHandler: @escaping (_ image: UIImage) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            completionHandler(UIImage(systemName: "heart.fill")!)
        }
    }
    
    func getHeartImageFromDataBase() async -> UIImage {
        return await withCheckedContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if let image = UIImage(systemName: "heart.fill") {
                    continuation.resume(returning: image)
                }
            }
        }
    }
}


class CheckedContinuationBootcampViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    let networkManager = CheckedContinuationBootcampNetworkManager()
    
    func getImage() async {
        guard let url = URL(string: "https://picsum.photos/600") else { return }
        
        do {
            let data = try await networkManager.getData2(url: url)
            if let image = UIImage(data: data) {
                await MainActor.run {
                    self.image = image
                }
            }
        } catch {
            print(error)
        }
    }
    
//    func getHeartImage() {
//        networkManager.getHeartImageFromDataBase { [weak self] image in
//            self?.image = image
//        }
//    }
    
    func getHeartImage() async {
        self.image = await networkManager.getHeartImageFromDataBase()
    }
}

struct CheckedContinuationBootcamp: View {
    
    @StateObject var viewModel = CheckedContinuationBootcampViewModel()
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
//            await viewModel.getImage()
            await viewModel.getHeartImage()
        }
    }
}

#Preview {
    CheckedContinuationBootcamp()
}
