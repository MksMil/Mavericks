//
//  UnitJumpState.swift
//  GonchikAdventure
//
//  Created by Миляев Максим on 19.03.2025.
//

import GameplayKit
import SpriteKit

class UnitJumpState: GKState{
    var unit: UnitModel
    
    init(unit: UnitModel) {
        self.unit = unit
    }
    
    override func didEnter(from previousState: GKState?) {
        unit.vState = .jump
        unit.node.physicsBody?.applyImpulse(CGVector(dx: 0, dy: unit.verticalSpeed))
    }
    
    override func willExit(to nextState: GKState) {}
    
    override func update(deltaTime seconds: TimeInterval) {}
}
