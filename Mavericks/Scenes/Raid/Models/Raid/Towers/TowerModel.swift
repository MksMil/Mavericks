import GameplayKit
import SpriteKit

enum TargetPredicate {
    case first, high, low, none
}

enum DamageType: String{
    case physic, fire, chemical
}

class TowerModel: GKEntity{
    
    let id: String
    weak var node: BaseTowerNode? 
    
    let field: Field
    let cell: GridCell
    
    var type: TowerType
    
    var dmgType: DamageType{
        switch type {
            case .arrow:
                    .physic
            case .poison:
                    .chemical
            case .frost:
                    .chemical
            case .electro:
                    .fire
            case .fire:
                    .fire
            case .stun:
                    .physic
        }
    }
    
    var stateMacine: GKStateMachine?
    
    var cost: Int = 1

    var attack: DamageModel
    var fireRate: CGFloat = 1
    var fireRadius: CGFloat = 4
    
    var effectDuration: CGFloat = 1
    var level: Int = 1
    
//    var targetCells: [GridCell] = []
    var targets: [MonsterModel] = []
    var targetPredicate: TargetPredicate = .first
    
    
    // ✅ КЭШ targetCells — пересчитываем ТОЛЬКО при level up или радиусе
        private var cachedTargetCells: [GridCell] = []
        func detectTargetCells() {
            cachedTargetCells.removeAll()
            
            // ✅ ЛОКАЛЬНЫЙ поиск: только радиус 4 клетки (81 клетка max)
            let centerX = Int(cell.gridPosition.x)
            let centerY = Int(cell.gridPosition.y)
            
            for dx in -Int(fireRadius)...Int(fireRadius) {
                for dy in -Int(fireRadius)...Int(fireRadius) {
                    let targetX = centerX + dx
                    let targetY = centerY + dy
                    
                    guard targetX >= 0 && targetX < field.gridWidth &&
                          targetY >= 0 && targetY < field.gridHeight else { continue }
                    
                    if abs(dx) + abs(dy) <= Int(fireRadius) {  // Манхэттен
                        cachedTargetCells.append(field.grid[targetX][targetY])
                    }
                }
            }
        }
        
        // ✅ Быстрый доступ
        var targetCells: [GridCell] { cachedTargetCells }
    
    
    // MARK: init
    init(type: TowerType,field: Field,cell: GridCell) {
        self.id = UUID().uuidString
        self.type = type
        self.field = field
        self.cell = cell
        self.attack = DamageModel(physic: 20,
                                  fire: 0,
                                  chemic: 0)
        super.init()        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit{
        print("tower model deinited")
    }
    
    func setupStateMachine(){
        let idleState = TowerIdleState(tower: self)
        let aimState = TowerAimState(tower: self)
        let shootState = TowerShootState(tower: self)
        let upgradeState = TowerUpgradeState(tower: self)
        let sellState = TowerSellState(tower: self)
        
        stateMacine = GKStateMachine(states: [
            idleState, aimState, shootState, upgradeState,sellState
        ])
        stateMacine?.enter(TowerIdleState.self)
    }
    func changeState(){}
    
 
    //detect cells available for targeting enemies
//    func detectTargetCells(){
//        //targetCells = ...
//        field.grid.forEach { row in
//            row.forEach { targetCell in
//                if CGFloat(abs(cell.gridPosition.x - targetCell.gridPosition.x) + abs(cell.gridPosition.y - targetCell.gridPosition.y)) <= fireRadius{
//                    self.targetCells.append(targetCell)
//                }
//            }
//        }
//        testShooting()
////        print(targetCells.count)
//    }
    func testShooting(){
        updateTargets()
        //TODO: change to action to able to pause
        node?.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: fireRate),SKAction.run { [weak self] in
            guard let self else {
                return
            }
            self.updateTargets()
            
        }])))
//        DispatchQueue.main.asyncAfter(deadline: .now() + Double(fireRate)){
//            self.testShooting()
//        }
    }
    
    
}
// MARK: - Aim logic
extension TowerModel {
    func updateTargets(){
        targets = []
        targetCells.forEach { cell in
            targets += cell.monsters
        }
        targets.sort { m1, m2 in
            m1.health < m2.health
        }
        //can shoot in targets.first
        shootOnTarget()
    }
}


// MARK: - Shooting
//TODO: shooting animation duration, more precision shoot
extension TowerModel {
    
    func shootOnTarget(){
        if !targets.isEmpty,
           let target = targets.first,
           let node = node?.parent, // tower cell's node
           let targetPosition = target.node?.position{
            //TODO: Independent object
            let bullet = SKSpriteNode(color: NSColor.red,
                                      size: CGSize(width: 10,
                                                   height: 10))
//            print("target position: \(targetPosition)")
//            print("tower position: \(node.position)")
            if let scene = node.parent {
                scene.addChild(bullet)
            }
            
            bullet.position = node.position
            bullet.zPosition = 100
            bullet.run(SKAction.move(to: targetPosition,
                                     duration: 1)){
                bullet.removeFromParent()
                target.takeDamage(self.attack,from: self)
            }
        }
    }
}

// MARK: - Informable
extension TowerModel: Informable {
    
}
