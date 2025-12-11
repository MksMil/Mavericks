import GameplayKit
import SpriteKit

class MonsterMoveState: GKState {
    var monster: MonsterModel
    
    init(monster: MonsterModel) {
        self.monster = monster
    }
    
    override func didEnter(from previousState: GKState?) {
        moveToNextWaypoint()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
    }
    
    private func moveToNextWaypoint() {
        guard let spawn = monster.spawn else {
            monster.die()
            return
        }
        let node = monster.node
        let field = spawn.field
        node.removeAction(forKey: ActionNames.monsterMove.rawValue)
        node.removeAction(forKey: ActionNames.monsterMoveCompletion.rawValue)
        
        guard !monster.gridPath.isEmpty else {
            monster.stateMachine?.enter(MonsterIdleState.self)
            return
        }
        
        let targetGridPos = monster.gridPath[0].gridPosition
        let targetScenePos = field.gridPositionToScene(targetGridPos)
                
        guard updateCells(old: monster.lastPathPosition, new: targetGridPos, field: field)  else {
            return
        }

        updateVisualDirection(current: node.position, target: targetScenePos)
        
        let distance = hypot(targetScenePos.x - node.position.x, targetScenePos.y - node.position.y)
        let duration = distance / CGFloat(monster.currentSpeed)
        
        let moveAction = SKAction.move(to: targetScenePos, duration: duration)
        let completionAction = SKAction.run { [weak self] in
            self?.onMoveComplete()
        }
        
        let fullAction = SKAction.sequence([moveAction, completionAction])
        node.run(fullAction, withKey: ActionNames.monsterMove.rawValue)
    
        monster.lastPathPosition = targetGridPos
        monster.nextPathPosition = monster.gridPath.count > 1 ? monster.gridPath[1].gridPosition : nil
    }
    
    private func updateCells(old: vector_int2?, new: vector_int2, field: Field) -> Bool {
        let cell = field.cellInGridPosition(new)
        if cell.hasMonsters, !cell.containMonster(monster) {
            monster.stateMachine?.enter(MonsterIdleState.self)
            cell.queueMonster(monster)
            return false
        }
        if let oldPos = old {
            field.cellInGridPosition(oldPos).updateWithMonster(monster, enterIn: false)
        }
        field.cellInGridPosition(new).updateWithMonster(monster, enterIn: true)
        return true
    }
    
    private func updateVisualDirection(current: CGPoint, target: CGPoint) {
        let dx = target.x - current.x
        let dy = target.y - current.y
        if abs(dx) > abs(dy) {
            monster.visualDirection = dx > 0 ? .east : .west
        } else {
            monster.visualDirection = dy < 0 ? .south : .north
        }
    }
    
    private func onMoveComplete() {
        if !monster.gridPath.isEmpty {
            monster.gridPath.removeFirst()
        }
        if monster.gridPath.isEmpty {
            monster.monsterFinish()
        } else {
            monster.stateMachine?.enter(MonsterMoveState.self)
        }
    }
}
