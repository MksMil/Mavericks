import SpriteKit

class HudButton: SKSpriteNode{
    var textureName: String = ""
    var state: Bool = true
    
    func setup(withName name: String, size: CGSize, position: CGPoint){
        self.textureName = name
        self.size = size
        self.position = position
        isUserInteractionEnabled = true
    }
    
    func changeState(){
        state.toggle()
        let newTexture = SKTexture(imageNamed: textureName + (!state ? "":"-pushed"))
        self.run(SKAction.animate(with: [newTexture], timePerFrame: 0.1))
    }
    
    func changeStatePressed(_ newState: Bool){
        self.state = newState
        let newTexture = SKTexture(imageNamed: textureName + (!state ? "":"-pushed"))
        self.run(SKAction.animate(with: [newTexture], timePerFrame: 0.1))
    }
    
}
