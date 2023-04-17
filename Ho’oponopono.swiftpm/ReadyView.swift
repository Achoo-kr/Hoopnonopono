import SwiftUI

struct ReadyView: View {
    @State private var count = 5
    @State private var isActive = false
    
    var body: some View {
        VStack {
            
            Image("sessionReady")
                .padding()
            
            Text("\(count)") // 현재 값을 표시
                .font(.system(size: 60))
                .foregroundColor(.brown)
                .bold()
                .padding()
        }
        .onAppear {
            // 매 초마다 count 값을 감소시킴
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if self.count > 1 {
                    self.count -= 1
                } else {
                    self.isActive = true // 다음 페이지로 전환할 수 있도록 isActive 값을 true로 설정
                    timer.invalidate() // 타이머 중지
                }
            }
        }
        .background(
            NavigationLink(destination: MeditationView(), isActive: self.$isActive) { // 다음 페이지로 이동
                EmptyView()
            }
            .navigationBarHidden(true)
        )
    }
}
