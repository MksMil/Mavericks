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
    var neighbors: [GKGraphNode] = []
    
    var monsters: [MonsterModel] = []
    var spawn: SpawnModel?
    var block: BlockModel?
    var tower: TowerModel?
    var trap: TrapModel?
//    var state: GridCellState = .empty
    
    // ✅ СВЯЗЬ С MONSTERMODEL: индекс в пуле (O(1) удаление)
    private var monsterCount: Int = 0  // Количество монстров (быстрее append/removeAll)
    private var activeMonsters: Set<ObjectIdentifier> = []  // O(1) проверка/удаление
    
    var hasMonsters: Bool {
        return monsterCount > 0
    }
    
    var state: GridCellState = .empty {
        didSet {
            // ✅ Только визуал (если нужно)
            // node?.color = state == .empty ? .gray : .orange
        }
    }
    
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
    func updateWithMonster(_ monster: MonsterModel,
                           enterIn: Bool) {
            let id = ObjectIdentifier(monster)
            
            if enterIn {
                // ✅ O(1) добавление
                if !activeMonsters.contains(id) {
                    activeMonsters.insert(id)
                    monsterCount += 1
                    state = .enemiesIn
                }
            } else {
                // ✅ O(1) удаление
                if activeMonsters.remove(id) != nil {
                    monsterCount -= 1
                    if monsterCount == 0 {
                        state = .empty
                    }
                }
            }
        }
        
        // ✅ Быстрый доступ для башен (O(1))
        func getMonsters() -> [MonsterModel] {
            // Возвращаем только если нужно (редко)
            return monsters.filter { activeMonsters.contains(ObjectIdentifier($0)) }
        }
        
        func clearMonsters() {
            activeMonsters.removeAll()
            monsterCount = 0
            state = .empty
        }
//    func clearMonsters(){
//        monsters.removeAll()
//    }
//    
//    func updateWithMonster(_ monster: MonsterModel,
//                           enterIn: Bool){
//        if enterIn {
//            monsters.append(monster)
//            state = .enemiesIn
//        } else {
//            if !monsters.isEmpty, monsters.contains(where: {$0 == monster}){
//                monsters.removeAll { existing in
//                    existing == monster
//                }
//            }
//            if monsters.isEmpty {
//                state = .empty
//            }
//        }
////        if state == .empty {
////            node?.color = .gray
////        } else {
////            node?.color = .orange
////        }
//    }
}

