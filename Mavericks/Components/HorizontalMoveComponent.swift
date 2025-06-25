//
//  HorizontalMoveComponent.swift
//  GonchikAdventure
//
//  Created by Миляев Максим on 19.03.2025.
//

import GameplayKit
import SpriteKit

class HorizontalMoveComponent: GKComponent {
    
    var node: SKSpriteNode
    var unit: UnitModel
    
    init(node: SKSpriteNode, unit: UnitModel) {
        self.node = node
        self.unit = unit
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds) //?

        if unit.hState != .idle{
            let dir: CGFloat = unit.direction == .left ? -1.0 : 1.0
            node.position.x = node.position.x + dir * unit.horizontalSpeed
        }
    }
}
