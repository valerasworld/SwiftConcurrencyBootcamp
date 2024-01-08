//
//  DoTryCatchThrowsBootcamp.swift
//  SwiftConcurrencyBootcamp2
//
//  Created by Валерий Зазулин on 08.01.2024.
//

import SwiftUI

// do-try
// catch
// throws

class DoTryCatchThrowsDataManager {
    
    let isActive: Bool = true
    
    func getTitle() -> (title: String?, error: Error?) {
        if isActive {
            return ("NEW TEXT!", nil)
        } else {
            return (nil, URLError(.badURL))
        }
    }
    
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("NEW TEXT!")
        } else {
            return .failure(URLError(.badURL))
        }
    }
    
    func getTitle3() throws -> String {
//        if isActive {
//            return "NEW TEXT!"
//        } else {
            throw URLError(.badURL)
//        }
    }
    
    func getTitle4() throws -> String {
        if isActive {
            return "FINAL TEXT!"
        } else {
            throw URLError(.badURL)
        }
    }
    
}

class DoTryCatchThrowsBootcampModel: ObservableObject {
    
    @Published var text: String = "Starting Text"
    let manager = DoTryCatchThrowsDataManager()

    func fetchTitle() {
        // func getTitle() -> (title: String?, error: Error?)
        /*
        let returnedValue = manager.getTitle()
        if let newTitle = returnedValue.title {
            self.text = newTitle
        } else if let error = returnedValue.error {
            self.text = error.localizedDescription
        }
        */
        
        // func getTitle2() -> Result<String, Error> // need to handle cases
        /*
        let result = manager.getTitle2()
        
        switch result {
        case .success(let newTitle):
            self.text = newTitle
        case .failure(let error):
            self.text = error.localizedDescription
        }
         */
        
        // func getTitle3() throws -> String
        /*
        // the only optional try? doesn't need to ne nested in do-catch
//        let newTitle = try? manager.getTitle3()
//        if let newTitle = newTitle {
//            self.text = newTitle
//        }
        */
        
        // func getTitle3() throws -> String
        // func getTitle4() throws -> String
        do {
            // if one of try(-ies) fails,
            // other lines in a do-block won't be executed
            // But if the optional - try? - fails, it will execute the next one
            let newTitle = try? manager.getTitle3()
            if let newTitle = newTitle {
                self.text = newTitle
            }
            
            let finalTitle = try manager.getTitle4()
            self.text = finalTitle
        } catch {
            self.text = error.localizedDescription
        }
    }
}

struct DoTryCatchThrowsBootcamp: View {
    
    @StateObject private var viewModel = DoTryCatchThrowsBootcampModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(Color.blue)
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

#Preview {
    DoTryCatchThrowsBootcamp()
}
