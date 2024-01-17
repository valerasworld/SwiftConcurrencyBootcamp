//
//  StructClassActorBootcamp.swift
//  SwiftConcurrencyBootcamp2
//
//  Created by Валерий Зазулин on 17.01.2024.
//


/*
 Links:
 - Struct vs Class: /* https://stackoverflow.com/questions/24217586/structure-vs-class-in-swift-language */
 - Struct vs Class: /* https://medium.com/@vinayakkini/swift-basics-struct-vs-class-31b44ade28ae */
 - Value Type vs Reference Type: /*https://stackoverflow.com/questions/24217586/structure-vs-class-in-swift-language/59219141#59219141*/
 - Stack and Heap: /* https://stackoverflow.com/questions/27441456/swift-stack-and-heap-understanding */
 - Why Choose Struct over Class: /* https://stackoverflow.com/questions/24232799/why-choose-struct-over-class/24232845 */
 - How Threads Work: /* https://www.backblaze.com/blog/whats-the-diff-programs-processes-and-threads/ */
 
 VALUE TYPES:
 - Struct, Enum, String, Int, ...
 - Store in the Stack
 - Faster
 - Thread safe!
 - When you assign or pass value type a NEW COPY of data is created!
 
 REFERENCE TYPES:
 - Class, Function, Actor
 - Store in the Heap
 - Slower, but synchronized
 - NOT Thread safe (by default)
 - When you assign or pass reference type a new REFERENSE to original instance will be created (pointer)
 
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 
 STACK:
 - Stores Value Types
 - Variables allocated on the stack are stored directly to the memory, and access to this memory is very fast
 - Each Thread has its' own Stack!
 
 HEAP:
 - Stores Reference Types
 - Shared across Threads!!!
 
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 STRUCT:
 - Based on VALUES
 - Can be mutated
 - Stored in the Stack!
 
 CLASS:
 - Based on REFERENCES (INSTANCES)
 - Can not be mutated, isted we can change the value inside the Reference!
 - Stored in the Heap!
 - Inherit from other classes
 
 ACTORS:
 - Same as Class, but Thread Safe:
     - We need to be in asynchronous environment
     - We need to await to get in and out of the Actor
 
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 Structs: Data Models, Views
 Classes: View Models
 Actors: Shared 'Manager' and 'Data Store'
 
 
 
 */

import SwiftUI

class StructClassActorBootcampViewModel: ObservableObject {
    
    @Published var title: String = ""
    
    init() {
        print("ViewModel INIT")
    }
    
}

struct StructClassActorBootcamp: View {
    
    @StateObject private var viewModel = StructClassActorBootcampViewModel()
    let isActive: Bool
    
    init(isActive: Bool) {
        self.isActive = isActive
        print("View INIT")
    }
    
    var body: some View {
        Text("Hello, World!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(isActive ? Color.red : Color.blue)
            .onAppear {
//               runTest()
            }
    }
}

struct StructClassActorBootcampHomeView: View {
    
    @State private var isActive: Bool = false
    
    var body: some View {
        StructClassActorBootcamp(isActive: isActive)
            .onTapGesture {
                isActive.toggle()
            }
    }
}



#Preview {
    StructClassActorBootcamp(isActive: true)
}

extension StructClassActorBootcamp {
    
    private func runTest() {
        print("Test started!\n")
        structTest1()
        printDivivder()
        classTest1()
        printDivivder()
        actorTest1()
        
//        structTest2()
//        printDivivder()
//        classTest2()
    }
    
    private func printDivivder() {
        print("""
            
            - - - - - - -
            
            """)
    }
    
    private func structTest1() {
        print("structTest1:")
        let objectA = MyStruct(title: "Starting Title!")
        print("ObjectA: ", objectA.title)
        
        print("Pass the VALUES of objectA to objectB.")
        var objectB = objectA
        print("ObjectB: ", objectB.title)
        
        objectB.title = "Second Title!"
        print("ObjectB title changed.")
    
        print("ObjectA: ", objectA.title)
        print("ObjectB: ", objectB.title)
    }
    
    private func classTest1() {
        print("classTest1:")
        let objectA = MyClass(title: "Starting Title!")
        print("ObjectA: ", objectA.title)
        
        print("Pass the REFERENCE of objectA to objectB.")
        
        let objectB = objectA
        print("ObjectB: ", objectB.title)
        
        objectB.title = "Second Title!"
        print("ObjectB title changed.")
    
        print("ObjectA: ", objectA.title)
        print("ObjectB: ", objectB.title)
    }
    
    private func actorTest1() {
        Task {
            print("actorTest1:")
            let objectA = MyActor(title: "Starting Title!")
            await print("ObjectA: ", objectA.title)
            
            print("Pass the REFERENCE of objectA to objectB.")
            
            let objectB = objectA
            await print("ObjectB: ", objectB.title)
            
            await objectB.updateTitle(newTitle: "Second Title!")
            print("ObjectB title changed.")
        
            await print("ObjectA: ", objectA.title)
            await print("ObjectB: ", objectB.title)
        }
    }
    
}

struct MyStruct {
    var title: String
}

/// Immutable struct (data will not change)
struct CustomStruct {
    let title: String
    
    func updateTitle(newTitle: String) -> CustomStruct {
        CustomStruct(title: newTitle)
    }
}

struct MutatingStruct {
    private(set) var title: String
    
    init(title: String) {
        self.title = title
    }
    
    mutating func updateTitle(newTitle: String) {
        title = newTitle
    }
}

extension StructClassActorBootcamp {
    
    private func structTest2() {
        print("structTest2:")
        
        var struct1 = MyStruct(title: "Title 1")
        print("Struct1:", struct1.title)
        struct1.title = "Title 2"
        print("Struct1:", struct1.title)
        
        var struct2 = CustomStruct(title: "Title1")
        print("Struct2:", struct2.title)
        struct2 = CustomStruct(title: "Title2")
        print("Struct2:", struct2.title)
        
        var struct3 = CustomStruct(title: "Title1")
        print("Struct3:", struct3.title)
        struct3 = struct3.updateTitle(newTitle: "Title2")
        print("Struct3:", struct3.title)
        
        var struct4 = MutatingStruct(title: "Title1")
        print("Struct4:", struct4.title)
//        struct4.title = "Title 2"
        struct4.updateTitle(newTitle: "Title2")
        print("Struct4:", struct4.title)
    }
}

class MyClass {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}

actor MyActor {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}

extension StructClassActorBootcamp {
    
    private func classTest2() {
        print("classTest2:")
        
        let class1 = MyClass(title: "Title1")
        print("Class1:", class1.title)
        class1.title = "Title2"
        print("Class1:", class1.title)
        
        let class2 = MyClass(title: "Title1")
        print("Class2:", class2.title)
        class2.updateTitle(newTitle: "Title2")
        print("Class2:", class2.title)


    }
    
}


