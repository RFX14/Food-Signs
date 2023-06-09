import Foundation

struct Screen: Identifiable, Hashable  {
    static func == (lhs: Screen, rhs: Screen) -> Bool {
        if lhs.name == rhs.name {
            if lhs.items.count == rhs.items.count {
                for i in 0..<lhs.items.count {
                    if lhs.items[i] != rhs.items[i] {
                        return false
                    }
                }
                return true
            }
        }
        return false
    }
    
    let id = UUID()
    let name: String
    var items: [BasicItem] = []
}
