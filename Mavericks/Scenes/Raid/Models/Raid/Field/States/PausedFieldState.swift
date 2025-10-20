//
//  PausedFieldState.swift
//  Mavericks
//
//  Created by Миляев Максим on 17.10.2025.
//

import GameplayKit

class PausedFieldState: GKState{
    
    var field: Field
    
    init(field: Field) {
        self.field = field
    }
    
    override func didEnter(from previousState: GKState?) {
        field.fieldNode.isPaused = true
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
    
}

