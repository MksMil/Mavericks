import SwiftUI
//bridge
struct RootView: NSViewRepresentable{

    let router: MainRouter
    
    func makeNSView(context: Context) -> RootSKView {
        let view = RootSKView()
        view.frame = CGRect(x: 0, y: 0, width: 800, height: 600)
        view.router = router
        router.renderDelegate = view
        router.presentScene(.home)
        return view
    }
    func updateNSView(_ nsView: NSViewType, context: Context) {
        
    }
    
}
