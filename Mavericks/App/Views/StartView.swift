
///Start view with router initialization
///

import SpriteKit
import SwiftUI

struct StartView: View {
    @FocusState var isFocused: Bool
    @StateObject var mainRouter = MainRouter()
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                        // Индикатор текущей сцены (для отладки или UI)
                        Text(mainRouter.activeScene is HomeScene ? "Home Base" : "Raid")
                            .font(.title)
                            .padding(.vertical,5)
                            .frame(height: 40)

                        // Игровая сцена
                        RootView(router: mainRouter)
                            .frame(width: geometry.size.width, height: geometry.size.height - 100)
                            .ignoresSafeArea()
                        
                        // Кнопка для перехода на рейд или ...
                        if mainRouter.activeScene is HomeScene {
                            HStack{
                                Button(action: {
                                    mainRouter.presentScene(.raidScene)
                                }) {
                                    Text("Start Raid")
                                        .font(.title2)
                                        .frame(width: 200)
                                        .foregroundColor(.white)
                                }
                                .background(Color.green)
                                .cornerRadius(10)
                                Button(action: {
                                    mainRouter.presentScene(.testScene)
                                }) {
                                    Text("Test textures")
                                        .font(.title2)
                                        .frame(width: 200)
                                        .foregroundColor(.white)
                                }
                                .background(Color.green)
                                .cornerRadius(10)
                            }
                            .padding(.vertical,5)
                            .frame(height: 50)
                        }
                    }
                    .focused($isFocused)
                    .onAppear {
                        isFocused = true
                    }
                }
    }
    
}

#Preview {
    StartView()
}
