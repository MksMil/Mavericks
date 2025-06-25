//
//  UnitModel.swift
//  GonchikAdventure
//
//  Created by Миляев Максим on 19.03.2025.
//

import GameplayKit

class UnitModel {
    
    var name: String        = "" // enum needed
    var textureName: String = "" // enum needed
    var node: GameUnit = GameUnit()
    
    var lives: Int          = 3
    var scores: Int         = 0
    
    var size: CGSize        = CGSize(width: 64, height: 64)//.zero
    
    var direction: UnitDirection = .left
    var hState: UnitHState       = .idle
    var vState: UnitVState       = .onGround
    
    
    var horizontalSpeed: CGFloat = 3.5
    var verticalSpeed: CGFloat = 350.0
    
    var vAccelerate: CGFloat = 0.1
    var vDecelerate: CGFloat = 0.0
    
    var gAccelerate: CGFloat = 0.2
    var gDecelerate: CGFloat = 0.5
    
    var stateMachine: GKStateMachine?
    
    //physicBodies
//    let leftDirectionPhysicBody = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 40), center: CGPoint(x: -10, y: 0))
    let leftDirectionPhysicBody = SKPhysicsBody(circleOfRadius: 18, center: CGPoint(x: -10, y: 0))
//    let rightDirectionPhysicBody = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 40), center: CGPoint(x: 10, y: 0))
    let rightDirectionPhysicBody = SKPhysicsBody(circleOfRadius: 18, center: CGPoint(x: 10, y: 0))
    
    func setupStateMachine(){
        let idleState = UnitIdlelState(unit: self)
        let moveLeftState = UnitMoveLeftState(unit: self)
        let moveRightState = UnitMoveRightState(unit: self)
        let jumpState = UnitJumpState(unit: self)
        let fallState = UnitFallState(unit: self)
        stateMachine = GKStateMachine(states: [idleState,moveLeftState,moveRightState, jumpState,fallState])
        stateMachine?.enter(UnitIdlelState.self)
    }
    
    func makeEntity()->GKEntity{
        let entity = GKEntity()
        let texture = TextureBank.hero_idleTextures[0]//SKTexture(imageNamed: textureName)
        node = GameUnit(texture: texture, size: size, parentUnit: self)
        //add Components?

        let vComponent = VisualComponent(unit: self,
                                         node: node)
//        let directionComponent = DirectionComponent(node: node,
//                                                    unit: self)
        let movementComponent = MovementComponent(node: node,
                                          unit: self)
        entity.addComponent(vComponent)
//        entity.addComponent(directionComponent)
        entity.addComponent(movementComponent)
        setupStateMachine()
        setupPhysicsTo(withBody:leftDirectionPhysicBody)
        return entity
    }
    
    func setupPhysicsTo(withBody: SKPhysicsBody){
        node.physicsBody = withBody
        node.physicsBody?.restitution = 0 //отскок(упругость) [0:1] 0 - не отскакиевает
        node.physicsBody?.density = 10 //плотность
        node.physicsBody?.isDynamic = true
        node.physicsBody?.friction = 1 //сопротивление
        
        node.physicsBody?.linearDamping = 0 //затухание линейной скорости
        node.physicsBody?.angularDamping = 0 //затухание угловой скорости
        
        node.physicsBody?.allowsRotation = false
        
        node.physicsBody?.categoryBitMask = PhysicsCategory.Player
        //своя категория
        node.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle //+ PhysicsCategory.Edges
        print(node.physicsBody?.contactTestBitMask)
        //с какой категорией проводится тест на контакт при симуляции физики
        
        node.physicsBody?.collisionBitMask = PhysicsCategory.Obstacle + PhysicsCategory.Edges
        // контакт с какой категорией влияет на это тело, по умоланию все категории
        node.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    func changeSteteTo(_ state: GKState.Type){
        stateMachine?.enter(state)
    }
}
