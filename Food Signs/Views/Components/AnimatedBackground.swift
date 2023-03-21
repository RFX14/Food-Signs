import SwiftUI

struct AnimatedBackground: View {
    @State var start = UnitPoint(x: 0, y: -2)
    @State var end = UnitPoint(x: 4, y: 0)
    
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    let colors = [
        Color(#colorLiteral(red: 0.7653791308, green: 0.9746429324, blue: 1, alpha: 1)),
        Color(#colorLiteral(red: 0.6686178446, green: 0.852345705, blue: 0.9984664321, alpha: 1)),
        Color(#colorLiteral(red: 0.9982004762, green: 0.9635240436, blue: 0.7493225336, alpha: 1)),
        Color(#colorLiteral(red: 0.9937989116, green: 0.9148762822, blue: 0.6738359928, alpha: 1))
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
                .onReceive(timer) { _ in
                    withAnimation(.easeInOut(duration: 6).repeatForever()) {
                        start = UnitPoint(x: 4, y: 0)
                        end = UnitPoint(x: 0, y: 2)
                        start = UnitPoint(x: -4, y: 20)
                        end = UnitPoint(x: 4, y: 0)
                    }
                }
        }
        .ignoresSafeArea()
        .blur(radius: 50)
    }
}
