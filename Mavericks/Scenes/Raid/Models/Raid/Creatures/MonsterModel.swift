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
class MonsterModel: GKEntity {

    weak var node: BaseMonsterNode?
    var visualDirection: UnitDirection = .south{
        didSet{
            update(deltaTime: 0) //update components
            //or make direct componenet to visual
        }
    } //face to cam
    
    let id: String
    weak var spawn: SpawnModel?
    
    var bank: TextureBank //texture atlas name
    
    var health: Int
    //regeneration?
    
    var baseSpeed: Int
    var currentSpeed: Int
    
    var attack: Int
    
    var baseArmor: ArmorModel
    var equipperdArmor: ArmorModel
        
    var gridPath: [GKGridGraphNode]
    var lastPathPosition: vector_int2?
    var nextPathPosition: vector_int2?
    
    var stateMachine: GKStateMachine?
    
    //flags for states
    var isPoisoned: Bool = false
    var isShocked: Bool = false
    var isFreezed: Bool = false
    var isIgnite: Bool = false
    var isStunned: Bool = false

    // MARK: init
    init(id: String = UUID().uuidString,
         bank: TextureBank,
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
        self.health = health
        self.baseArmor = ArmorModel.Base
        self.equipperdArmor = armor
        self.attack = attack
        self.baseSpeed = baseSpeed
        self.currentSpeed = baseSpeed
        super.init()
        setupStateMachine()
        //components
        let visualComponent = MonsterVisualComponent(unit: self)
        self.addComponent(visualComponent)
    }
    required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
    deinit{
        print("monster deinit")
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
        if let node {
            let position = node.position
            node.removeAction(forKey: ActionNames.monsterMoveCompletion.rawValue)
            gridPath = pathFor(position)
            stateMachine?.enter(MonsterMoveState.self)
        }
    }
   
    func start(){
        guard node != nil else {
            die()
            return
        }
        stateMachine?.enter(MonsterMoveState.self)
    }
// TODO: Rework for different situations -> different animations for die, finish or thmthng else...
    func die(){
        stateMachine?.enter(MonsterDieState.self)
    }
}

// MARK: - Damage
extension MonsterModel{
    func takeDamage(_ damage: DamageModel,from tower: TowerModel){
        guard health > 0 else { return }
        let dmg = self.baseArmor.reducedDamage(damage, withEquippedArmor: equipperdArmor).full
        health -= Int(dmg)
        if health <= 0 {
            if let oldPosition = lastPathPosition ,
               let old = spawn?.field.cellInGridPosition(oldPosition){
                old.updateWithMonster(self, enterIn: false)
            }
            if let oldPosition = nextPathPosition,
               let old = spawn?.field.cellInGridPosition(oldPosition){
                old.updateWithMonster(self, enterIn: false)
            }
            tower.targets.removeAll { monster in
                monster == self
            }
            print("monster: \(id) die")
            die()
        } else {
            print("monster receive \(Int(dmg)) damage")
        }
    }
}


