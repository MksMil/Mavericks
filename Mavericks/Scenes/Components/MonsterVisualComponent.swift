import GameplayKit
import SpriteKit

enum UnitDirection: String{
    case north,south,east,west
}

class MonsterVisualComponent: GKComponent {
    
    var unit: MonsterModel?
    var lastDirection: UnitDirection = .south
    var bank: TextureBank?
    
    var hScale = 1.0
    
    init(unit: MonsterModel) {
        self.unit = unit
        self.lastDirection = unit.visualDirection
        self.bank = unit.bank
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        if let unit, let node = unit.node, let bank{
            if (node.action(forKey: ActionNames.monsterVisual.rawValue) == nil) || (lastDirection != unit.visualDirection) {
//                print("isAnimation: \(node.action(forKey: animationName) == nil)")
//                print("lastDirection:\(lastDirection) -> \(unit.visualDirection) ")
                var textures: [SKTexture] = []
                switch unit.visualDirection {
                    case .north:
                        textures = bank.moveUpTextures
                        hScale = 1.0
                    case .south:
                        textures = bank.moveDownTextures
                        hScale = 1.0
                    case .east:
                        textures = bank.moveRightTextures
                        hScale = 1.0
                    case .west:
                        textures = bank.moveRightTextures //
                        hScale = -1.0
                }
                lastDirection = unit.visualDirection
                //time per frame must be constant, because if path shorter -> animation goes faster
                let textureAction = SKAction.repeatForever(
                    SKAction.animate(with: textures,
                                     timePerFrame: 1 / 6,
                                     resize: true,
                                     restore: false))
                //        let normalAction = SKAction.animate(withNormalTextures: bank.normalMap, timePerFrame: txtDuration / 24, resize: true, restore: false)
                let animAction = SKAction.group([textureAction/*, normalAction*/])
                node.xScale = hScale
                node.run(animAction, withKey: ActionNames.monsterVisual.rawValue)
            }
        }
    }
}
