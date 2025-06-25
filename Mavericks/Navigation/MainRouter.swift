//
//  MainRouter.swift
//  Mavericks
//
//  Created by Миляев Максим on 24.06.2025.
//


import SpriteKit
//import SwiftUI
import GameplayKit

final class MainRouter: ObservableObject, MainViewDelegateProtocol{
    
    var activeScene: RootScene = HomeScene()

    var renderDelegate: RootSKView?
    var controlInputDelegate: ControlInputDelegate?
    
    // MARK: - Init
    init() {
        self.activeScene = loadScene(name: "TestScene")
    }
    
//initial load
    func loadScene(name: String) -> RootScene{
        
//        if let scene = GKScene(fileNamed: "TestScene"){
//            if let sceneNode = scene.rootNode as? LevelScene {
//                sceneNode.entities = scene.entities
//                sceneNode.graphs = scene.graphs
//                sceneNode.mainViewDelegate = self
//                return sceneNode
//            }else{
//                //debug
//                return HomeScene() //error scene mb?
//            }
//        }
//        else{
//            //debug
//            print("gkscn not loaded")
//            return HomeScene() //error scene mb?
//        }
        return HomeScene()
        
    }
}

// MARK: - MainViewDelegateProtocol
extension MainRouter{
    func presentScene(_ scene: ScenePath) {

       let newScene = loadScene(name: scene.rawValue)
        newScene.mainViewDelegate = self
        controlInputDelegate = newScene
        renderDelegate?.loadScene(scene: newScene)
        activeScene = newScene
    }
}




//protocol InputControlHandler {
//
//}
