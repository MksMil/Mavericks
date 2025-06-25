#if os(iOS)
// Код, предназначенный для iOS
import SwiftUI
#elseif os(macOS)
// Код, предназначенный для macOS
//import AppKit
#else
// Код для других платформ (например, watchOS, tvOS)
#endif

import SwiftUI
import SpriteKit

class HomeScene: SKScene{
    
    weak var mainViewDelegate: MainViewDelegateProtocol?

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        size = view.frame.size
        scaleMode = .aspectFill

        setupCamera()
        addTestNode()
        backgroundColor = NSColor.orange
        
    }
    
    func setupCamera(){
        let cameraNode = SKCameraNode()
        cameraNode.name = NodeNames.camera.name
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width / 2,
                                      y: size.height / 2)
    }
    
    func addTestNode(){
        let sprite = SKSpriteNode(color: NSColor.red, size: CGSize(width: 100, height: 100))
        sprite.position = CGPoint(x: frame.midX, y: frame.midY)
        sprite.name = "testSprite"
        addChild(sprite)
    }
}
extension HomeScene: RootScene{
#if os(iOS)
    // Код, предназначенный для iOS
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
    }
#elseif os(macOS)
    // Код, предназначенный для macOS
    // Обработка прокрутки (два пальца на трекпаде)
    func handleScrollWheel(with event: NSEvent) {
        print("scroll")
        let deltaX = event.scrollingDeltaX
        let deltaY = event.scrollingDeltaY
        print("Прокрутка: deltaX = \(deltaX), deltaY = \(deltaY)")
        if let sprite = childNode(withName: "testSprite") {
            sprite.position.x += CGFloat(deltaX)// * 0.1
            sprite.position.y -= CGFloat(deltaY) //* 0.1
        }
    }
    
    // Обработка жеста масштабирования (pinch)
    func handleMagnify(with event: NSEvent) {
        print("magnify")
        let magnification = event.magnification
        print("Масштабирование: \(magnification)")
        if let sprite = childNode(withName: "testSprite") as? SKSpriteNode {
            let newScale = max(0.1, sprite.xScale + CGFloat(magnification))
            sprite.setScale(newScale)
        }
    }
    
    // Обработка жеста вращения
    func handleRotate(with event: NSEvent) {
        print("rotate")
        let rotation = event.rotation
                print("Вращение: \(rotation) градусов")
                if let sprite = childNode(withName: "testSprite") as? SKSpriteNode {
                    sprite.zRotation += CGFloat(rotation) * .pi / 180
                }
    }
    
    // Обработка касаний (например, клик или двойной клик)
    func handleMouseDown(with event: NSEvent) {
        print("mouse down")
        let location = event.locationInWindow
        let sceneLocation = convertPoint(fromView: location)
//        print("location: \(location)... scene location: \(sceneLocation)")
        if let sprite = childNode(withName: "testSprite") as? SKSpriteNode, sprite.contains(sceneLocation) {
            sprite.color = NSColor.blue
        }
    }
    
    // Обработка завершения касания
    func handleMouseUp(with event: NSEvent) {
        print("mouse up")
        let location = event.locationInWindow
        let sceneLocation = convertPoint(fromView: location)
        if let sprite = childNode(withName: "testSprite") as? SKSpriteNode, sprite.contains(sceneLocation) {
            sprite.color = NSColor.red
            sprite.alpha = 1
        }
    }
    
    // Обработка движения курсора (для касаний с перемещением)
    func handleMouseMoved(with event: NSEvent) {
        print("mouse moved")
        let location = event.locationInWindow
        let sceneLocation = convertPoint(fromView: location)
    }
    
    // Поддержка Force Touch (если трекпад поддерживает)
    func handlePressureChange(with event: NSEvent) {
        print("pressure")
        let pressure = event.pressure
        if let sprite = childNode(withName: "testSprite") as? SKSpriteNode {
            sprite.alpha = CGFloat(pressure)
        }
    }
    
    // Обработка нажатия клавиши
    func handleKeyUp(with event: NSEvent) {
        print("key up: \(event.keyCode)")
       
    }
    
    // Обработка отжатия клавиши
    func handleKeyDown(with event: NSEvent) {
        print("key down: \(event.keyCode)")
        if let sprite = childNode(withName: "testSprite") as? SKSpriteNode {
            
            switch event.keyCode {
                case 0: // Клавиша "A"
                    sprite.position.x -= 10
                case 2: // Клавиша "D"
                    sprite.position.x += 10
                case 13: // Клавиша "W"
                    sprite.position.y += 10
                case 1: // Клавиша "S"
                    sprite.position.y -= 10
                default:
                    break // Игнорировать другие клавиши
            }
        }
    }

#else
    // Код для других платформ (например, watchOS, tvOS)
    
#endif

    
}

#Preview {
    StartView()
}
