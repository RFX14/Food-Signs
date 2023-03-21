import SwiftUI

struct ContentView: View {
    var body: some View {
        #if os(iOS)
            HomeView()
        #else
            BasicScreen()
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
