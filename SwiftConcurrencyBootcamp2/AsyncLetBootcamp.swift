//
//  AsyncLetBootcamp.swift
//  SwiftConcurrencyBootcamp2
//
//  Created by Валерий Зазулин on 14.01.2024.
//

import SwiftUI

// async let
// This allows us to perform multiple asynchronous functions at the same time.
// And then await for their results all together.

struct AsyncLetBootcamp: View {
    
    @State private var images: [UIImage] = []
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let url = URL(string: "https://picsum.photos/600")!
                                
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Async Let 🥳")
            .onAppear {
                Task {
                    do {
                        async let fetchImge1 = fetchImage()
                        async let fetchTitle1 = fetchTitle()
                        
                        let (image, title) = await (try fetchImge1, fetchTitle1)
//                        async let fetchImge2 = fetchImage()
//                        async let fetchImge3 = fetchImage()
//                        async let fetchImge4 = fetchImage()
//                        
//                        let (image1, image2, image3, image4) = await (try fetchImge1, try fetchImge2, try fetchImge3, try fetchImge4)
//                        
//                        self.images.append(contentsOf: [image1, image2, image3, image4])
                        
//                        let image1 = try await fetchImage()
//                        self.images.append(image1)
//
//                        let image2 = try await fetchImage()
//                        self.images.append(image2)
//                        
//                        let image3 = try await fetchImage()
//                        self.images.append(image3)
//                        
//                        let image4 = try await fetchImage()
//                        self.images.append(image4)
                    } catch {
                        
                    }
                }
            }
        }
    }
    
    func fetchTitle() async ->  String {
        return "New Title"
    }
    
    func fetchImage() async throws -> UIImage {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
    
}

#Preview {
    AsyncLetBootcamp()
}
