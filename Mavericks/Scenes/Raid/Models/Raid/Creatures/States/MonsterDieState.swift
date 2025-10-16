import GameplayKit

// die animation, remove monster

class MonsterDieState: GKState{
    var unit: MonsterModel
    
    init(unit: MonsterModel) {
        self.unit = unit
    }
    
    override func didEnter(from previousState: GKState?) {
        guard let node  = unit.node else { return }
        node.removeAllActions()
        node.removeFromParent()
        unit.spawn?.removeMonster(unit)
        unit.removeComponent(ofType: MonsterVisualComponent.self)
        unit.stateMachine = nil //strong
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
}
