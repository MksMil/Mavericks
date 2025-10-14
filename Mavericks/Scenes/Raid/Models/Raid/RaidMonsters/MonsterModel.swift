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
    let spawn: SpawnModel
    
    var bank: TextureBank //texture atlas name
    
    var health: Int
    var baseSpeed: Int
    var currentSpeed: Int
    var armor: Int
    var attack: Int
        
    var gridPath: [GKGridGraphNode]
    var lastPathPosition: vector_int2?
    var nextPathPosition: vector_int2?
    var stateMachine: GKStateMachine?

    // MARK: init
    init(id: String = UUID().uuidString,
         bank: TextureBank,
         spawn: SpawnModel,
         path: [GKGridGraphNode],
         health: Int = 100,
         armor: Int = 1,
         attack: Int = 1,
         baseSpeed: Int = 25){
        self.id = id
        self.bank = bank
        self.spawn = spawn
        self.gridPath = path
        self.health = health
        self.armor = armor
        self.attack = attack
        self.baseSpeed = baseSpeed
        self.currentSpeed = baseSpeed
        super.init()
        setupStateMachine()
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
        
        let poisonedState = MonsterPoisonedState(monster: self)
        let freezedState = MonsterFreezedState(monster: self)
        let igniteState = MonsterIgniteState(monster: self)
        let shockedState = MonsterShockedState(monster: self)
        let stunnedState = MonsterStunnedState(monster: self)
        
        let dieState = MonsterDieState(monster: self)

        stateMachine = GKStateMachine(states: [
            idleState,moveState,attackState,
            poisonedState,freezedState,igniteState,
            shockedState,stunnedState,
            dieState, attackedState
        ])
        stateMachine?.enter(MonsterIdleState.self)
    }
    
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
            stop()
            return
        }
        stateMachine?.enter(MonsterMoveState.self)
    }
// TODO: Rework for different situations -> different animations for die, finish or thmthng else...
    func stop(){
        guard let node else { return }
        node.removeAllActions()
        node.removeFromParent()
        spawn.removeMonster(self)
    }
}

// MARK: - Damage
extension MonsterModel{
    func takeDamage(_ damage: Int, ofType type: TowerType){
        switch type {
            case .arrow:
                print("arrow shot")
            case .poison:
                print("poison shot")
            case .freeze:
                print("freeze shot")
            case .electric:
                print("electric shot")
            case .fire:
                print("fire shot")
           @unknown default:
                break
        }
        health -= damage
        if health <= 0 {
            print("monster die")
        } else {
            
        }
    }
}


