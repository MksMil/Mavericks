// protocol to define hud interaction functionality

//import SwiftUI
import SpriteKit

protocol ControlInputDelegate: AnyObject {
//    func executeInstruction(input: NodeNames, state: InputState)
    func handleScrollWheel(with event: NSEvent)
    // Обработка жеста масштабирования (pinch)
    
    func handleMagnify(with event: NSEvent)
    
    // Обработка жеста вращения
    func handleRotate(with event: NSEvent)
    
    // Обработка касаний (например, клик или двойной клик)
    func handleMouseDown(with event: NSEvent)
    
    func handleMouseUp(with event: NSEvent)
    
    // Обработка движения курсора (для касаний с перемещением)
    func handleMouseMoved(with event: NSEvent)
    
    // Поддержка Force Touch (если трекпад поддерживает)
    func handlePressureChange(with event: NSEvent)
    
    func handleKeyUp(with event: NSEvent)
    
    func handleKeyDown(with event: NSEvent)
}
