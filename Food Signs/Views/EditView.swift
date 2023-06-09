//
//  EditView.swift
//  Food Signs
//
//  Created by Josue Rosales on 11/14/22.
//

import SwiftUI

struct EditView: View {
    @StateObject var manager: HomeViewManager
    @State var selectedScreen: Screen
    @State var numColumns = 1
    
    @State private var oldItems: [BasicItem] = []
    @State private var selectedItemIdx: Int = 0
    
    @State private var showPreview = false
    @State private var showSharedMenu = false
    @State private var createNewItem = false
    
    @State private var newItemName = ""
    @State private var newItemPrice = ""
    @State private var newItemDescription = ""
    
    @Environment(\.editMode) private var editMode
    @State private var canKeepAdding = true
    @State private var canKeepSubtracting = false
    
    @State private var location: CGPoint = CGPoint(x: 430, y: 155)
    @GestureState private var fingerLocation: CGPoint? = nil
    @GestureState private var startLocation: CGPoint? = nil
    
    var simpleDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                var newLocation = startLocation ?? location // 3
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                self.location = newLocation
            }.updating($startLocation) { (value, startLocation, transaction) in
                startLocation = startLocation ?? location // 2
            }
    }
    
    var fingerDrag: some Gesture {
        DragGesture()
            .updating($fingerLocation) { (value, fingerLocation, transaction) in
                fingerLocation = value.location
                //print(location)
            }
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    List {
                        // TODO: FIX THE FORCE UNWRAPPING
                        ForEach(selectedScreen.items.indices, id: \.self) { idx in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(selectedScreen.items[idx].title)
                                        .fontWeight(.medium)
                                    Spacer()
                                    Text(selectedScreen.items[idx].price)
                                }
                                Text(selectedScreen.items[idx].description ?? "")
                            }.contentShape(Rectangle())
                            .onTapGesture {
                                let item = selectedScreen.items[idx]
                                newItemName = item.title
                                newItemPrice = item.price
                                newItemDescription = item.description ?? ""
                                showSharedMenu = true
                                selectedItemIdx = idx
                            }
                        }
                        .onMove(perform: move)
                        .onDelete { indexSet in
                            selectedScreen.items.remove(atOffsets: indexSet)
                        }
                    }.onAppear {
                        print("View Appearing!")
                        print("\t\(selectedScreen.items.first?.title)")
                        oldItems = selectedScreen.items
                        print("\tOld Items Stored")
                    }.onDisappear {
                        print("View Disappearing!")
                        selectedScreen.items = oldItems
                        updateFullArrayWithChanges(screen: selectedScreen)
                        print("\t\(selectedScreen.items.first?.title)")
                        print("\t\(oldItems.first?.title)")
                        print("\tItems Reset")
                    }
                }
                
                if showPreview {
                    BasicScreenDumb(numColumns: numColumns, items: selectedScreen.items)
                        .frame(width: 960, height: 540)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .scaleEffect(0.7)
                        .rotationEffect(.degrees(90))
                        .position(CGPoint(x: geo.size.width / 2, y: (geo.size.height * 14) / 30))

                    /*
                    HStack {
                        BasicScreenDumb(numColumns: numColumns, items: selectedScreen?.items ?? [])
                            .frame(width: 960, height: 540)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .scaleEffect(0.4)
                            .position(location)
                            .gesture(simpleDrag.simultaneously(with: fingerDrag))
                    }.frame(maxHeight: geo.size.height / 3)
                     */
                }
                
                // Floating Buttons
                VStack {
                    Spacer()
                    
                    HStack {
                        VStack {
                            if showPreview {
                                Button(action: {
                                    if numColumns < 11 {
                                        numColumns += 1
                                    }
                                }, label: {
                                    Image(systemName: "plus")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(canKeepAdding ? .blue : .gray)
                                        .frame(height: geo.size.width / 6)
                                        .clipShape(Circle())
                                })
                                
                                Button(action: {
                                    if numColumns > 1 {
                                        numColumns -= 1
                                    }
                                }, label: {
                                    Image(systemName: "minus")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(canKeepSubtracting ? .blue : .gray)
                                        .frame(height: geo.size.width / 6)
                                        .clipShape(Circle())
                                })
                            }
                        }
                        
                        Spacer()
                        
                        VStack {
                            if showPreview {
                                Button(action: {
                                    print("Sending!")
                                    oldItems = selectedScreen.items
                                    print("\tOld Items Updated w/ New Items")
                                }, label: {
                                    Image(systemName: "paperplane")
                                        .foregroundColor(.white)
                                })
                                .padding()
                                .background(.red)
                                .frame(width: geo.size.width / 4)
                                .clipShape(Circle())
                            }
                            
                            Button(action: {
                                showPreview.toggle()
                            }, label: {
                                Image(systemName: showPreview ? "eye.slash" : "eye")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(.blue)
                                    .frame(width: geo.size.width / 4)
                                    .clipShape(Circle())
                            })
                        }
                    }
                }
            }.toolbar {
                EditButton()
                Button(action: {
                    print("Add Stuff!")
                    showSharedMenu = true
                    createNewItem = true
                    newItemName = ""
                    newItemPrice = ""
                    newItemDescription = ""
                }, label: {
                    Image(systemName: "plus")
                }).alert(createNewItem ? "Add New Item" : "Edit Item", isPresented: $showSharedMenu) {
                    TextField("Item Name", text: $newItemName)
                    TextField("Item Price", text: $newItemPrice)
                    TextField("Item Description", text: $newItemDescription)
                    
                    Button(role: .cancel, action: {
                        print(createNewItem ? "Adding Cancelled!" : "Editing Cancelled!")
                        createNewItem = false
                    }, label: {
                        Text("Cancel")
                    })
                    
                    Button(action: {
                        print(createNewItem ? "Adding to Array!" : "Editing Item")
                        if createNewItem {
                            let newPosition = selectedScreen.items.count
                            selectedScreen.items.append(.init(title: newItemName, price: newItemPrice, description: newItemDescription, position: newPosition))
                            addItemsToScreen(screen: selectedScreen)
                        } else {
                            selectedScreen.items[selectedItemIdx].title = newItemName
                            selectedScreen.items[selectedItemIdx].price = newItemPrice
                            selectedScreen.items[selectedItemIdx].description = newItemDescription
                            updateItemsWithChanges(screen: selectedScreen)
                        }
                        createNewItem = false
                    }, label: {
                        Text("Ok")
                    })
                }
            }.onChange(of: numColumns) { _ in
                if numColumns <= 11 {
                    canKeepAdding = true
                } else {
                    canKeepAdding = false
                }
                
                if numColumns > 1 {
                    canKeepSubtracting = true
                } else {
                    canKeepSubtracting = false
                }
            }.onAppear {
                manager.screen = selectedScreen.name
                selectedScreen.items.sort(by: {$0.position < $1.position})
                location = .init(x: geo.size.height / 2, y: geo.size.width / 2)
            }
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        selectedScreen.items.move(fromOffsets: source, toOffset: destination)
        updatePositionIndexes()
    }
    
    func updatePositionIndexes() {
        for i in 0..<selectedScreen.items.count {
            selectedScreen.items[i].position = i
        }
        
        selectedScreen.items.sort(by: {$0.position < $1.position})
    }
    
    func addItemsToScreen(screen: Screen) {
        for idx in manager.screens.indices {
            if manager.screens[idx] == screen {
                manager.screens[idx].items.append(screen.items[selectedItemIdx])
                print("\tAdd Succeded!!")
                return
            }
        }
        print("\tAdd Failed")
    }
    
    func updateFullArrayWithChanges(screen: Screen) {
        for idx in manager.screens.indices {
            if manager.screens[idx].id == screen.id {
                manager.screens[idx].items = screen.items
                
                print("\tUpdate Succeded!!")
                return
            }
        }
        
        print("\tUpdate Failed")
    }
    
    func updateItemsWithChanges(screen: Screen) {
        for idx in manager.screens.indices {
            if manager.screens[idx].id == screen.id {
                manager.screens[idx].items[selectedItemIdx] = screen.items[selectedItemIdx]
                
                print("\tUpdate Succeded!!")
                return
            }
        }
        
        print("\tUpdate Failed")
    }
}

/*
struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
*/
