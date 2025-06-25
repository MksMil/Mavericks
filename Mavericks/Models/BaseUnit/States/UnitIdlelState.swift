//
//  Created by Миляев Максим on 18.03.2025.
//
//

import GameplayKit
import SpriteKit

class UnitIdlelState: GKState{
    
    var unit: UnitModel
    
    init(unit: UnitModel) {
        self.unit = unit
    }
    
    override func didEnter(from previousState: GKState?) {
        if previousState is UnitFallState{
            unit.vState = .onGround
        }
        unit.hState = .idle
    }
    
    override func willExit(to nextState: GKState) {}
    
    override func update(deltaTime seconds: TimeInterval) {}
}

