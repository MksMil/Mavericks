import SpriteKit

class HudButton: SKSpriteNode{
    var textureName: String = ""
    var state: Bool = true
    
    deinit {
        print("hud button deinit")
    }
    
    func setup(withName name: String, size: CGSize, position: CGPoint){
        self.textureName = name
        self.size = size
        self.position = position
        isUserInteractionEnabled = false
    }
}
