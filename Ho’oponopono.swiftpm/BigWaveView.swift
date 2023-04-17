import SwiftUI

struct BigWaveView: View {
    
    let colors = [Color(red: 29 / 255, green: 66 / 255, blue: 123 / 255),
                  Color(red: 40 / 255, green: 93 / 255, blue: 153 / 255), 
                  Color(red: 52 / 255, green: 118 / 255, blue: 186 / 255), 
                  Color(red: 64 / 255, green: 145 / 255, blue: 218 / 255), 
                  Color(red: 84 / 255, green: 167 / 255, blue: 226 / 255), 
                  Color(red: 113 / 255, green: 189 / 255, blue: 235 / 255), 
                  Color(red: 145 / 255, green: 211 / 255, blue: 243 / 255), 
                  Color(red: 181 / 255, green: 232 / 255, blue: 252 / 255)]
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.clear
                ZStack {
                    ForEach(Array(colors.enumerated()), id: \.offset) { index, color in
                        WaveView(waveColor: color,
                                 waveHeight: Double(colors.count - index) * Double.random(in: 0.007 ... 0.008),
                                 progress: Double(colors.count - index) * 10)
                    }
                }
                .shadow(color: Color.black.opacity(0.4), radius: 40, x: 0, y: 0)
                .frame(width: proxy.size.width, height: proxy.size.height)
                
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct WaveShape: Shape {
    
    var offset: Angle
    var waveHeight: Double = 0.025
    var percent: Double
    
    var animatableData: Double {
        get { offset.degrees }
        set { offset = Angle(degrees: newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        let waveHeight = waveHeight * rect.height
        let yoffset = CGFloat(1.0 - percent) * (rect.height - 8 * waveHeight)
        let startAngle = offset
        let endAngle = offset + Angle(degrees: 361)
        
        p.move(to: CGPoint(x: 0, y: yoffset + waveHeight * CGFloat(sin(offset.radians))))
        
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 8) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            p.addLine(to: CGPoint(x: x, y: yoffset + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()
        
        return p
    }
}

struct WaveView: View {
    
    var waveColor: Color
    var waveHeight: Double = 0.025
    var progress: Double
    
    @State private var waveOffset = Angle(degrees: 0)
    
    var body: some View {
        ZStack {
            WaveShape(offset: waveOffset, waveHeight: waveHeight, percent: Double(progress)/100)
                .fill(waveColor)
        }
        .onAppear {
            DispatchQueue.main.async {
                withAnimation(Animation.linear(duration: CGFloat(waveHeight * 100)).repeatForever(autoreverses: false)) {
                    self.waveOffset = Angle(degrees: 360)
                }
            }
        }
    }
}
