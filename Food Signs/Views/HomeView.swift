import SwiftUI

struct HomeView: View {
    @StateObject var manager = HomeViewManager()
    @State private var selectedScreen: Screen?
    // TODO: FIX THE FLOATING BUTTONS
    var body: some View {
        GeometryReader { geo in
            NavigationSplitView {
                List(manager.screens, id: \.self, selection: $selectedScreen) { screen in
                    Text(screen.name)
                }
            } detail: {
                if selectedScreen != nil {
                    EditView(manager: manager, selectedScreen: selectedScreen!)
                } else {
                    Text("Select Screen To View & Edit")
                }
            }.onAppear {
                manager.fetchAvailableScreens {
                    manager.screens.sort(by: {$0.name < $1.name})
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
