import GameplayKit

enum ResourceType: String{
    case wood, iron, crystals, none
}

protocol SpawnHolderProtocol{
    
}

class SpawnModel: GKEntity {
    
    let id: String
    var field: Field
    let pool: MonsterPool
    
    let names: [String] = ["prototype_monster"]
    
    var spawn: GridCell
    var goal: GridCell
    
    //for update path list
    var monsters: Set<MonsterModel> = Set()// {
//        didSet{
//            print("monsters count changed: \(monsters.count)")
//        }
//    }
    
    var resourceType: ResourceType = .none
    var resoucesQuantity: Int
    
    weak var pathComponent: FieldPathComponent?
    
    
    // MARK: Init
    init(field: Field,
         spawn: GridCell,
         goal:GridCell,
         resourceType: ResourceType,
         resoucesQuantity: Int = 100) {
        self.id = UUID().uuidString
        self.field = field
        self.pool = field.monsterPool
        self.spawn = spawn
        self.goal = goal
        self.resourceType = resourceType
        self.resoucesQuantity = resoucesQuantity
        
        super.init()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // TODO: waves mechanizmus
    
    func startSpawnMonsters(){
        let monster = pool.spawn(in: self)
        monster.configureWithSpawn(self)
        monsters.insert(monster)
        monster.start()
//        field.addMonster(monster)
    }
    
    func stopSpawnMonsters(){}

    func updateMonstersPaths(with helper: @escaping (CGPoint) -> [GKGridGraphNode]) {
        Task{
            await withTaskGroup { group in
                monsters.forEach { monster in
                    group.addTask {
                        monster.updateWith(helper)
                    }
                }
            }
        }
    }
    
    //removes monster from updateList
    func removeMonster(_ monster: MonsterModel){
        pool.recycle(monster)
        monsters.remove(monster)
    }

    
    
}
