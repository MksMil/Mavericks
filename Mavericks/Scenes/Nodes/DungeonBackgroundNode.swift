//
//  DungeonBackgroundNode.swift
//  GonchikAdventure
//
//  Created by Миляев Максим on 14.03.2025.
//

//just for preview
import SwiftUI
import SpriteKit

class DungeonBackgroundNode: SKNode{
    
    var centerPoint = CGPoint.zero
    var width: CGFloat = 0
    var height: CGFloat = 0
    
    var dx: CGFloat = CGFloat.zero
    
    var fullSize: CGSize = CGSize.zero
    let timeInterval: TimeInterval = 40
    
    func setup(withSize: CGSize,fullSize: CGSize){
        self.fullSize = fullSize
        width = withSize.width
        height = withSize.height
        
        dx = withSize.width / fullSize.width
        
        let mainBg = createBg(name: "lvl_0",zpos: 1)
        let rock3 = createBg(name: "rock3", zpos: 4)
        let rock5 = createBg(name: "rock5", zpos: 3)
        let rock1 = createBg(name: "rock1", zpos: 8)
        let rock2 = createBg(name: "rock2", zpos: 8)
        
        addChild(mainBg)
        addChild(rock5)
        moveMyst()
        addChild(rock3)
        addChild(rock1)
        addChild(rock2)
        
        
    }
    
    func updateBG(pos: CGPoint){
        let offset = pos.x / fullSize.width
        children.forEach { node in
            if let name = node.name,
               ["rock3","rock5","rock1","rock2"].contains(name) {
                node.position.x = -(node.frame.width  - width) * offset 
            }
        }
    }
   
    func moveMyst(){
        let myst = createBg(name: "myst", zpos: 2)
        let myst1 = createBg(name: "myst", zpos: 2)

        myst1.position = CGPoint(x: -myst.size.width, y: 0)
        
        addChild(myst)
        addChild(myst1)
        
        let moveAction = SKAction.moveTo(x: width, duration: timeInterval)
        let moveToStart = SKAction.moveTo(x: -width, duration: 0)
        
        myst.run(SKAction.moveTo(x: width, duration: timeInterval / 2)) {
            myst.run(SKAction.repeatForever(SKAction.sequence([moveToStart,moveAction])))
        }
        myst1.run(SKAction.repeatForever(SKAction.sequence([moveAction,
                                                            moveToStart])
                                        )
                    )
    }
    
    func createBg(name: String, zpos: CGFloat)->SKSpriteNode{
        let texture = SKTexture(imageNamed: name)
        let nodesize = CGSize(width: width + width * zpos / 20, height: height)
        let node = SKSpriteNode(texture: texture, size: nodesize)
        node.name = name
        return node
    }
    
    
}

#Preview {
    StartView()
}
