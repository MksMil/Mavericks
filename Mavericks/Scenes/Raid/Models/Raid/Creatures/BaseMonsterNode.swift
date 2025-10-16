import SpriteKit

class BaseMonsterNode: SKSpriteNode{
    
    let parentUnit: MonsterModel
    
    // MARK: Init
    init(texture: SKTexture? = nil,
         size: CGSize = .zero,
         parentUnit: MonsterModel) {
        self.parentUnit = parentUnit
        
        super.init(texture: texture,
                   color: .clear,
                   size: size)
    }
    init(color: NSColor,
         size: CGSize,
         parentUnit: MonsterModel){
        self.parentUnit = parentUnit
        super.init(texture: nil,
                           color: color,
                           size: size)    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
