//
//  UnitFallState.swift
//  GonchikAdventure
//
//  Created by Миляев Максим on 20.03.2025.
//

import GameplayKit
import SpriteKit

class UnitFallState: GKState{
    var unit: UnitModel
    
    init(unit: UnitModel) {
        self.unit = unit
    }
    
    override func didEnter(from previousState: GKState?) {
        unit.vState = .fall
    }
    
    override func willExit(to nextState: GKState) {}
    
    override func update(deltaTime seconds: TimeInterval) {}
}
