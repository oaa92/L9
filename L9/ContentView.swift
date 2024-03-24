import SwiftUI

struct ContentView: View {
    static let center = CGPoint(x: 196, y: 426)

    @State var diameter: CGFloat = 100

    @GestureState private var startLocation: CGPoint? = nil
    @State private var location: CGPoint = ContentView.center

    var body: some View {
        ZStack {
            Circle()
                .fill(.black)
                .blur(radius: diameter / 4)
                .frame(width: diameter, height: diameter)
                .position(ContentView.center)
            Circle()
                .fill(.black)
                .blur(radius: diameter / 4)
                .frame(width: diameter, height: diameter)
                .overlay() {
                    Image(systemName: "cloud.sun.rain.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 64, height: 64)
                }
                .position(location)
                .overlay(
                    Color(white: 0.5)
                        .blendMode(.colorBurn)
                )
                .overlay(
                    Color(white: 1)
                        .blendMode(.colorDodge)
                )
                .overlay(
                    RadialGradient(
                        colors: [.yellow, .yellow, .red],
                        center: .center,
                        startRadius: 0,
                        endRadius: 125
                    )
                    .position(ContentView.center)
                    .blendMode(.plusLighter)
                )
                .gesture(simpleDrag)
        }
        .ignoresSafeArea()
    }

    private var simpleDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                var newLocation = startLocation ?? location
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                location = newLocation
                updateDiameter()
            }
            .updating($startLocation) { (value, startLocation, _) in
                startLocation = startLocation ?? location
            }
            .onEnded { _ in
                withAnimation {
                    location = ContentView.center
                    updateDiameter()
                }
            }
    }

    func updateDiameter() {
        let delta = max(abs(location.x - ContentView.center.x), abs(location.y - ContentView.center.y))
        if delta > 0 {
            var value = 100 + delta / 4
            value = min(value, 125)
            diameter = value
        } else {
            diameter = 100
        }
    }
}

#Preview {
    ContentView()
}
