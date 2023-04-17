import SwiftUI
import AVKit

struct EndView: View {
    @State var audioPlayer: AVAudioPlayer!
    @State private var isFloating = false

    var body: some View {
        ZStack{
            BigWaveView()
            VStack{
                Image("done")
                Image("turtle")
                    .offset(y: isFloating ? -50 : 50)
                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true))
                    .onAppear {
                        self.isFloating = true
                    }
                Image("honu")
            }
        }
        .onAppear {
            let sound = Bundle.main.path(forResource: "wave", ofType: "mp3")
            self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            self.audioPlayer.play()
        }
        .onDisappear{
            self.audioPlayer.stop()
        }
    }
}
