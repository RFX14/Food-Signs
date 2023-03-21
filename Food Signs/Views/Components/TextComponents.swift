import SwiftUI

struct ItemText: View {
    var item: BasicItem
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    Text(item.title)
                        .bold()
                    Spacer()
                    Text(item.price)
                }.font(.headline)
                if let description = item.description {
                    Text(description)
                        .lineLimit(3)
                }
            }.foregroundColor(.black)
            .frame(maxWidth: geo.size.width)
            .padding(.bottom, 10)
        }
    }
}
