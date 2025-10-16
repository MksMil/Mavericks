import GameplayKit

// idle aniamtion wor "wait"

class MonsterIdleState: GKState{
    
    var monster: MonsterModel
    
    init(monster: MonsterModel) {
        self.monster = monster
    }
    override func didEnter(from previousState: GKState?) {
        print("enter to idle state")
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
}
