
///Start view with router initialization
///

import SpriteKit
import SwiftUI

struct StartView: View {
    @FocusState var isFocused: Bool
    @StateObject var mainRouter = MainRouter()
    
    var body: some View {
        GeometryReader { geometry in
                    VStack {
                        // Индикатор текущей сцены (для отладки или UI)
                        Text(mainRouter.activeScene is HomeScene ? "Home Base" : "Raid")
                            .font(.title)
                            .padding()
                        
                        // Игровая сцена
                        RootView(router: mainRouter)
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.8)
                            .ignoresSafeArea()
                        
                        // Кнопка для перехода на рейд
                        if mainRouter.activeScene is HomeScene {
                            Button(action: {
                                mainRouter.presentScene(.raidScene)
                            }) {
                                Text("Start Raid")
                                    .font(.title2)
                                    .padding()
                                    .frame(width: 200)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding()
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
