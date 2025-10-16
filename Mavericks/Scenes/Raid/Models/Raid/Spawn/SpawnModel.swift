import GameplayKit

enum ResourceType: String{
    case wood, iron, crystals, none
}

// класс отвечает за генерацию монстров
// и появление босса при выработке ресурса
// обновление путей для монстров для этого пути

class SpawnModel: GKEntity {
    
    let id: String
    var field: Field
    
    let names: [String] = ["prototype_monster"]
    
    var spawn: GridCell
    var goal: GridCell
    
    //for update path list
    var monsters: [MonsterModel] = []
    
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
        let monster = MonsterModel(bank: field.textureBank,
                                   spawn: self,
                                   path: pathComponent?.actualPath ?? [], armor: ArmorModel(physic: 10,
                                                     fire: 10,                  chemic: 10))
        monsters.append(monster)
        field.addMonster(monster)
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
        guard !monsters.isEmpty else { return }
        monsters.removeAll{ $0 == monster }
    }

    
    
}
