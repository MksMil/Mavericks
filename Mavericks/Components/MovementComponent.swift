//
//  JumpComponent.swift
//  GonchikAdventure
//
//  Created by Миляев Максим on 19.03.2025.
//

import GameplayKit
import SpriteKit

class MovementComponent: GKComponent{
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
        var dx: CGFloat = .zero
        switch unit.hState {
            case .moveLeft:
                dx = -unit.horizontalSpeed
            case .moveRight:
                dx = unit.horizontalSpeed
            case .idle:
                dx = 0
        }
        node.position.x =  node.position.x + dx

        if let velDy = node.physicsBody?.velocity.dy{
            if unit.vState == .jump, velDy < 0{
                unit.stateMachine?.enter(UnitFallState.self)
            } else if unit.vState == .fall, velDy == 0{
                    switch unit.hState {
                        case .idle:
                            unit.stateMachine?.enter(UnitIdlelState.self)
                        case .moveLeft:
                            unit.stateMachine?.enter(UnitMoveLeftState.self)
                        case .moveRight:
                            unit.stateMachine?.enter(UnitMoveRightState.self)
                    }
            }
        }
  
    }
    
    func approach(start: CGFloat, end: CGFloat, shift: CGFloat) -> CGFloat{
        if start < end {
            return min(start + shift, end)
        } else {
            return max(start - shift, end)
        }
    }
    
    func squashAndStretch(xScale: CGFloat, yScale: CGFloat){
        node.xScale = xScale * (unit.direction == .left ? 1: -1)
        node.yScale = yScale
    }
}
