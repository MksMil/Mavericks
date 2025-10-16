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
            case .freeze:
                    .chemical
            case .electric:
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
    
    var targetCells: [GridCell] = []
    var targets: [MonsterModel] = []
    var targetPredicate: TargetPredicate = .first
    
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
        self.detectTargetCells()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    func detectTargetCells(){
        //targetCells = ...
        field.grid.forEach { row in
            row.forEach { targetCell in
                if CGFloat(abs(cell.gridPosition.x - targetCell.gridPosition.x) + abs(cell.gridPosition.y - targetCell.gridPosition.y)) <= fireRadius{
                    self.targetCells.append(targetCell)
                }
            }
        }
        testShooting()
        print(targetCells.count)
    }
    func testShooting(){
        updateTargets()
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(fireRate)){
            self.testShooting()
        }
    }
    
    
}
// MARK: - Aim logic
extension TowerModel {
    func updateTargets(){
        targets = []
        targetCells.forEach { cell in
            targets += cell.monsters
        }
//        print("updated targets: \(targets.count)")
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
           let node,
           let targetPosition = target.node?.position{
            let bullet = SKSpriteNode(color: NSColor.red, size: CGSize(width: 10,
                                                                       height: 10))
            if let scene = node.parent {
                scene.addChild(bullet)
            }
            
            bullet.position = node.position
            bullet.run(SKAction.move(to: targetPosition, duration: 1)){
                bullet.removeFromParent()
                target.takeDamage(self.attack,from: self)
            }
        }
    }
}
