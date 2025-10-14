import SpriteKit

class BaseTowerNode: SKSpriteNode{
    
    let parentUnit: TowerModel
    
    // MARK: Init
    init(texture: SKTexture? = nil,
         size: CGSize = .zero,
         parentUnit: TowerModel) {
        self.parentUnit = parentUnit
        
        super.init(texture: texture,
                   color: .clear,
                   size: size)
    }
    init(color: NSColor,
         size: CGSize,
         parentUnit: TowerModel){
        self.parentUnit = parentUnit
        super.init(texture: nil,
                           color: color,
                           size: size)    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
