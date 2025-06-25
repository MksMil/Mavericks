import GameplayKit
import SpriteKit

class DirectionComponent: GKComponent{
    
    var node: SKSpriteNode
    var unit: UnitModel
    
    init(node: SKSpriteNode, unit: UnitModel) {
        self.node = node
        self.unit = unit
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds) //?
        switch unit.hState {
            case .moveLeft:
                if unit.direction != .left{
                    unit.direction = .left
                }
            case .moveRight:
                if unit.direction != .right{
                    unit.direction = .right
                }
            case .idle:
                return
        }        
    }
    
    
    
}
