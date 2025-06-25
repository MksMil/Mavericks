
///Start view with router initialization
///

import SpriteKit
import SwiftUI

struct StartView: View {
    @FocusState var isFocused: Bool
    @StateObject var mainRouter = MainRouter()
    
    var body: some View {
        VStack{
            Text("Hello")
            RootView(router: mainRouter)
                .ignoresSafeArea()
                .focused($isFocused)
                .onAppear{
                    isFocused = true
                }
        }
        .frame(width: 800,height: 800)
    }
    
}

#Preview {
    StartView()
}
