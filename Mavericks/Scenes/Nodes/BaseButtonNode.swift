//
//  BaseButtonNode.swift
//  GonchikAdventure
//
//  Created by Миляев Максим on 10.03.2025.
//

import SpriteKit

class BaseButtonNode: SKSpriteNode{
    var state: Bool = true
    var imageName: String = ""
    
    func setup(withName: String, size: CGSize,position: CGPoint){
        imageName = withName
        self.position = position
        self.size = size
        changeState()
    }
    
    func changeState(){
        state.toggle()
        let newTexture = SKTexture(imageNamed: imageName + (state ? "":"-pushed"))
        self.run(SKAction.animate(with: [newTexture], timePerFrame: 0.1))
    }
    
    func changeStatePressed(_ newState: Bool){
        self.state = newState
        let newTexture = SKTexture(imageNamed: imageName + (!state ? "":"-pushed"))
        self.run(SKAction.animate(with: [newTexture], timePerFrame: 0.1))
    }
}
