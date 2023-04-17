import SwiftUI
import AVKit

struct StartView: View {
    @State var pageNum = 0
    @State private var isActive = false
    @State var audioPlayer: AVAudioPlayer!

    var body: some View {
        NavigationView{
            ZStack{
                BigWaveView()
                VStack{
                    Spacer()
                    
                    if pageNum == 0 {
                        
                        Image("title")
                        
                        Spacer()
                        
                        Image("explaination")
                       
                    } else if pageNum == 1 {
                        Image("howTo")
                    }
                    Spacer()
                    
                    Button(action: {
                        if pageNum != 1 {
                            pageNum += 1
                        } else {
                            isActive = true
                        }
                        
                    }, label: {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50)
                            .foregroundColor(.brown)
                    })
                    Spacer()
                }
            }
            .background(
                NavigationLink(destination: ReadyView(), isActive: self.$isActive) { // 다음 페이지로 이동
                    EmptyView()
                }
            )
            .onAppear {
                let sound = Bundle.main.path(forResource: "wave", ofType: "mp3")
                self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                self.audioPlayer.play()
            }
            .onDisappear{
                self.audioPlayer.stop()
            }
        }
        .navigationViewStyle(.stack)
        .navigationBarHidden(true)
    }
    
}
