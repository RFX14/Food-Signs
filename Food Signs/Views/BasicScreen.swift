import SwiftUI

struct BasicScreen: View {
    var numColumns: Int = 3
    @StateObject var manager = BasicScreenManager()
    //var items: [BasicItem] = [.init(title: "Taco 0"), .init(title: "Taco 1"), .init(title: "Taco 2"), .init(title: "Taco 3"), .init(title: "Taco 4"), .init(title: "Taco 5"), .init(title: "Taco 6"), .init(title: "Taco 7"), .init(title: "Taco 8"), .init(title: "Taco 9"), .init(title: "Taco 10"), .init(title: "Taco 11"), .init(title: "Taco 12"), .init(title: "Taco 13"), .init(title: "Taco 14"), .init(title: "Taco 15"), .init(title: "Taco 16"), .init(title: "Taco 17"), .init(title: "Taco 18"), .init(title: "Taco 19"), .init(title: "Taco 20")]
    
    var body: some View {
        let size: Int = manager.items.count
        let itemsPerCol: Int = Int((Float(size) / Float(numColumns)).rounded(.up))
        GeometryReader { geo in
            ZStack {
                AnimatedBackground()
                VStack {
                    ForEach(0..<itemsPerCol, id: \.self) { row in
                        HStack {
                            ForEach(0..<numColumns, id: \.self) { col in
                                let option1: Int = (col * itemsPerCol) + row
                                let idx = col > 0 ? option1 : row
                                
                                if idx < size {
                                    ItemText(item: manager.items[idx])
                                }
                            }
                        }
                    }
                }
                
                if size == 0 {
                    Text("Error No Items Found")
                        .font(.title)
                        .foregroundColor(.black)
                }
                
                if manager.isUsingCache {
                    VStack {
                        Text("OFFLINE")
                            .bold()
                        Text("Menu May Not Be Valid")
                    }.font(.title)
                    .foregroundColor(.red)
                }
                
                /*
                 Still kind of like this, but doesn't work in every case, items.count = 2, and cols = 3
                HStack {
                    ForEach(0..<numColumns, id: \.self) { col in
                        VStack {
                            ForEach(0..<itemsPerCol, id: \.self) { i in
                                let idx: Int = (itemsPerCol * col) + i
                                ItemText(item: manager.items[idx])
        
                                let isLastCol = col == numColumns - 1
                                let isLastItem = i == Int(manager.items.count / numColumns) - 1
                                let colsDividesIntoItems = manager.items.count % numColumns == 0
                                if isLastCol && !colsDividesIntoItems && isLastItem {
                                    let numLeftOver = manager.items.count - idx
                                    ForEach(0..<numLeftOver, id: \.self) { j in
                                        ItemText(item: manager.items[idx + j])
                                    }
                                }
                            }
                        }
                    }
                }
                 */
            }.background(.white)
        }.onAppear {
            manager.fetchItems()
            print(manager.items.count)
        }.onDisappear {
            manager.removeListener()
        }
    }
}

struct BasicScreen_Previews: PreviewProvider {
    static var previews: some View {
        BasicScreen()
    }
}
