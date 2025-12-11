// Структура ячейки
import GameplayKit

enum GridCellState {
    case empty, enemiesIn
}


class GridCell: GKEntity {
//    let parent: Field
    let gridPosition: vector_int2
    private lazy var _scenePosition: CGPoint = {
        let sceneX = CGFloat(gridPosition.x) * cellSize + cellSize / 2
        let sceneY = CGFloat(gridPosition.y) * cellSize + cellSize / 2
        return CGPoint(x: sceneX, y: sceneY)
    }()
    
    var scenePosition: CGPoint { _scenePosition }
    
    var fieldMapCellType: MapCellType
    var content: MapCellContent
    var cellSize: CGFloat
    var node: BaseRaidNode?
    var neighbors: [CustomGridNode] = []
    
    var monsters: Set<MonsterModel> = Set()
    var spawn: SpawnModel?
    var block: BlockModel?
    var tower: TowerModel?
    var trap: TrapModel?

    private var monstersQueue: [MonsterModel] = []
    
    var hasMonsters: Bool {
        return monsters.count > 0
    }
    
    var state: GridCellState = .empty 
    
    init(position: vector_int2,
         mapCell: MapCell,
         cellSize: CGFloat,
         node: BaseRaidNode? = nil) {
//        self.parent = parent
        self.gridPosition = position
        self.fieldMapCellType = mapCell.mapCellType
        self.content = mapCell.mapCellContent
        self.cellSize = cellSize
        self.node = node
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - monster towers
extension GridCell {

    func clearMonsters(){
        monsters.removeAll()
    }
    
    func containMonster(_ monster: MonsterModel) -> Bool {
        return monsters.contains(monster)
    }
    
    func queueMonster(_ monster: MonsterModel){
        monstersQueue.append(monster)
    }
    
    func unqueueMonster()->MonsterModel?{
        monstersQueue.popLast()
    }
    
    func updateWithMonster(_ monster: MonsterModel,
                           enterIn: Bool){
        if enterIn {
            if monsters.isEmpty{
                monsters.insert(monster)
                state = .enemiesIn
            } else {
                print("unexpected error in enter the cell: monsters set !isEmpty")
            }
        } else {
            monsters.remove(monster)
            if monsters.isEmpty {
                state = .empty
                if let nextMonster = unqueueMonster(){
                    nextMonster.stateMachine?.enter(MonsterMoveState.self)
                }
            }
        }
    }
}

