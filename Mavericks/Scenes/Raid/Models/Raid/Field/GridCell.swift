// Структура ячейки
import GameplayKit

enum GridCellState {
    case empty, enemiesIn
}

class GridCell: GKEntity {
    let parent: Field
    let gridPosition: vector_int2
    var scenePosition: CGPoint {
        let sceneX = CGFloat(gridPosition.x) * cellSize + cellSize / 2
        let sceneY = CGFloat(gridPosition.y) * cellSize + cellSize / 2
        return CGPoint(x: sceneX, y: sceneY)
    }
    var type: GridCellType
    var cellSize: CGFloat
    var node: BaseRaidNode?
    var neighbors: [GKGraphNode] = []
    
    var monsters: [MonsterModel] = []
    var block: BlockModel?
    var tower: TowerModel?
    var state: GridCellState = .empty
    
    init(parent: Field,
        position: vector_int2,
         type: GridCellType,
         cellSize: CGFloat,
         node: BaseRaidNode? = nil) {
        self.parent = parent
        self.gridPosition = position
        self.type = type
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
    
    func updateWithMonster(_ monster: MonsterModel,
                           enterIn: Bool){
        if enterIn {
            monsters.append(monster)
            state = .enemiesIn
        } else {
            if !monsters.isEmpty, monsters.contains(where: {$0 == monster}){
                monsters.removeAll { existing in
                    existing == monster
                }
            }
            if monsters.isEmpty {
                state = .empty
            }
        }
        if state == .empty {
            node?.color = .gray
        } else {
            node?.color = .orange
        }
    }
}

