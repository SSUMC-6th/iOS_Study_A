import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            // 상단 Safe Area에 색상 적용
            Color.mint.edgesIgnoringSafeArea(.top)
                .frame(height: 0)
            
            GeometryReader { geometry in
                ZStack (alignment: .top) {
                    Rectangle()
                        .fill(Color.mint)
                        .frame(width: geometry.size.width, height: 100)
                        .cornerRadius(10.0)
                    
                
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .offset(y: -20)
            .frame(height: 100)  // GeometryReader의 높이 지정
            .padding(.bottom, 10)
            
            // 쿠폰 버튼
            Button(action: {}) {
                Text("쿠폰 버튼")
                    .frame(width: 320, height: 40)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10.0).strokeBorder())
                    .frame(width: 200)
                    .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, 10)
            
            // Btn1, Btn2, Btn3 버튼들
            HStack(spacing: 10) {
                Button(action: {}) {
                    Text("Btn1")
                        .frame(width: 110, height: 110)
                        .background(RoundedRectangle(cornerRadius: 10.0).strokeBorder())
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {}) {
                    Text("Btn2")
                        .frame(width: 110, height: 110)
                        .background(RoundedRectangle(cornerRadius: 10.0).strokeBorder())
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {}) {
                    Text("Btn3")
                        .frame(width: 110, height: 110)
                        .background(RoundedRectangle(cornerRadius: 10.0).strokeBorder())
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.bottom, 10)
            
            // 10개 버튼
            Group {
                VStack(spacing: 10) {
                    Text("대용량특가")
                    ForEach(0..<2) { _ in
                        HStack(spacing: 10) {
                            ForEach(0..<5) { _ in
                                Button(action: {}) {
                                    Text("")
                                        .frame(width: 60, height: 60)
                                        .background(RoundedRectangle(cornerRadius: 10.0).strokeBorder())
                                }
                            }
                        }
                    }
                }
            }
            .padding(7)
            .background(RoundedRectangle(cornerRadius: 15.0).strokeBorder())
            
            // TabView
            TabView {
                // 검색 탭
                Color.clear
                    .tabItem {
                        Label("검색", systemImage: "magnifyingglass")
                    }
                // 찜 탭
                Color.clear
                    .tabItem {
                        Label("찜", systemImage: "heart")
                    }
                // 메인 화면 탭
                Color.clear
                    .tabItem {
                        Label(" ", systemImage: "b.circle")
                    }
                // 주문 내역 탭
                Color.clear
                    .tabItem {
                        Label("주문 내역", systemImage: "menucard")
                    }
                // my 배민 탭
                Color.clear
                    .tabItem {
                        Label("my 배민", systemImage: "person")
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
