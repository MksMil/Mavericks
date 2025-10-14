import SpriteKit
//import SwiftUI
//import GameplayKit

final class MainRouter: ObservableObject, MainViewDelegateProtocol{
    
    var activeScene: RootScene = HomeScene()

    var renderDelegate: RootSKView?
    var controlInputDelegate: ControlInputDelegate?
    
    // MARK: - Init
    init() {}
    
    func loadScene(name: ScenePath) -> RootScene{
        
        switch name {
            case .home:
                  return HomeScene()
            case .raidScene:
                  return RaidScene()
            case .testScene:
                return TestScene()
              default:
                  print("Scene \(name) not found")
                  return HomeScene()
              }
        
    }
}

// MARK: - MainViewDelegateProtocol
extension MainRouter{
    func presentScene(_ scene: ScenePath) {

       let newScene = loadScene(name: scene)
        newScene.mainViewDelegate = self
        controlInputDelegate = newScene
        renderDelegate?.loadScene(scene: newScene)
        activeScene = newScene
    }
}

