import GameplayKit
import SpriteKit

class MonsterMoveState: GKState {
    var monster: MonsterModel
    
    init(monster: MonsterModel) {
        self.monster = monster
    }
    
    override func didEnter(from previousState: GKState?) {
        // ✅ УБИРАЕМ РЕКУРСИЮ — запускаем движение ОДИН РАЗ
        moveToNextWaypoint()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        // ✅ ПУСТОЙ — вся логика в SKAction (SpriteKit оптимизирует лучше GK)
    }
    
    private func moveToNextWaypoint() {
        guard let node = monster.node,
              let spawn = monster.spawn else {
            monster.die()
            return
        }
        let field = spawn.field
        node.removeAction(forKey: ActionNames.monsterMove.rawValue)
        node.removeAction(forKey: ActionNames.monsterMoveCompletion.rawValue)
        
        // ✅ КЭШИРУЕМ ПУТЬ И ПОЗИЦИИ — НИКОГДА НЕ ПЕРЕСЧИТЫВАЕМ
        let path = monster.gridPath
        guard !path.isEmpty else {
            monster.stateMachine?.enter(MonsterIdleState.self)
            return
        }
        
        // ✅ КЭШ: вычисляем target один раз
        let targetGridPos = path[0].gridPosition
        let targetScenePos = field.gridPositionToScene(targetGridPos)  // КЭШИРУЕМ!
        
        // ✅ ОДИН вызов обновления клеток
        updateCells(old: monster.lastPathPosition, new: targetGridPos, field: field)
        
        // ✅ Направление по разнице (без 10+ вызовов gridPositionToScene)
        updateVisualDirection(current: node.position, target: targetScenePos)
        
        // ✅ ПРОСТОЕ движение: moveTo с одной duration
        let distance = hypot(targetScenePos.x - node.position.x, targetScenePos.y - node.position.y)
        let duration = distance / CGFloat(monster.currentSpeed)  // Используем currentSpeed!
        
        let moveAction = SKAction.move(to: targetScenePos, duration: duration)
        let completionAction = SKAction.run { [weak self] in
            self?.onMoveComplete(path: path, field: field)
        }
        
        // ✅ Одна последовательность — SpriteKit оптимизирует
        let fullAction = SKAction.sequence([moveAction, completionAction])
        node.run(fullAction, withKey: ActionNames.monsterMove.rawValue)
        
        // ✅ Сохраняем для следующего хода
        monster.lastPathPosition = targetGridPos
        monster.nextPathPosition = path.count > 1 ? path[1].gridPosition : nil
    }
    
    // ✅ ВЫНЕСЕННАЯ логика обновления клеток (используется 1 раз)
    private func updateCells(old: vector_int2?, new: vector_int2, field: Field) {
        // Выход из старой клетки
        if let oldPos = old {
            field.cellInGridPosition(oldPos).updateWithMonster(monster, enterIn: false)
        }
        
        // Вход в новую
        field.cellInGridPosition(new).updateWithMonster(monster, enterIn: true)
    }
    
    // ✅ ВЫНЕСЕННАЯ логика направления (без дублирования)
    private func updateVisualDirection(current: CGPoint, target: CGPoint) {
        let dx = target.x - current.x
        let dy = target.y - current.y
        
        if abs(dx) > abs(dy) {
            monster.visualDirection = dx > 0 ? .east : .west
        } else {
            monster.visualDirection = dy > 0 ? .south : .north
        }
    }
    
    // ✅ Колбэк завершения — НИКАКИХ РЕКУРСИЙ
    private func onMoveComplete(path: [GKGridGraphNode], field: Field) {
        // Удаляем пройденную точку
        if !path.isEmpty {
            monster.gridPath.removeFirst()
        }
        
        // ✅ Проверяем путь и состояние
        if monster.gridPath.isEmpty {
            monster.monsterFinish()  // Дошёл до базы
        } else {
            monster.stateMachine?.enter(MonsterMoveState.self)  // Следующая итерация
        }
    }
}



//class MonsterMoveState: GKState{
//    
//    var monster: MonsterModel
//    
//    init(monster: MonsterModel) {
//        self.monster = monster
//    }
//    
//    override func didEnter(from previousState: GKState?) {
//        moveToClosest()
//    }
//    
//    override func willExit(to nextState: GKState) {
//        
//    }
//    
//    override func update(deltaTime seconds: TimeInterval) {
//        
//    }
//    
//    
//    func moveToClosest(){
//        var fromCenterCell: Bool
//        let path = monster.gridPath
//        
//        guard let node = monster.node else {
//            //clear cells
//            if let oldPosition = monster.lastPathPosition,
//               let old = monster.spawn?.field.cellInGridPosition(oldPosition){
//                old.updateWithMonster(monster, enterIn: false)
//            }
//            if let oldPosition = monster.nextPathPosition,
//               let old = monster.spawn?.field.cellInGridPosition(oldPosition){
//                old.updateWithMonster(monster, enterIn: false)
//            }
//            monster.die() // change state to attack 'block'?
//            return
//        }
//        node.removeAction(forKey: ActionNames.monsterMove.rawValue)
//        guard path.count > 1 else {
//            //change cells state for towers aim component
//            if let oldPosition = monster.lastPathPosition,
//               let old = monster.spawn?.field.cellInGridPosition(oldPosition){
//                old.updateWithMonster(monster, enterIn: false)
//            }
//            if let oldPosition = monster.nextPathPosition,
//               let old = monster.spawn?.field.cellInGridPosition(oldPosition){
//                old.updateWithMonster(monster, enterIn: false)
//            }
//            //new state for monster
//            self.monster.stateMachine?.enter(MonsterDieState.self)
//            return
//        }
//        
//        //check direction and change state if needed
//        let width = node.position.x - SceneHelper.gridPositionToScene(position: path[1].gridPosition).x
//        let height = node.position.y - SceneHelper.gridPositionToScene(position: path[1].gridPosition).y
//        
//        //direction changes
//        if width == 0 {
//            if height > 0 {
//                //move down
//                monster.visualDirection = .south
//            } else if height < 0 {
//                //move up
//                monster.visualDirection = .north
//            } else {
//                //unexpected -idle
//                monster.visualDirection = .south
//            }
//        } else if width > 0{
//            //move left
//            monster.visualDirection = .west
//        } else if width < 0 {
//            //move right
//            monster.visualDirection = .east
//        } else {
//            //unexpected -idle
//            monster.visualDirection = .south
//        }
//        
//        let startPoint = node.position
//        var endPoint: CGPoint = SceneHelper.gridPositionToScene(position: path[0].gridPosition)
//        
//        if endPoint == startPoint{
//            // if there is the new path, and unit not in center of the cell path[0] update cell states,
//            // and move animation is path[0] -> path[1]
//            // flag for change path array after move completion
//            fromCenterCell = true
//            endPoint = SceneHelper.gridPositionToScene(position: path[1].gridPosition)
//            //remove to action
//            //v0.1
//            let old = monster.spawn?.field.cellInGridPosition(path[0].gridPosition)
//            old?.updateWithMonster(monster, enterIn: false)
//            
//            let new = monster.spawn?.field.cellInGridPosition(path[1].gridPosition)
//            new?.updateWithMonster(monster, enterIn: true)
//            
//            monster.lastPathPosition = path[0].gridPosition
//            monster.nextPathPosition = path[1].gridPosition
//        } else {
//            // if there is the new path, and unit not in center of the cell update cell states,
//            // and move animation is curentPosition -> path[0]
//            // do not change path array after move completion
//            fromCenterCell = false
//            //v0.1
//            if let oldPosition = monster.lastPathPosition {
//                let old = monster.spawn?.field.cellInGridPosition(oldPosition)
//                old?.updateWithMonster(monster, enterIn: false)
//            }
//            if let oldPosition = monster.nextPathPosition{
//                let old = monster.spawn?.field.cellInGridPosition(oldPosition)
//                old?.updateWithMonster(monster, enterIn: false)
//            }
//            let new = monster.spawn?.field.cellInGridPosition(path[0].gridPosition)
//            new?.updateWithMonster(monster, enterIn: true)
//            self.monster.lastPathPosition = nil
//            self.monster.nextPathPosition = path[0].gridPosition
//        }
//        //v0.2
////        let cellAction = SKAction.run {
////            if fromCenterCell {
////                let old = self.monster.spawn?.field.cellInGridPosition(path[0].gridPosition)
////                old?.updateWithMonster(self.monster, enterIn: false)
////                
////                let new = self.monster.spawn?.field.cellInGridPosition(path[1].gridPosition)
////                new?.updateWithMonster(self.monster, enterIn: true)
////                
////                self.monster.lastPathPosition = path[0].gridPosition
////                self.monster.nextPathPosition = path[1].gridPosition
////            } else {
////                if let oldPosition = self.monster.lastPathPosition {
////                    let old = self.monster.spawn?.field.cellInGridPosition(oldPosition)
////                    old?.updateWithMonster(self.monster, enterIn: false)
////                }
////                if let oldPosition = self.monster.nextPathPosition{
////                    let old = self.monster.spawn?.field.cellInGridPosition(oldPosition)
////                    old?.updateWithMonster(self.monster, enterIn: false)
////                }
////                let new = self.monster.spawn?.field.cellInGridPosition(path[0].gridPosition)
////                new?.updateWithMonster(self.monster, enterIn: true)
////                self.monster.lastPathPosition = nil
////                self.monster.nextPathPosition = path[0].gridPosition
////            }
////        }
//        
//        //durations
//        let xDuration = durationForValue(start: startPoint.x,
//                                         end: endPoint.x)
//        let yDuration = durationForValue(start: startPoint.y,
//                                         end: endPoint.y)
//        
//        // move Actions
//        let actionX = SKAction.moveTo(x: endPoint.x,
//                                      duration: xDuration)
//        let actionY = SKAction.moveTo(y: endPoint.y,
//                                      duration: yDuration)
//        
//        if abs(width) >= abs(height) {
//            let moveAction = SKAction.sequence([actionY,actionX])
//            let waitAction = SKAction.wait(forDuration: xDuration + yDuration)
//            //v0.2
////            let cellSeq = SKAction.sequence([SKAction.wait(forDuration: yDuration + xDuration / 2),cellAction])
//            let complAction = SKAction.run {
//               
//                guard self.monster.gridPath.count > 0 else {
//                    //change state
//                    self.monster.stateMachine?.enter(MonsterIdleState.self)
//                    return
//                }
//                if fromCenterCell{
//                    self.monster.gridPath.remove(at: 0)
//                }
//                self.monster.stateMachine?.enter(MonsterMoveState.self)
//            }
//            let complSeqAction = SKAction.sequence([waitAction,complAction])
//            
//            node.run(moveAction,withKey: ActionNames.monsterMove.rawValue)
//            //v0.2
////            node.run(cellSeq,withKey: ActionNames.cellsUpdate.rawValue)
//            node.run(complSeqAction,withKey: ActionNames.monsterMoveCompletion.rawValue)
//            
//        } else if abs(width) < abs(height) {
//            let moveAction = SKAction.sequence([actionX,actionY])
//            let waitAction = SKAction.wait(forDuration: xDuration + yDuration)
//            //v0.2
////            let cellSeq = SKAction.sequence([SKAction.wait(forDuration: xDuration + yDuration / 2),cellAction])
//            let complAction = SKAction.run {
//                guard self.monster.gridPath.count > 0 else {
//                    //change state
//                    print("in last check")
//                    self.monster.stateMachine?.enter(MonsterIdleState.self)
//                    return
//                }
//                if fromCenterCell{
//                    self.monster.gridPath.remove(at: 0)
//                }
//                self.monster.stateMachine?.enter(MonsterMoveState.self)
//            }
//            let complSeqAction = SKAction.sequence([waitAction,complAction])
//            
//            node.run(moveAction,withKey: ActionNames.monsterMove.rawValue)
//            //v0.2
////            node.run(cellSeq,withKey: ActionNames.cellsUpdate.rawValue)
//            node.run(complSeqAction,withKey: ActionNames.monsterMoveCompletion.rawValue)
//        } else {
//            //width == height, unexpected behavior
//            print("unexpected behavior in monster move to closest")
//        }
//    }
////    func moveToEdge(){
////        var fromCenterCell: Bool
////        let path = monster.gridPath
////        
////        guard let node = monster.node else {
////            //clear cells
////            if let oldPosition = monster.lastPathPosition,
////               let old = monster.spawn?.field.cellInGridPosition(oldPosition){
////                old.updateWithMonster(monster, enterIn: false)
////            }
////            if let oldPosition = monster.nextPathPosition,
////               let old = monster.spawn?.field.cellInGridPosition(oldPosition){
////                old.updateWithMonster(monster, enterIn: false)
////            }
////            monster.die() // change state to attack 'block'?
////            return
////        }
////        node.removeAction(forKey: ActionNames.monsterMove.rawValue)
////        guard path.count > 1 else {
////            //change cells state for towers aim component
////            if let oldPosition = monster.lastPathPosition,
////               let old = monster.spawn?.field.cellInGridPosition(oldPosition){
////                old.updateWithMonster(monster, enterIn: false)
////            }
////            if let oldPosition = monster.nextPathPosition,
////               let old = monster.spawn?.field.cellInGridPosition(oldPosition){
////                old.updateWithMonster(monster, enterIn: false)
////            }
////            //new state for monster
////            self.monster.stateMachine?.enter(MonsterIdleState.self)
////            return
////        }
////        
////        //check direction and change state if needed
////        let width = node.position.x - SceneHelper.gridPositionToScene(position: path[1].gridPosition).x
////        
////        let height = node.position.y - SceneHelper.gridPositionToScene(position: path[1].gridPosition).y
////        
////        //direction changes
////        if width == 0 {
////            if height > 0 {
////                //move down
////                monster.visualDirection = .south
////            } else if height < 0 {
////                //move up
////                monster.visualDirection = .north
////            } else {
////                //unexpected -idle
////                monster.visualDirection = .south
////            }
////        } else if width > 0{
////            //move left
////            monster.visualDirection = .west
////        } else if width < 0 {
////            //move right
////            monster.visualDirection = .east
////        } else {
////            //unexpected -idle
////            monster.visualDirection = .south
////        }
////        
////        let startPoint = node.position
////        let startCell = monster.spawn?.field.cellInGridPosition(<#T##position: vector_int2##vector_int2#>)
////        var endPoint: CGPoint = SceneHelper.gridPositionToScene(position: path[0].gridPosition)
////        //find cell finish position
////        //find duration
////        //move to finish
////        //
////    }
//    //move to edge
//    //move to new cell start
//    //last cell state change
//    //move to next edge
//    
//    //start position
//    //end position
//    
//    
//    
//    
//    func durationForValue(start: CGFloat,end: CGFloat) -> CGFloat {
//        let path = abs(end - start)
//        let duration = (path / CGFloat(monster.baseSpeed))
//        return duration
//    }
//}

