//
//  ContentView.swift
//  StructClassActor
//
//  Created by Skorobogatow, Christian on 29/7/22.
//


/*
 - https://blog.onewayfirst.com/ios/post...
 - https://stackoverflow.com/questions/2...
 - https://medium.com/@vinayakkini/swift...
 - https://stackoverflow.com/questions/2...
 - https://stackoverflow.com/questions/2...
 - https://stackoverflow.com/questions/2...
 - https://www.backblaze.com/blog/whats-...
 - https://medium.com/doyeona/automatic-...
 
 
 VALUE TYPES:
 - Struct, Enum, String, etc.
 - Stored in the stack
 - faster
 - Threadsafe!
 - When you assign or pass value type a new copy of data is created
 
 
 REFERENCE TYPES:
 - Class, Function , Actor
 - Store in the Heap
 - Slower, but synchronized
 - NOT Thread safe
 - When you assign orpass reference type a new reference to the original instance will be created (pointer)
 
 --------------------------------------------------
 
 STACK:
 - Stored Value Types
 - Variables allocated to the stack are stored directly to the memory and acces this memory is very fast
 - Each Thread has its own Stack
 
 
 HEAP:
 - Stores Reference types
 - Shared across threads!
 
 --------------------------------------------------
 
 STRUCT:
 - Based on VALUES
 - Can be mutated
 - Stored in the Stack
 
 CLASSES:
 - Based on REFERENCES (INSTANCES)
 - Stored in the heap!
 - Inherit from other classes
 
 ACTOR:
 - Same as Class, but thread safe!
 
 
 --------------------------------------------------
 
 Structs: Data Models, Views
 Classes: ViewModel
 Actors: Shared "Manager" and "Data Store"
 
 */
 

import SwiftUI

actor structClassActorDatamanager{
    
    func getDataFromDatabase() {
        
    }
    
}

class StructClassActorViewModel: ObservableObject {
    @Published var title: String = ""
    
    init() {
        print("ViewModel init")
    }
    
}


struct StructClassActorView: View {
    
    @StateObject private var viewModel = StructClassActorViewModel()
    let isActive: Bool
    
    init(isActive: Bool) {
        self.isActive = isActive
        print("View INIT")

    }
    
    var body: some View {
        Text("Hello, world!")
            .frame(maxWidth: .infinity , maxHeight: .infinity)
            .ignoresSafeArea()
            .background(isActive ? .red : .blue)
            .onAppear {
                runTest()
            }
    }
}

struct StructClassActorHomeView: View {
    
    @State private var isActive: Bool = false
    
    var body: some View {
        StructClassActorView(isActive: isActive)
            .onTapGesture {
                isActive.toggle()
            }
    }
}

extension StructClassActorView {
    private func runTest() {
        print("Test Started")
        
//        printDivider()
//        structTest1()
//        printDivider()
//        classTest1()
//        printDivider()
//        actorTest1()
        
        
//        structTest2()
//        printDivider()
//        classTest2()
    }
    
    private func printDivider() {
        print("""

            ------------------------------------------

            """)
    }
    
    
    private func structTest1() {
        print("structTest1")
        
        let objectA = MyStruct(title: "Starting Title")
        print("ObjectA: ", objectA.title)
        
        print("Pass the values of objectA to objectB2")
        var objectB = objectA
        print("ObjectB: ", objectB.title)
        
        objectB.title = "Second title!"
        print("\n ObjectB title changed \n")
        
        print("ObjectA: ", objectA.title)
        print("ObjectB: ", objectB.title)
        
        // NEW VALUE TYPE IS CREATED WHEN ASSIGNING B TO A
    }
    
    private func classTest1() {
        print("classTest1")
        
        let objectA = MyClass(title: "Starting title!")
        print("ObjectA: ", objectA.title)
        
        print("Pass the REFERENCE of objectA to objectB2")
        let objectB = objectA
        print("ObjectB: ", objectB.title)
        
        objectB.title = "Second title!"
        print("\n ObjectB title changed \n")
        
        print("ObjectA: ", objectA.title)
        print("ObjectB: ", objectB.title)
    }
    
    private func actorTest1() {
        Task {
            print("actorTest1")
            
            let objectA = MyActor(title: "Starting title!")
            await print("ObjectA: ", objectA.title)
            
            print("Pass the REFERENCE of objectA to objectB2")
            let objectB = objectA
            await print("ObjectB: ", objectB.title)
            
            await objectB.updateTitle(newTitle: "Second Title")
            print("\n ObjectB title changed \n")
            
            await print("ObjectA: ", objectA.title)
            await print("ObjectB: ", objectB.title)
        }
    }
}



struct MyStruct {
    var title: String
}

// Immutable struct
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

extension StructClassActorView {
    
    
    private func structTest2() {
        print("structTest2")
        
        var struct1 = MyStruct(title: "Title1")
        print("Struct1: ", struct1.title)
        struct1.title = "Title2"
        print("Struct1: ", struct1.title)
        
        var struct2 = CustomStruct(title: "Title1")
        print("Struct2: ", struct2.title)
        struct2 = CustomStruct(title: "Title2")
        print("Struct2: ", struct2.title)

        var struct3 = CustomStruct(title: "Title1")
        print("Struct3: ", struct3.title)
        struct3 = struct3.updateTitle(newTitle: "Title2")
        print("Struct3: ", struct3.title)
        
        var struct4 = MutatingStruct(title: "Title1")
        print("Struct4: ", struct4.title)
        struct4.updateTitle(newTitle: "Title2")
        print("Struct4: ", struct4.title)
        
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


extension StructClassActorView {
    
    
    private func classTest2() {
        print("clasTest2")
        
        let class1 = MyClass(title: "Title1")
        print("Class1 ", class1.title)
        class1.title = "Title2"
        print("Class1 ", class1.title)
        
        let class2 = MyClass(title: "Title1")
        print("Class1 ", class2.title)
        class2.updateTitle(newTitle: "Title2")
        print("Class1 ", class2.title)
        
        
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
