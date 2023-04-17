import SwiftUI
import AVKit


struct MeditationView: View {
    @State private var isActive = false
    @State var audioPlayer: AVAudioPlayer!
    @State private var percent = 0.0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func startTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Delay for 1 second
            if self.percent < 100 {
                self.percent += 1
                self.startTimer() // Call the function recursively
            } else {
                return // Stop the timer
            }
        }
    }

    
    var body: some View {
        VStack {
            VStack {
                if percent == 100 {
                    Button(action: {
                        isActive = true
                    }, label: {
                        VStack{
                            Image("Tap the turtle!")
                            Image("turtle")
                                .resizable()
                                .frame(width: 200, height: 200, alignment: .center)
                        }
                    })
                } else {
                    VStack{
                        Image("Tap the turtle!")
                            .hidden()
                        Image("turtle")
                            .resizable()
                            .frame(width: 200, height: 200, alignment: .center)
                            .hidden()
                    }
                }
                CircleWaveView(percent: Int(self.percent))
                Slider(value: self.$percent, in: 0...100)
            }
            .padding(.all)
        }
        .background(
            NavigationLink(destination: EndView(), isActive: self.$isActive) { // 다음 페이지로 이동
                EmptyView()
            }
        )
//        .onReceive(timer) { _ in
//            self.percent += 1
//            if self.percent == 100 {
//                timer.upstream.connect().cancel()
//            }
//        }
        .onAppear {
            startTimer()
            let sound = Bundle.main.path(forResource: "hooponoponoMeditationMusic", ofType: "mp3")
            self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            self.audioPlayer.play()
        }
        .onDisappear{
            self.audioPlayer.stop()
        }
    }
}

struct Wave: Shape {
    
    var offset: Angle
    var percent: Double
    
    var animatableData: Double {
        get { offset.degrees }
        set { offset = Angle(degrees: newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        // empirically determined values for wave to be seen
        // at 0 and 100 percent
        let lowfudge = 0.02
        let highfudge = 0.98
        
        let newpercent = lowfudge + (highfudge - lowfudge) * percent
        let waveHeight = 0.015 * rect.height
        let yoffset = CGFloat(1 - newpercent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offset
        let endAngle = offset + Angle(degrees: 360)
        
        p.move(to: CGPoint(x: 0, y: yoffset + waveHeight * CGFloat(sin(offset.radians))))
        
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            p.addLine(to: CGPoint(x: x, y: yoffset + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()
        
        return p
    }
}

struct CircleWaveView: View {
    
    @State private var waveOffset = Angle(degrees: 0)
    let percent: Int
    
    var body: some View {
        
        GeometryReader { geo in
            ZStack {
                Wave(offset: Angle(degrees: self.waveOffset.degrees), percent: Double(percent)/100)
                    .fill(Color(red: 0, green: 0.5, blue: 0.75, opacity: 0.5))
                Text("\(self.percent)%")
                    .foregroundColor(.brown)
                    .font(Font.system(size: 0.1 * min(geo.size.width, geo.size.height) ))
                Image("meditator")
                    .resizable()
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                self.waveOffset = Angle(degrees: 360)
            }
        }
    }
}
