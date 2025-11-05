import SpriteKit

class HudButton: BaseRaidNode{
    var tapped: Bool = false
    
    func changeStateToTapped(_ tapped: Bool,
                             completion: (()->())? = nil){
        run(SKAction.scale(to: tapped ? 1.1:1.0, duration: 0.1)){
            completion?()
        }
    }
    
    deinit {
        print("hud button deinit")
    }
    
    init(type: BaseRaidNodeType,
         texture: SKTexture,
         position: CGPoint = .zero) {
        super.init(type: type, size: texture.size())
        self.texture = texture
        self.position = position
        isUserInteractionEnabled = false
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
