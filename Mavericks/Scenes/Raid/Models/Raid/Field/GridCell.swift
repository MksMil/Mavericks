// Структура ячейки
import GameplayKit

enum GridCellState {
    case empty, enemiesIn
}

class GridCell: GKEntity {
    let parent: Field
    let gridPosition: vector_int2
    var scenePosition: CGPoint {
        let cellSize = 100.0
        let sceneX = CGFloat(gridPosition.x) * cellSize + cellSize / 2
        let sceneY = CGFloat(gridPosition.y) * cellSize + cellSize / 2
        return CGPoint(x: sceneX, y: sceneY)
    }
    var type: GridCellType
    
    var node: SKSpriteNode?
    var neighbors: [GKGraphNode] = []
    
    var monsters: [MonsterModel] = []
    var block: BlockModel?
    var state: GridCellState = .empty
    
    init(parent: Field,
        position: vector_int2,
         type: GridCellType,
         node: SKSpriteNode? = nil) {
        self.parent = parent
        self.gridPosition = position
        self.type = type
        self.node = node
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// MARK: - Block
extension GridCell{
    func addBlock(){
        type = .block
        block = BlockModel()
        guard let bank = parent.textureBank else { return }
        let sprite = SKSpriteNode(texture: bank.blockTextures[0])
        block?.node = sprite
        node?.addChild(sprite)
    }
    func removeBlock(){
        type = .road
        block?.node?.removeFromParent()
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

