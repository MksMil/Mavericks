import GameplayKit
//{
//states
//
//specials
//physics
//collisions
//
//move component
//visual component
//health component
//
//states
//
//poisoned
//freezed
//shocked
//ignited
//bleeding
//
//attack
//attacked
//}

protocol Damageable {
    var currentHealth: Int { get }
    var maxHealth: Int { get }
    
    func applyDamage(_ damage: DamageModel)
//    func heal(_ amount: Int)
}

// TODO: rework movement
class MonsterModel: GKEntity {

    var node: BaseRaidNode
    
    var visualDirection: UnitDirection = .south{
        didSet{
            update(deltaTime: 0) //update components
            //or make direct componenet to visual
        }
    } //face to cam
    
    let id: String //?
    let bank: RaidDataSource //texture atlas name
    
    weak var spawn: SpawnModel? //?
    var gridPath: [GKGridGraphNode]
    var lastPathPosition: vector_int2?
    var nextPathPosition: vector_int2?
    
    var currentCell: GridCell? //for movement rework - change speed and dmg if trap exists
    
    var maxHealth: Int
    var currentHealth: Int
    var baseSpeed: Int
    var currentSpeed: Int
    
    var attack: Int
    
    var baseArmor: ArmorModel
    var equippedArmor: ArmorModel
        
    
    var stateMachine: GKStateMachine?
    
    //flags for states
    var isPoisoned: Bool = false
    var isShocked: Bool = false
    var isFreezed: Bool = false
    var isIgnite: Bool = false
    var isStunned: Bool = false

    var healthBar: HealthBarNode?
    // MARK: init
    // TODO: inputdelegate?
    init(id: String = UUID().uuidString,
         bank: RaidDataSource,
         spawn: SpawnModel,
         path: [GKGridGraphNode],
         health: Int = 100,
         armor: ArmorModel,
         attack: Int = 1,
         baseSpeed: Int = 25){
        self.id = id
        self.bank = bank
        self.spawn = spawn
        self.gridPath = path
        self.maxHealth = health
        self.currentHealth = health
        self.baseArmor = ArmorModel.Base
        self.equippedArmor = armor
        self.attack = attack
        self.baseSpeed = baseSpeed
        self.currentSpeed = baseSpeed
        self.node = BaseRaidNode(type: BaseRaidNodeType.monster,
                                 inputDelegate: spawn.field,
                                 color: NSColor.cyan,
                                 size: CGSize(width: 64, height: 64))
        super.init()
        self.spawn?.field.interactiveNode.addChild(node)
        self.node.isHidden = true
        self.node.zPosition = 2
    
        self.node.infoSource = self
        self.healthBar = HealthBarNode(source: self,
                                       size: CGSize(width: node.size.width,
                                                    height: 8))
        if let healthBar {
            healthBar.position = CGPoint(x: -node.size.width / 2,
                                         y: node.size.height / 2 + healthBar.size.height)
            node.addChild(healthBar)
        }
        setupStateMachine()
        //components
//        let visualComponent = MonsterVisualComponent(unit: self)
//        self.addComponent(visualComponent)
    }
    required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
    deinit{
//        print("monster model deinit")
    }
    
    func setupStateMachine(){
        let idleState = MonsterIdleState(monster: self)
        let moveState = MonsterMoveState(monster: self)

        let attackState = MonsterAttackState(monster: self)
        
        let attackedState = MonsterAttackedState(monster: self)
        
        let dieState = MonsterDieState(unit: self)

        stateMachine = GKStateMachine(states: [
            idleState,moveState,attackState,
            dieState, attackedState
        ])
        stateMachine?.enter(MonsterIdleState.self)
    }
    //new path update
    func updateWith(_ pathFor: @escaping (CGPoint)->[GKGridGraphNode] ){
        let position = node.position
        gridPath = pathFor(position)
        //if monster was blocked
        if stateMachine?.currentState is MonsterIdleState{
            stateMachine?.enter(MonsterMoveState.self)
        }
    }
   
    func start(){
        node.isHidden = false
        stateMachine?.enter(MonsterMoveState.self)
    }
    
    func configureWithSpawn(_ spawn: SpawnModel,
                            andData monsterData: Data? = nil){
        self.spawn = spawn
        gridPath = spawn.pathComponent?.actualPath ?? []
        lastPathPosition = nil
        nextPathPosition = nil
        currentCell = nil
        maxHealth = 100 //from data object
        currentHealth = maxHealth
        baseSpeed = 25 // from dto
        currentSpeed = baseSpeed
        attack = 1 // from dto
        baseArmor = ArmorModel.Base
        equippedArmor = ArmorModel.Base
  
//        //flags for states
        isPoisoned = false
        isShocked  = false
        isFreezed  = false
        isIgnite   = false
        isStunned  = false
        
        node.position = spawn.spawn.scenePosition
        
        healthBar?.changeHealth()
    }
// TODO: Rework for different situations -> different animations for die, finish or thmthng else...
    func die(){
        stateMachine?.enter(MonsterDieState.self)
        node.isHidden = true
    }
    //TODO: monster finished path at base! base health remove or smth
    func monsterFinish(){
        stateMachine?.enter(MonsterDieState.self)
//        spawn?.removeMonster(self)
        //field - base - reduce base health
        node.isHidden = true
        spawn?.field.monsterFinish()
    }
}

// MARK: - Damageable
extension MonsterModel: Damageable{
    
    func applyDamage(_ damage: DamageModel){
        guard currentHealth > 0 else { return }
        let dmg = self.baseArmor.reducedDamage(damage, withEquippedArmor: equippedArmor).full
        currentHealth -= Int(dmg)
        if currentHealth <= 0 {
            if let oldPosition = lastPathPosition ,
               let old = spawn?.field.cellInGridPosition(oldPosition){
                old.updateWithMonster(self, enterIn: false)
            }
            if let oldPosition = nextPathPosition,
               let old = spawn?.field.cellInGridPosition(oldPosition){
                old.updateWithMonster(self, enterIn: false)
            }
            
//            print("monster: \(id) die")
            die()
        } else {
            healthBar?.changeHealth()
//            print("monster receive \(Int(dmg)) damage")
        }
    }
}

// MARK: - Informable
extension MonsterModel: Informable{
    
}
