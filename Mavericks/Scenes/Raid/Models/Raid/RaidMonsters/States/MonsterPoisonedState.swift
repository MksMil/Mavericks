import GameplayKit

//change current speed and health decrease counter, add visual, return to previous state

class MonsterPoisonedState: GKState{
    
    var monster: MonsterModel
    
    init(monster: MonsterModel) {
        self.monster = monster
    }
    
    override func didEnter(from previousState: GKState?) {
        
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
}
