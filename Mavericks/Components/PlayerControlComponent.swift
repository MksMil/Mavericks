//
//  Created by Миляев Максим on 17.03.2025.
//

import SpriteKit
import GameplayKit

class PlayerControlComponent: GKComponent{
    //input
    var touchInputControlNode: TouchInputControlNode?
    
    //output
    var unit: UnitModel
    var scene: RootScene
    var camera: SKCameraNode
    var cameraSize: CGSize
    var offset: CGFloat {
        unit.size.width / 2 + cameraSize.width / 8
    }
    
    init(camera: SKCameraNode,
               size: CGSize,
               unit: UnitModel,
               scene: RootScene){
        touchInputControlNode = TouchInputControlNode(withCameraSize: size)
        self.unit = unit
        self.camera = camera
        self.cameraSize = size
        self.scene = scene //pause-resume
        super.init()
//        touchInputControlNode?.inputDelegate = self
        camera.addChild(touchInputControlNode!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Update
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        unit.stateMachine?.update(deltaTime: seconds)
        positionForCamera()
    }
    
    // MARK: - Deinit
    deinit{
        print("PCComponent deinit")
    }
    
    func approach(start: CGFloat, end: CGFloat, shift: CGFloat) -> CGFloat{
        if start < end {
            return min(start + shift, end)
        } else {
            return max(start - shift, end)
        }
    }
    
    func positionForCamera(){
            switch unit.direction {
                case .left:
                    camera.position.x = approach(start: camera.position.x, end: unit.node.position.x - offset, shift: 8)
                case .right:
                    camera.position.x = approach(start: camera.position.x, end: unit.node.position.x + offset, shift: 8)
            }
        if unit.vState != .jump{
            camera.position.y = approach(start: camera.position.y, end: unit.node.position.y + 50, shift: 4)
        }
    }
}

//extension PlayerControlComponent: ControlInputDelegate{
//    func executeInstruction(input: NodeNames, state: InputState) {
//        switch input {
////            case .camera:
////                <#code#>
////            case .bg:
////                <#code#>
////            case .startButton:
////                <#code#>
//            case .buttonLeft:
//                if state == .pressed {
////                    unit?.moveLeft()
//                    unit.stateMachine?.enter(UnitMoveLeftState.self)
//                } else {
////                    unit?.stopMoving()
//                    unit.stateMachine?.enter(UnitIdlelState.self)
//                }
////                print("left pressed unit hState: \(unit.hState), vState: \(unit.vState)")
//            case .buttonRight:
//                if state == .pressed {
////                    unit?.moveRight()
//                    unit.stateMachine?.enter(UnitMoveRightState.self)
//                } else {
////                    unit?.stopMoving()
//                    unit.stateMachine?.enter(UnitIdlelState.self)
//                }
////                print("right pressed unit hState: \(unit.hState), vState: \(unit.vState)")
////            case .buttonUp:
////                <#code#>
////            case .buttonDown:
////                <#code#>
//            case .buttonA:
////                print("A pressed unit hState: \(unit.hState), vState: \(unit.vState)")
//                if unit.vState == .onGround,
//                   state == .pressed{
//                    unit.stateMachine?.enter(UnitJumpState.self)
//                }
//                
//            case .buttonB:
//                print("B pressed")
////            case .buttonPauseResume:
////                <#code#>
////            case .buttonSpecail:
////                <#code#>
////            case .labelScores:
////                <#code#>
////            case .labelLives:
////                <#code#>
////            case .mainHero:
////                <#code#>
////            case .empty:
////                <#code#>
//            default: return
//        }
//    }
//}
