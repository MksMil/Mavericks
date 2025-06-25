//
//  VisualComponent.swift
//  GonchikAdventure
//
//  Created by Миляев Максим on 19.03.2025.
//

import GameplayKit
import SpriteKit

class VisualComponent: GKComponent {
    
    var unit: UnitModel
    var node: SKSpriteNode
    
    var lastDirection: UnitDirection
    var lastState: (hState: UnitHState, vState: UnitVState) = (.idle,.onGround)
    var lastAnimationName: String = ""
    
    init(unit: UnitModel, node: SKSpriteNode) {
        self.unit = unit
        self.node = node
        self.lastDirection = unit.direction
        super.init()
    }
    
    required init?(coder: NSCoder) {
        self.unit = UnitModel()
        self.node = SKSpriteNode()
        self.lastDirection = unit.direction
        super.init(coder: coder)
    }
    
    func changeDirection(){
        node.scale(to: CGSize(width: unit.direction == .left ? node.size.width: -node.size.width,
                              height: node.size.height))
        node.position = CGPoint(x: node.position.x + (unit.direction == .left ? node.size.width / 4: -node.size.width / 4),
                                y: node.position.y)
        if let velocity = unit.node.physicsBody?.velocity{
            unit.setupPhysicsTo(withBody: unit.direction == .left ? unit.leftDirectionPhysicBody: unit.rightDirectionPhysicBody)
            unit.node.physicsBody?.velocity = velocity
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
//        print("in visual component")
        if lastDirection != unit.direction{
            changeDirection()
            lastDirection = unit.direction
        }
        switch unit.vState {
            case .jump:
                //change texture to jump
                let name = "jump"
                if node.action(forKey: name) == nil{
                    node.removeAllActions()
                    node.run(SKAction.repeatForever(SKAction.animate(with: TextureBank.hero_jumpUpTextures, timePerFrame: 0.1)),withKey: name)
                }
            case .fall:
                //change texture to fall
                let name = "fall"
                if node.action(forKey: name) == nil{
                    node.removeAllActions()
                    node.run(SKAction.repeatForever(SKAction.animate(with: TextureBank.hero_jumpDownTextures, timePerFrame: 0.1)),withKey: "fall")
                }
            case .onGround:
                //change texture to lef/right/idle
                switch unit.hState {
                    case .moveLeft:
                        let name = "moveLeft"
                        if node.action(forKey: name) == nil{
                            node.removeAllActions()
                            //move left animation
                            node.run(SKAction.repeatForever(SKAction.animate(with: TextureBank.hero_moveLeftTextures, timePerFrame: 0.035)),withKey: name)
                        }
                    case .moveRight:
                        //moveright animation
                        let name = "moveRight"
                        if node.action(forKey: name) == nil {
                            node.removeAllActions()
                            node.run(SKAction.repeatForever(SKAction.animate(with: TextureBank.hero_moveLeftTextures, timePerFrame: 0.035)), withKey: name)
                        }
                    case .idle:
                        //idle animation
                        let name = "idle"
                        if node.action(forKey: name) == nil{
                            node.removeAllActions()
                            node.run(SKAction.repeatForever(SKAction.animate(with: TextureBank.hero_idleTextures, timePerFrame: 0.1)), withKey: name)
                        }
                }
        }
    }
}
