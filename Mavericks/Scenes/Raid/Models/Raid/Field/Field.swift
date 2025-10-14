import SpriteKit
import GameplayKit

class Field: GKEntity {
    weak var scene: RaidScene?
    
    var pathGraph: GKGridGraph<GKGridGraphNode> = GKGridGraph()
    
    let pathComponentSystem: GKComponentSystem<FieldPathComponent> = .init(componentClass: FieldPathComponent.self)
    
    var grid: [[GridCell]] = []
    
    var monsterSpawns: [SpawnModel] = [] //str
    var monsters: [MonsterModel] = []
    var towers: [TowerModel] = []
    
    let cellSize: CGFloat = 100.0
    
    private let gridWidth = 30
    private let gridHeight = 30
    
    //texture bank
    let textureBank = TextureBank(name: "prototype_monster", size: 18)
    
    func generateField() {
        setupGrid()
    }
    
    func addNewZone(){
        //add new game zone to scene
    }
    
    
}
// MARK: - Componenets
extension  Field {
    //MARK: Find Path Component
    //use it in setup grid, when creating monster spawns
    func addFindPathComponent(to spawn: SpawnModel) {
        let component = FieldPathComponent(cellSize: cellSize, spawn: spawn)
        spawn.pathComponent = component
        pathComponentSystem.addComponent(component)
    }
    func updatePaths(){
        pathComponentSystem.update(deltaTime: 0)
    }
    
    
}

// MARK: - Graph
extension Field {
    private func setupGrid() {
        // graph init
        pathGraph = GKGridGraph(fromGridStartingAt: vector_int2(0, 0),
                                width: Int32(gridWidth),
                                height: Int32(gridHeight),
                                diagonalsAllowed: false)
        
        // all cells creation
        grid = (0..<gridHeight).map { y in
            (0..<gridWidth).map { x in
                GridCell(position: vector_int2(Int32(x), Int32(y)),
                         type: .field,
                         node: nil)
            }
        }
        
        // road 1: spawn (28, 15) to base (2, 2),  3 cell width (y=14,15,16)
                let road1 = [
                    // Горизонтальная часть от (28, 15) до (20, 15)
                    (28, 14), (28, 15), (28, 16), (27, 14), (27, 15), (27, 16), (26, 14), (26, 15), (26, 16),
                    (25, 14), (25, 15), (25, 16), (24, 14), (24, 15), (24, 16), (23, 14), (23, 15), (23, 16),
                    (22, 14), (22, 15), (22, 16), (21, 14), (21, 15), (21, 16), (20, 14), (20, 15), (20, 16),
                    // Поворот вниз к y=12
                    (20, 13), (20, 12), (20, 11), (19, 13), (19, 12), (19, 11), (18, 13), (18, 12), (18, 11),
                    // Горизонтальная часть до x=10
                    (17, 13), (17, 12), (17, 11), (16, 13), (16, 12), (16, 11), (15, 13), (15, 12), (15, 11),
                    (14, 13), (14, 12), (14, 11), (13, 13), (13, 12), (13, 11), (12, 13), (12, 12), (12, 11),
                    (11, 13), (11, 12), (11, 11), (10, 13), (10, 12), (10, 11),
                    // Поворот вниз к y=8
                    (10, 10), (10, 9), (10, 8), (9, 10), (9, 9), (9, 8), (8, 10), (8, 9), (8, 8),
                    // Горизонтальная часть до x=4
                    (7, 10), (7, 9), (7, 8), (6, 10), (6, 9), (6, 8), (5, 10), (5, 9), (5, 8), (4, 10), (4, 9), (4, 8),
                    // Поворот вниз к базе (2, 2)
                    (4, 7), (4, 6), (4, 5), (3, 7), (3, 6), (3, 5), (2, 7), (2, 6), (2, 5), (2, 4), (2, 3), (2, 2)
                ]
                
                // road 2: spawn (28, 25) to base (2, 2), 3 cells width (y=24,25,26)
                let road2 = [
                    // Горизонтальная часть от (28, 25) до (20, 25)
                    (28, 24), (28, 25), (28, 26), (27, 24), (27, 25), (27, 26), (26, 24), (26, 25), (26, 26),
                    (25, 24), (25, 25), (25, 26), (24, 24), (24, 25), (24, 26), (23, 24), (23, 25), (23, 26),
                    (22, 24), (22, 25), (22, 26), (21, 24), (21, 25), (21, 26), (20, 24), (20, 25), (20, 26),
                    // Поворот вниз к y=22
                    (20, 23), (20, 22), (20, 21), (19, 23), (19, 22), (19, 21), (18, 23), (18, 22), (18, 21),
                    // Горизонтальная часть до x=10
                    (17, 23), (17, 22), (17, 21), (16, 23), (16, 22), (16, 21), (15, 23), (15, 22), (15, 21),
                    (14, 23), (14, 22), (14, 21), (13, 23), (13, 22), (13, 21), (12, 23), (12, 22), (12, 21),
                    (11, 23), (11, 22), (11, 21), (10, 23), (10, 22), (10, 21),
                    // Поворот вниз к y=18
                    (10, 20), (10, 19), (10, 18), (9, 20), (9, 19), (9, 18), (8, 20), (8, 19), (8, 18),
                    // Горизонтальная часть до x=4
                    (7, 20), (7, 19), (7, 18), (6, 20), (6, 19), (6, 18), (5, 20), (5, 19), (5, 18), (4, 20), (4, 19), (4, 18),
                    // Поворот вниз к базе (2, 2), пересечение с дорогой 1 в (2, 3–5)
                    (4, 17), (4, 16), (4, 15), (3, 17), (3, 16), (3, 15), (2, 17), (2, 16), (2, 15), (2, 14), (2, 13),
                    (2, 12), (2, 11), (2, 10), (2, 9), (2, 8), (2, 7), (2, 6), (2, 5), (2, 4), (2, 3), (2, 2)
                ]
        
        // road init
        for (x, y) in road1 + road2 {
            grid[y][x].type = .road
        }
        
        // Base: (2, 2)
        grid[2][2].type = .base
        let base = grid[2][2]

        grid[2][28].type = .resource

//        let resourseCell = grid[2][28]
        // spawn 1: (28, 15)
        grid[15][28].type = .lair

        let spawnCell = grid[15][28]
        
        let spawnModel1 = SpawnModel(field: self,
                                     spawn: spawnCell,
                                     goal: base,
                                     resourceType: .none,
                                     resoucesQuantity: 0)
        addFindPathComponent(to: spawnModel1)
        monsterSpawns.append(spawnModel1)
        
        // spawn 2: (28, 25)
        grid[25][28].type = .lair
        let lair2 = grid[25][28]
        
        
        let spawnModel2 = SpawnModel(field: self,
                                     spawn: lair2,
                                     goal: base,
                                     resourceType: .none,
                                     resoucesQuantity: 0)
        addFindPathComponent(to: spawnModel2)
        monsterSpawns.append(spawnModel2)
        
        grid[0][0].type = .decor
        grid[0][29].type = .decor
        grid[29][0].type = .decor
        grid[29][29].type = .decor
        
// cell visual -> todo: visual component
        for y in 0..<gridHeight {
            for x in 0..<gridWidth {
                let cell = grid[y][x]
                let sprite = SKSpriteNode(
                    color: colorForCellType(cell.type),
                    size: CGSize(width: cellSize,
                                 height: cellSize))
                sprite.position = gridPositionToScene(x: x, y: y)
                sprite.name = "\(cell.type.rawValue)_\(x)_\(y)"
                scene?.addChild(sprite)
                grid[y][x].node = sprite
            }
        }
        updatePathGraph()
    }
    
    private func updatePathGraph() {
        for y in 0..<gridHeight {
            for x in 0..<gridWidth {
                let node = pathGraph.node(atGridPosition: vector_int2(Int32(x), Int32(y)))
                // Разрешаем путь к базе и дороге
                let cell = grid[y][x]
                if cell.type != .road && cell.type != .base && cell.type != .lair {
                    node?.removeConnections(to: node?.connectedNodes ?? [], bidirectional: true)
                }
            }
        }
        //spawn components update
        updatePaths()
    }
    
    private func colorForCellType(_ type: GridCellType) -> NSColor {
        switch type {
            case .road: return .gray
            case .field: return .green
            case .base: return .blue
            case .resource: return .yellow
            case .decor: return .brown
            case .block: return .black
            case .lair: return .red
            case .tower:
                return .orange
        }
    }
}

// MARK: - checks
extension Field {
    func filedPieceInLocation(_ location: CGPoint) throws -> GridCell {
        let gridPos = convertToGridPosition(cgPoint: location,
                                            pathGraph: pathGraph )
        print("tapped at pos: \(gridPos)")
        guard gridPos.x >= 0, gridPos.x < Int32(gridWidth), gridPos.y >= 0, gridPos.y < Int32(gridHeight) else {
            print("Invalid grid position: \(gridPos)")
            throw MavRaidError.invalidLocation
        }
        return grid[Int(gridPos.y)][Int(gridPos.x)]
    }
}

// MARK: - Block
extension Field{
    func addBlockToCell(_ cell: GridCell){
        guard cell.type == .road  else { return }
        cell.type = .block
        cell.node?.color = colorForCellType(.block)
        
        if let node = pathGraph.node(atGridPosition: cell.gridPosition){
            if cell.type != .road &&
                cell.type != .base &&
                cell.type != .lair {
                cell.neighbors = node.connectedNodes
                node.removeConnections(to: node.connectedNodes,
                                       bidirectional: true)
            }
            updatePaths()
        }
    }
    
    func removeBlockFromCell(_ cell: GridCell){
        guard cell.type == .block else { return }
        cell.type = .road
        cell.node?.color = colorForCellType(.road)
        if let node = pathGraph.node(atGridPosition: cell.gridPosition){
            node.addConnections(to: cell.neighbors, bidirectional: true)
        }
        updatePaths()
    }
}

// MARK: - SpawnPoint
extension Field{
    func addSpawnPointInCell(_ start: GridCell, to goal: GridCell){}
    //for test
    func startSpawn(){
        monsterSpawns.forEach { spawn in
            scene?.run(SKAction.repeatForever(
                SKAction.sequence(
                    [SKAction.run {spawn.startSpawnMonsters()},
                     SKAction.wait(forDuration: 90)]
                )
            )
            )
        }
    }
}

// MARK: - Monsters
extension Field {
    func addMonster(_ monster: MonsterModel){
        if let start = monster.gridPath.first{
            let monsterNode = BaseMonsterNode(
                texture: textureBank.moveRightTextures[0],
                size: CGSize(width: 30,
                             height: 30),
                parentUnit: monster)
            //name with id !
//            monsterNode.normalTexture = monsterTextureBank.normalMap[0]
            monsterNode.name = "monster\(monster.id)"
            monsterNode.position = SceneHelper.gridPositionToScene(position: start.gridPosition)
            monsterNode.zPosition = 2
            monster.node = monsterNode
//            monsterNode.lightingBitMask = 0b0001
            scene?.addChild(monsterNode)
            monster.start()
        } else {
            print("cant add monster in field")
        }
    }
    
}

// MARK: - Towers
extension Field {
    func addTowerToCell(_ cell: GridCell){
        guard cell.type == .field else { return }
        cell.type = .tower
        let position = gridPositionToScene(x: Int(cell.gridPosition.x),
                                           y: Int(cell.gridPosition.y))
        
        let model = TowerModel(type: TowerType.arrow,field: self,cell: cell)
        
        towers.append(model)
        
        if let texture = textureBank.all[.tower]?.first{
            print(texture)
            let node = BaseTowerNode(texture: texture,
                                     size: CGSize(width: cellSize,
                                                  height: cellSize),
                                                  parentUnit: model)
            model.node = node
            node.position = position
            cell.node = node
            scene?.addChild(node)
        } else {
            print("empty txture")
        }
    }
}

// MARK: - Helpers
extension Field {
    //vector_int2 -> GridCell
    func cellInGridPosition(_ position: vector_int2) -> GridCell{
        grid[Int(position.y)][Int(position.x)]
    }

    //CGPoint -> vector_int2
    private func convertToGridPosition(cgPoint: CGPoint,
                                       pathGraph: GKGridGraph<GKGridGraphNode>) -> vector_int2 {
        let x = Int32(floor(cgPoint.x / cellSize))
        let y = Int32(floor(cgPoint.y / cellSize))
        
        // Проверка границ сетки
        let maxX = Int32(pathGraph.gridWidth - 1)
        let maxY = Int32(pathGraph.gridHeight - 1)
        let clampedX = max(0, min(x, maxX))
        let clampedY = max(0, min(y, maxY))
        
        // Проверка, существует ли узел в графе
        if pathGraph.node(atGridPosition: vector_int2(clampedX, clampedY)) != nil {
            return vector_int2(clampedX, clampedY)
        } else {
            print("Warning: No valid node at position (\(clampedX), \(clampedY))")
            return vector_int2(clampedX, clampedY) // Возвращаем ближайшую валидную позицию
        }
    }
    // Конвертация координат сетки в сцену
    private func gridPositionToScene(x: Int, y: Int) -> CGPoint {
        let sceneX = CGFloat(x) * cellSize + cellSize / 2
        let sceneY = CGFloat(y) * cellSize + cellSize / 2
        return CGPoint(x: sceneX, y: sceneY)
    }
}
