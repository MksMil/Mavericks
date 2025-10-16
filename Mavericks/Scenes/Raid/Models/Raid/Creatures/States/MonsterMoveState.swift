import GameplayKit
import SpriteKit
//change visual

class MonsterMoveState: GKState{
    
    var monster: MonsterModel
    
    init(monster: MonsterModel) {
        self.monster = monster
    }
    
    override func didEnter(from previousState: GKState?) {
        moveToClosest()
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
    
    
    func moveToClosest(){
        var fromCenterCell: Bool
        let path = monster.gridPath
        
        guard let node = monster.node else {
            if let oldPosition = monster.lastPathPosition,
               let old = monster.spawn?.field.cellInGridPosition(oldPosition){
                old.updateWithMonster(monster, enterIn: false)
            }
            if let oldPosition = monster.nextPathPosition,
               let old = monster.spawn?.field.cellInGridPosition(oldPosition){
                old.updateWithMonster(monster, enterIn: false)
            }
            monster.die() // change state to attack 'block'?
            return
        }
        node.removeAction(forKey: ActionNames.monsterMove.rawValue)
        guard path.count > 1 else {
            //change cells state for towers aim component
            if let oldPosition = monster.lastPathPosition,
               let old = monster.spawn?.field.cellInGridPosition(oldPosition){
                old.updateWithMonster(monster, enterIn: false)
            }
            if let oldPosition = monster.nextPathPosition,
               let old = monster.spawn?.field.cellInGridPosition(oldPosition){
                old.updateWithMonster(monster, enterIn: false)
            }
            //new state for monster
            print("in first check")
            self.monster.stateMachine?.enter(MonsterIdleState.self)
            return
        }
        
        //check direction and change state if needed
        let width = node.position.x - SceneHelper.gridPositionToScene(position: path[1].gridPosition).x
        let height = node.position.y - SceneHelper.gridPositionToScene(position: path[1].gridPosition).y
        
        //direction changes
        if width == 0 {
            if height > 0 {
                //move down
                monster.visualDirection = .south
            } else if height < 0 {
                //move up
                monster.visualDirection = .north
            } else {
                //unexpected -idle
                monster.visualDirection = .south
            }
        } else if width > 0{
            //move left
            monster.visualDirection = .west
        } else if width < 0 {
            //move right
            monster.visualDirection = .east
        } else {
            //unexpected -idle
            monster.visualDirection = .south
        }
        
        let startPoint = node.position
        var endPoint: CGPoint = SceneHelper.gridPositionToScene(position: path[0].gridPosition)
        
        if endPoint == startPoint{
            // if there is the new path, and unit not in center of the cell path[0] update cell states,
            // and move animation is path[0] -> path[1]
            // flag for change path array after move complerion
            fromCenterCell = true
            endPoint = SceneHelper.gridPositionToScene(position: path[1].gridPosition)
            let old = monster.spawn?.field.cellInGridPosition(path[0].gridPosition)
            old?.updateWithMonster(monster, enterIn: false)
            let new = monster.spawn?.field.cellInGridPosition(path[1].gridPosition)
            new?.updateWithMonster(monster, enterIn: true)
            
            monster.lastPathPosition = path[0].gridPosition
            monster.nextPathPosition = path[1].gridPosition
        } else {
            // if there is the new path, and unit not in center of the cell update cell states,
            // and move animation is curentPosition -> path[0]
            // do not change path array after move completion
            fromCenterCell = false
            if let oldPosition = monster.lastPathPosition {
                let old = monster.spawn?.field.cellInGridPosition(oldPosition)
                old?.updateWithMonster(monster, enterIn: false)
            }
            if let oldPosition = monster.nextPathPosition{
                let old = monster.spawn?.field.cellInGridPosition(oldPosition)
                old?.updateWithMonster(monster, enterIn: false)
            }
            let new = monster.spawn?.field.cellInGridPosition(path[0].gridPosition)
            new?.updateWithMonster(monster, enterIn: true)
            self.monster.lastPathPosition = nil
            self.monster.nextPathPosition = path[0].gridPosition
        }
        
        //durations
        let xDuration = durationForValue(start: startPoint.x,
                                         end: endPoint.x)
        let yDuration = durationForValue(start: startPoint.y,
                                         end: endPoint.y)
        
        // move Actions
        let actionX = SKAction.moveTo(x: endPoint.x,
                                      duration: xDuration)
        let actionY = SKAction.moveTo(y: endPoint.y,
                                      duration: yDuration)
        
        if abs(width) >= abs(height) {
            let moveAction = SKAction.sequence([actionY,actionX])
            let waitAction = SKAction.wait(forDuration: xDuration + yDuration)
            let complAction = SKAction.run {
                guard self.monster.gridPath.count > 0 else {
                    //change state
                    print("in move to closest")
                    self.monster.stateMachine?.enter(MonsterIdleState.self)
                    return
                }
                if fromCenterCell{
                    self.monster.gridPath.remove(at: 0)
                }
                self.monster.stateMachine?.enter(MonsterMoveState.self)
            }
            let complSeqAction = SKAction.sequence([waitAction,complAction])
            
            node.run(moveAction,withKey: ActionNames.monsterMove.rawValue)
            node.run(complSeqAction,withKey: ActionNames.monsterMoveCompletion.rawValue)
            
        } else if abs(width) < abs(height) {
            let moveAction = SKAction.sequence([actionX,actionY])
            let waitAction = SKAction.wait(forDuration: xDuration + yDuration)
            let complAction = SKAction.run {
                guard self.monster.gridPath.count > 0 else {
                    //change state
                    print("in last check")
                    self.monster.stateMachine?.enter(MonsterIdleState.self)
                    return
                }
                if fromCenterCell{
                    self.monster.gridPath.remove(at: 0)
                }
                self.monster.stateMachine?.enter(MonsterMoveState.self)
            }
            let complSeqAction = SKAction.sequence([waitAction,complAction])
            
            node.run(moveAction,withKey: ActionNames.monsterMove.rawValue)
            node.run(complSeqAction,withKey: ActionNames.monsterMoveCompletion.rawValue)
        } else {
            //width == height, unexpected behavior
            print("unexpected behavior in monster move to closest")
        }
    }
    
    func durationForValue(start: CGFloat,end: CGFloat) -> CGFloat {
        let path = abs(end - start)
        let duration = (path / CGFloat(monster.baseSpeed))
        return duration
    }
}

