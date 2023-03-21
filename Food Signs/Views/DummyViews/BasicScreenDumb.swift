import SwiftUI

struct BasicScreenDumb: View {
    var numColumns: Int = 1
    var items: [BasicItem] = []
    //var items: [BasicItem] = [.init(title: "Taco 0"), .init(title: "Taco 1"), .init(title: "Taco 2"), .init(title: "Taco 3"), .init(title: "Taco 4"), .init(title: "Taco 5"), .init(title: "Taco 6"), .init(title: "Taco 7"), .init(title: "Taco 8"), .init(title: "Taco 9"), .init(title: "Taco 10"), .init(title: "Taco 11"), .init(title: "Taco 12"), .init(title: "Taco 13"), .init(title: "Taco 14"), .init(title: "Taco 15"), .init(title: "Taco 16"), .init(title: "Taco 17"), .init(title: "Taco 18"), .init(title: "Taco 19"), .init(title: "Taco 20")]
    var body: some View {
        let size: Int = items.count
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
                                    ItemText(item: items[idx])
                                }
                            }
                        }
                    }
                }.padding(60)
            }.background(.white)
        }
    }
}

struct BasicScreenDumb_Previews: PreviewProvider {
    static var previews: some View {
        BasicScreenDumb()
    }
}
