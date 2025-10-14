import SpriteKit
import SwiftUI

class RootSKView: SKView {
    
    weak var router: MainRouter?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        allowedTouchTypes = [.direct, .indirect]
        if let window = window {
            window.acceptsMouseMovedEvents = true
        }
    }
    
    func loadScene(scene: RootScene){
        //TODO: options
        presentScene(scene, transition: .crossFade(withDuration: 1))
    }
    
    
    override func scrollWheel(with event: NSEvent) {
        router?.controlInputDelegate?.handleScrollWheel(with: event)
    }
    override func magnify(with event: NSEvent) {
        router?.controlInputDelegate?.handleMagnify(with: event)
    }
    override func rotate(with event: NSEvent) {
        router?.controlInputDelegate?.handleRotate(with: event)
    }
    override func mouseDown(with event: NSEvent) {
        router?.controlInputDelegate?.handleMouseDown(with: event)
        
    }
    
    override func mouseUp(with event: NSEvent) {
        router?.controlInputDelegate?.handleMouseUp(with: event)
    }
    override func mouseDragged(with event: NSEvent) {
        router?.controlInputDelegate?.handleMouseMoved(with: event)
    }
    
    override func keyUp(with event: NSEvent) {
        router?.controlInputDelegate?.handleKeyUp(with: event)
    }
    override func keyDown(with event: NSEvent) {
        router?.controlInputDelegate?.handleKeyDown(with: event)
    }
    
    
    
    
    
}
