import GameplayKit

// if hero in attack zone - and monster can attack, attack hero,while die, or kill hero, or hero leave attack zone. if hero killed or leave zone -> state - previous state

class MonsterAttackState: GKState{
    
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
