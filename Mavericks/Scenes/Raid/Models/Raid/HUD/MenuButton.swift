import SpriteKit

class MenuButton: HudButton{
    var menuTexture: SKTexture = SKTexture()
//    var state: Bool = true
    
    func setup(withTexture texture: SKTexture,
               position: CGPoint){
        self.menuTexture = texture
        self.position = position
        isUserInteractionEnabled = true
    }
    
//    func changeState(){
//        state.toggle()
//    }

    
}
