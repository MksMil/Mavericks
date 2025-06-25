import SwiftUI
import SpriteKit

enum InputState{
    case pressed, unnpressed
}

class TouchInputControlNode: SKSpriteNode{
    
    weak var inputDelegate: ControlInputDelegate?
  
    let leftButtonNode = BaseButtonNode()
    let rightButtonNode = BaseButtonNode()// "silver-!arrowright"
    let aButtonNode = BaseButtonNode()// "silver-A"
    let bButtonNode = BaseButtonNode() //"silver-B"
    
    let scaleFactor: CGFloat = 1 / 10
    let buttonSize: CGFloat = 1 / 10
    
    var pressedButtons: Set<SKSpriteNode> = []
    
    init(withCameraSize size: CGSize) {
        super.init(texture: nil,color: NSColor.clear, size: size)
        isUserInteractionEnabled = true
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //buttons left, right, up, down, a, b, pause/resume, special
    // labels
    func setup(){
        zPosition = 100
        //left button
        leftButtonNode.setup(withName: "silver-!arrowleft",
                             size: CGSize(width: size.width * buttonSize,
                                          height: size.width * buttonSize),
                             position: CGPoint(x: -size.width * 3.7 * scaleFactor,
                                               y: -size.height * 3.5 * scaleFactor))
        leftButtonNode.name = NodeNames.buttonLeft.name
        leftButtonNode.changeState()
        
        
        //right button
        
        rightButtonNode.setup(withName: "silver-!arrowright",
                              size: CGSize(width: size.width * buttonSize,
                                           height: size.width * buttonSize),
                              position: CGPoint(x: -size.width * 2.7 * scaleFactor,
                                                y: -size.height * 3.5 * scaleFactor))
        rightButtonNode.name = NodeNames.buttonRight.name
        rightButtonNode.changeState()
        
        //a button
        
        aButtonNode.setup(withName: "silver-A",
                          size: CGSize(width: size.width * buttonSize,
                                       height: size.width * buttonSize),
                          position: CGPoint(x: size.width * 2.7 * scaleFactor,
                                            y: -size.height * 3.5 * scaleFactor))
        aButtonNode.name = NodeNames.buttonA.name
        aButtonNode.changeState()
        
        //b button
        
        
        bButtonNode.setup(withName: "silver-B",
                          size: CGSize(width: size.width * buttonSize,
                                       height: size.width * buttonSize),
                          position: CGPoint(x: size.width * 3.7 * scaleFactor,
                                            y: -size.height * 3.25 * scaleFactor))
        bButtonNode.name = NodeNames.buttonB.name
        bButtonNode.changeState()

        addChild(leftButtonNode)
        addChild(rightButtonNode)
        addChild(aButtonNode)
        addChild(bButtonNode)
    }
    
    func updateWithSize(_ size: CGSize) {
        
    }
    #if os(iOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: parent!)
            for button in [leftButtonNode,rightButtonNode,aButtonNode,bButtonNode]{
                if button.contains(location) && !pressedButtons.contains(button){
                    pressedButtons.insert(button)
                    //send instructions to delegate
                    inputDelegate?.executeInstruction(input: NodeNames(rawValue: button.name ?? "") ?? NodeNames.empty, state: InputState.pressed)
                }
                
                if pressedButtons.contains(button){
                    button.changeStatePressed(true)
                } else {
                    button.changeStatePressed(false)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches{
            
            let location = t.location(in: parent!)
            let previousLocation = t.previousLocation(in: parent!)
            for button in [leftButtonNode,rightButtonNode,aButtonNode,bButtonNode]{
                    
                //touch leaves button
                if button.contains(previousLocation) && !button.contains(location){
                    pressedButtons.remove(button)
                    //send instruction to delegate
                    inputDelegate?.executeInstruction(input: NodeNames(rawValue: button.name ?? "") ?? NodeNames.empty, state: InputState.unnpressed)
                    button.changeStatePressed(false)
                } else if !button.contains(previousLocation) && button.contains(location){
                    pressedButtons.insert(button)
                    //send instruction to delegate
                    inputDelegate?.executeInstruction(input: NodeNames(rawValue: button.name ?? "") ?? NodeNames.empty, state: InputState.pressed)
                    button.changeStatePressed(true)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchUp(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchUp(touches, with: event)
    }
    
    func touchUp(_ touches: Set<UITouch>, with event: UIEvent?){
        for t in touches {
            let location = t.location(in: parent!)
            for button in [leftButtonNode,rightButtonNode,aButtonNode,bButtonNode]{
                if button.contains(location) && pressedButtons.contains(button){
                    pressedButtons.remove(button)
                    button.changeStatePressed(false)
                    //send instructions to delegate
                    inputDelegate?.executeInstruction(input: NodeNames(rawValue: button.name ?? "") ?? NodeNames.empty, state: InputState.unnpressed)
                }
//                if pressedButtons.contains(button){
//                    button.changeStatePressed(true)
//                } else {
//                    button.changeStatePressed(false)
//                }
            }
        }
    }
    #endif
    
}

#Preview {
    StartView()
}
