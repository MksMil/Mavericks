//
//  HealthBarNode.swift
//  Mavericks
//
//  Created by Миляев Максим on 27.11.2025.
//

import SpriteKit

class HealthBarNode: SKNode{
    let source: Damageable
    let size: CGSize
    
    let frameBar: SKShapeNode
    let bar: SKSpriteNode
    
    var isChanging: Bool = false
    
    init(source: Damageable,size: CGSize) {
        self.source = source
        self.size = size
        self.frameBar = SKShapeNode(rectOf: size)
        frameBar.strokeColor = .white
        frameBar.lineWidth = (size.height / 8).rounded()
        self.bar = SKSpriteNode(color: .red,
                               size: size)
        super.init()
        addChild(bar)
        bar.zPosition = 1
        bar.anchorPoint = CGPoint(x: 0, y: 0.5)
        addChild(frameBar)
        frameBar.position = CGPoint(x: size.width / 2,
                                    y: 0)
        frameBar.zPosition = 2
    }
    
    func changeHealth(){
        let current = source.currentHealth
        let base = source.maxHealth
        let scaleFactor: CGFloat = CGFloat(current) / CGFloat(base)
        if !isChanging {
            isChanging = true
            bar.run(SKAction.scaleX(to: scaleFactor, duration: 0.1)){
                self.isChanging = false
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
