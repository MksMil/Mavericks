import GameplayKit

class TowerSellState: GKState{
    
    var tower: TowerModel
    
    init(tower: TowerModel) {
        self.tower = tower
    }
    
    override func didEnter(from previousState: GKState?) {
        
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
}

