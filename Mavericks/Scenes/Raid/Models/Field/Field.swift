import SpriteKit
import GameplayKit

class Field: SKNode{
    weak var fieldOutputDelegate: FieldOutputDelegateProtocol?
    weak var raidScene: RaidScene?
    //texture bank
    let bank: RaidDataSource
    
    var selectedCell: GridCell? //
    
    //tower menus
    var fieldBuildingMenuInputDelegate: FieldBuildingMenuInputDelegateProtocol?
    var towerModifyMenuInputDelegate: TowerModifyMenuInputDelegateProtocol?
    
    //block / trap menus
    var roadBuildingMenuInputDelegate: RoadBuildingMenuInputDelegateProtocol?
    var blockModifyMenuInputDelegate: BlockModifyMenuInputDelegateProtocol?

    
    //path finding
    var pathGraph: GKGridGraph<CustomGridNode> = GKGridGraph<CustomGridNode>()
    let pathComponentSystem: GKComponentSystem<FieldPathComponent> = .init(componentClass: FieldPathComponent.self)
    
    //
    var grid: [[GridCell]] = []
    
    //cell cache
    private var cellCache: [String: GridCell] = [:]

    func cellInGridPosition(_ position: vector_int2) -> GridCell {
        let key = "\(position.x)_\(position.y)"
        if let cached = cellCache[key] {
            return cached
        }
        let cell = grid[Int(position.y)][Int(position.x)]
        cellCache[key] = cell
        return cell
    }
    func gridPositionToScene(_ pos: vector_int2) -> CGPoint {
        let cacheKey = "\(pos.x)_\(pos.y)"
        if let cached = positionCache[cacheKey] {
            return cached
        }
        let point = CGPoint(x: CGFloat(pos.x) * cellSize + cellSize/2,
                            y: CGFloat(pos.y) * cellSize + cellSize/2)
        positionCache[cacheKey] = point
        return point
    }
    private var positionCache: [String: CGPoint] = [:]
    
    //map
    let map: FieldModel
    
    //batch nodes
    let mapNode = SKNode()
    let contentNode = SKNode()
    let interactiveNode = SKNode()
    let menuNode = SKNode()
    //for future engine to make difficalt waves
    var base: GridCell?
    var spawns: [GridCell] = []
    var towers: [TowerModel] = []
    var blocks: [BlockModel] = []
    var traps: [TrapModel] = []
    //pools
    let bulletPool: BulletPool
    var activeBullets: Set<BulletModel> = Set()
    let monsterPool: MonsterPool
    
    var stateMachine: GKStateMachine?
    
    let cellSize: CGFloat
    let iconSize: CGSize
    
    let gridWidth: Int
    let gridHeight: Int
    
    
    init(scene: RaidScene,
         bank: RaidDataSource,
         cellSize: CGFloat = 64,
         map: FieldModel = FieldModel.TestLevel) {
        self.raidScene = scene
        self.cellSize = cellSize
        self.map = map
        self.gridWidth = map.width
        self.gridHeight = map.height
        
        self.bank = bank
        self.iconSize = CGSize(width: cellSize,
                               height: cellSize)
        self.bulletPool = BulletPool(bank: bank)
        self.monsterPool = MonsterPool(bank: bank)
        super.init()
        //self setup
        mapNode.zPosition = 1
        addChild(mapNode)
//        mapNode.isPaused = true
        addChild(contentNode)
        contentNode.zPosition = 2
        addChild(interactiveNode)
        interactiveNode.zPosition = 3
        addChild(menuNode)
        menuNode.zPosition = 4
        fieldOutputDelegate = scene
        setupStateMachine()
        generateField()
        //add menu nodes
        setupMenus()
    }
    
    func setupMenus(){
        addTowerBuildMenu()
        addTowerModifyMenu()
        addRoadBuildingMenu()
        addBlockModifyMenu()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupStateMachine(){
        //state machine setup
        let pausedState = PausedFieldState(field: self)
        let runState = RunFieldState(field: self)
        let initialState = InitialFieldState(field: self)
        self.stateMachine = GKStateMachine(states: [initialState,runState,pausedState])
        self.stateMachine?.enter(InitialFieldState.self)
    }
    
    func generateField() {
        setupGrid()
        //with animation add fieldNode
        raidScene?.addChild(self)
    }
    
    func addNewZone(){
        //add new game zone to scene
    }
    
    
}
// MARK: - Pause
extension Field {
    func start(){
        stateMachine?.enter(RunFieldState.self)
        startSpawn()
    }
    func pause(){
        stateMachine?.enter(PausedFieldState.self)
    }
    func run(){
        stateMachine?.enter(RunFieldState.self)
    }
    func stop(){
//        stateMachine?.enter(<#T##stateClass: AnyClass##AnyClass#>) //finish state
        interactiveNode.isPaused = true
        spawns.forEach { spawn in
            removeAllActions()
            interactiveNode.removeAllActions()
            interactiveNode.removeAllChildren()
            spawn.spawn?.stopSpawnMonsters()
        }
    }
}


// MARK: - FieldInputDelegate
extension Field: FieldInputDelegateProtocol{
    func handleNode(_ tappedNode: BaseRaidNode,
                    isTapEnded: Bool,
                    state: SceneState,
                    sceneLocation: CGPoint) {
        print("field handled event")
        if !isTapEnded{
            selectedCell = try? cellInLocation(sceneLocation)
            let pos = selectedCell?.scenePosition ?? .zero
            let type = tappedNode.type
            var newState: SceneState = .run
            switch state {
                case .paused, .finished:
                    return
                case .run, .initial:
                    print("show menu")
                    print("\(tappedNode.type)")
                    //show menu
                    switch type {
                        case .field:
                            fieldBuildingMenuInputDelegate?.show(pos)
                            newState = .fieldBuild
                        case .tower:
                            towerModifyMenuInputDelegate?.show(pos)
                            newState = .towerUpgrade
                        case .road:
                            roadBuildingMenuInputDelegate?.show(pos)
                            newState = .roadBuild
                        case .block:
                            blockModifyMenuInputDelegate?.show(pos)
                            newState = .blockUpgrade
                        case .monster:
                            print("monster tapped")
                            newState = .monsterSelected
                        case .hero:
                            print("her tapped")
                            newState = .heroSelected
                        case .quest:
                            print("quest here")
                            newState = .questMenu
                        case .hud:
                            return
                        case .base:
                            print("base tapped")
                        case .spawn:
                            print("spawn tapped")
                        case .resorses:
                            print("resourses tapped")
                        case .empty:
                            print("empty cell tapped")
                    }
                case .fieldBuild:
                    fieldBuildingMenuInputDelegate?.hide()
                    newState = .run
                case .towerUpgrade:
                    towerModifyMenuInputDelegate?.hide()
                    newState = .run
                case .roadBuild:
                    roadBuildingMenuInputDelegate?.hide()
                    newState = .run
                case .blockUpgrade:
                    blockModifyMenuInputDelegate?.hide()
                    newState = .run
                case .questMenu:
                    print("hide menu")
                    //hide menu
                case .heroSelected:
                    print("")
                    // hero control?
                case .monsterSelected:
                    print("")
                    //detach monster hide info
            }
            fieldOutputDelegate?.handleNewState(state: newState)
        } else {
            //
        }
    }
}

// MARK: - Componenets
//MARK: Find Path Component
extension  Field {
    //use it in setup grid, when creating monster spawns
    func addFieldPathComponent(to spawn: SpawnModel) {
        let component = FieldPathComponent(cellSize: cellSize, spawn: spawn)
        spawn.pathComponent = component
        pathComponentSystem.addComponent(component)
    }
    func updatePaths(){
        pathComponentSystem.update(deltaTime: 0)
    }
}

// MARK: - Grid
extension Field {
    private func setupGrid() {
        pathGraph = GKGridGraph(fromGridStartingAt: vector_int2(0, 0),
                                width: Int32(map.width),
                                height: Int32(map.height),
                                diagonalsAllowed: false,
                                nodeClass: CustomGridNode.self)
//        if let baseCount = pathGraph.node(atGridPosition: vector_int2(x: 2, y: 2))?.connectedNodes.count{
//            print("base count = \(baseCount)")
//        }
        let cells = map.flippedVertically
        // all cells creation
        grid =
        (0..<map.height).map { y in
            (0..<map.width).map { x in
                    
                    let cell = GridCell(position: vector_int2(Int32(x), Int32(y)),
                                        mapCell: cells[y][x],
                                        cellSize: cellSize,
                                        node: nil)
                    let content = cells[y][x].mapCellContent
                    let mapType = cells[y][x].mapCellType
                    var type: BaseRaidNodeType = .empty
                    var texture: SKTexture = SKTexture()
                    switch content {
                        case .base:
                            type = .base
                            texture = bank.contentAtlas.textureNamed("base.png")
                        case .spawn:
                            type = .spawn
                            texture = bank.contentAtlas.textureNamed("spawn.png")
                        case .resourceWood:
                            type = .resorses
                        case .resourceStone:
                            type = .resorses
                        case .resourceMetal:
                            type = .resorses
                        case .resourceOil:
                            type = .resorses
                        case .qwestBuild:
                            type = .quest
                            
                        default:
                            if mapType == .road{
                                texture = bank.mapAtlas.textureNamed("road")
                                type = .road
                            }
                            if mapType == .earth{
                                let seed = Bool.random()
                                texture = bank.mapAtlas.textureNamed("field_\(seed ? 0:1)")
                                type = .field
                            }
                            if mapType == .water{
                                let fieldIndex = (x + y) % 3
                                texture = bank.mapAtlas.textureNamed("water_\(fieldIndex)")
                                type = .empty
                            }
                            if mapType == .rock{
                                let fieldIndex = (x + y) % 3
                                texture = bank.mapAtlas.textureNamed("rock_\(fieldIndex)")
                                type = .empty
                            }
                    }
                    
                    let sprite = BaseRaidNode(type: mapType.baseNodeType(),
                                              inputDelegate: self,
                                              infoSource: self,
                                              texture: texture,
                                              size: CGSize(width: cellSize, height: cellSize))
                    sprite.position = cell.scenePosition
                    sprite.name = "\(cell.fieldMapCellType)_\(x)_\(y)"
                    mapNode.addChild(sprite)
                    if type == .spawn {
                        spawns.append(cell)
                    }
                    if type == .base{
                        self.base = cell
                    }
                cell.node = sprite
                    return cell
            }
        }
        if let base {
            spawns.forEach { cell in
                let spawnModel = SpawnModel(field: self,
                                             spawn: cell,
                                             goal: base,
                                             resourceType: .none,
                                             resoucesQuantity: 0)
                cell.spawn = spawnModel
                addFieldPathComponent(to: spawnModel)
            }
        }

        updatePathGraph()
    }
}
// MARK: - PathGraph
extension Field {
   
    private func updatePathGraph() {
        for y in 0..<gridHeight {
            for x in 0..<gridWidth{
                if let node = pathGraph.node(atGridPosition: vector_int2(Int32(x), Int32(y))){
                    // Разрешаем путь к базе и дороге
                    let cell = grid[y][x]
                    if cell.fieldMapCellType != .road /*&& cell.content != .base && cell.content != .spawn */{
                        node.removeConnections(to: node.connectedNodes, bidirectional: true)
                    }
                } else {
                    print("unexpected error")
                }
            }
        }
        
        for y in 0..<gridHeight {
            for x in 0..<gridWidth{
                
                if let node = pathGraph.node(atGridPosition: vector_int2(Int32(x), Int32(y))){
                    // Разрешаем путь к базе и дороге
                    let cell = grid[y][x]
                    if cell.fieldMapCellType == .road {
                        node.isEdge = node.connectedNodes.count < 4 ? true: false
                        //if diagonal has !road - isEdge true
                        if x > 1, y > 1, node.connectedNodes.count > 3{
                            [grid[y - 1][x - 1],
                             grid[y - 1][x + 1],
                             grid[y + 1][x - 1],
                             grid[y + 1][x + 1]
                            ].forEach { nei in
                                if nei.fieldMapCellType != .road {
                                    node.isEdge = true
                                }
                            }
                        }
                    }
                }
            }
        }
        updatePaths()
    }
}

// MARK: - SpawnPoint
extension Field{
    func addSpawnPointInCell(_ start: GridCell,
                             to goal: GridCell){}
    //for test
    func startSpawn(){
        spawns.forEach { cell in
            if let model = cell.spawn{
                run(SKAction.repeatForever(
                    SKAction.sequence(
                        [SKAction.run {model.startSpawnMonsters()},
                         SKAction.wait(forDuration: 10)])
                )
                )
            }
        }
    }
}

// MARK: - Monsters
extension Field {
//    func addMonster(_ monster: MonsterModel){
//       
//        if let start = monster.gridPath.first{
//            let monsterNode = monster.node
//            monsterNode.position = SceneHelper.gridPositionToScene(position: start.gridPosition)
//            monsterNode.zPosition = 2
//            
//            monster.start()
//        } else {
//            print("cant add monster in field")
//        }
//    }
    func monsterFinish(){
        fieldOutputDelegate?.baseTakeDamage(damage: 10)
    }
    
}

// MARK: - Towers CRUD
extension Field {
    // MARK: add tower build menu
    func addTowerBuildMenu(){
        let towerBuildMenu = FieldBuildingMenuNode(towers: TowerType.allCases,
                                                   iconSize: iconSize,
                                                   bank: bank)
        fieldBuildingMenuInputDelegate = towerBuildMenu
        towerBuildMenu.fieldBuildingMenuOutputDelegate = self
        menuNode.addChild(towerBuildMenu)
    }
    // MARK: add tower modify menu
    func addTowerModifyMenu(){
        let towerModifyMenu = FieldModifyMenuNode(iconSize: iconSize,
                                                  bank: bank)
        towerModifyMenuInputDelegate = towerModifyMenu
        towerModifyMenu.towerModifyMenuOutputDelegate = self
        menuNode.addChild(towerModifyMenu)
    }
    func addTower(_ tower: TowerType,
                  toCell cell: GridCell){
        guard cell.fieldMapCellType == .earth else { return }
        cell.content = .tower
//        cell.node?.type = .tower
        let model = TowerModel(type: tower,
                               field: self,
                               cell: cell)
        towers.append(model)
        var texture: SKTexture
        switch tower {
            case .arrow:
                texture = bank.interactiveAtlas.textureNamed("arrowTower")
            case .poison:
                texture = bank.interactiveAtlas.textureNamed("poisonTower")
            case .frost:
                texture = bank.interactiveAtlas.textureNamed("frostTower")
            case .electro:
                texture = bank.interactiveAtlas.textureNamed("electroTower")
            case .fire:
                texture = bank.interactiveAtlas.textureNamed("fireTower")
            case .stun:
                texture = bank.interactiveAtlas.textureNamed("stunTower")
        }
         let node = BaseTowerNode(texture: texture,
                                     size: CGSize(width: cellSize,
                                                  height: cellSize),
                                     parentUnit: model,
                                     inputDelegate: self)
            model.node = node
            cell.tower = model
        //TODO: position
        node.position = cell.scenePosition
            interactiveNode.addChild(node)
            model.detectTargetCells()
    }
    // MARK: Remove tower
    func removeTowerFromCell(_ cell: GridCell){
        guard cell.content == .tower else { return }
        if let tower = cell.tower{
            // TODO: return funds to player
            tower.node?.removeAllActions()
            tower.node?.removeFromParent()
            cell.content = .empty
//            cell.node?.type = .field
            cell.tower = nil
            towers.removeAll { t in
                t == tower
            }
        } else {
            print("tower to remove: not exists")
        }
    }
    // MARK: Upgrade tower
    func upgradeTowerInCell(_ cell: GridCell){
        print("tower upgraded")
    }
}

// MARK: - Shooting
extension Field: BulletShotigAvailableProtocol {
    
    
    func shootBy(tower: TowerModel, onTarget target: MonsterModel){
        let bullet = bulletPool.getBullet(inField: self)
        bullet.configureBulletWith(tower: tower, andTarget: target)
        bullet.shootOnTarget()
        activeBullets.insert(bullet)
    }
    
    func finishShootByBullet(_ bullet: BulletModel){
        bulletPool.recycleBullet(bullet)
        activeBullets.remove(bullet)
    }
}

// MARK: - TowersBuildMenuOutput
extension Field: FieldBuildingMenuOutputDelegateProtocol{
    func handleNewTower(new: TowerType) {
        //player data modify
        //hud update
        if let cell = selectedCell{
            addTower(new,
                     toCell: cell)
            fieldBuildingMenuInputDelegate?.hide()
        } else {
            print("cell not found")
        }
        fieldOutputDelegate?.handleNewState(state: .run)
    }
    func cancel(){
        fieldOutputDelegate?.handleNewState(state: .run)
    }
}
// MARK: - TowerModifyOutput
extension Field: TowerModifyMenuOutputDelegateProtocol{
    func handleTowerModifySellEvent() {
        if let cell = selectedCell {
            removeTowerFromCell(cell)
        } else {
            print("cell not found")
        }
        fieldOutputDelegate?.handleNewState(state: .run)
    }
    
    func handleTowerModifyUpgradeEvent() {
        if let cell = selectedCell {
            upgradeTowerInCell(cell)
        } else {
            print("cell not found")
        }
        fieldOutputDelegate?.handleNewState(state: .run)
    }
}

// MARK: - Blocks and traps CRUD
extension Field{
    // MARK: add block build menu
    func addRoadBuildingMenu(){
        let roadBuildingMenu = RoadBuildingMenuNode(buildings: RoadBuildingType.allCases,
                                                    iconSize: iconSize,
                                                    bank: bank)
        roadBuildingMenuInputDelegate = roadBuildingMenu
        roadBuildingMenu.roadBuildingMenuOutputDelegate = self
        menuNode.addChild(roadBuildingMenu)
    }
    // MARK: add block modify menu
    func addBlockModifyMenu(){
        let blockModifyMenu = BlockModifyMenuNode(iconSize: iconSize,
                                                  bank: bank)
        blockModifyMenuInputDelegate = blockModifyMenu
        blockModifyMenuInputDelegate?.blockModifyMenuOutputDelegate = self
            menuNode.addChild(blockModifyMenu)
    }
    
    func addBlockToCell(_ cell: GridCell){
        guard cell.fieldMapCellType == .road  else { return }
        cell.content = .block
//        cell.node?.type = .block
        
        let block = BlockModel()
        let sprite = BaseBlockNode(texture: bank.contentAtlas.textureNamed("block"),
                                   parentUnit: block,
                                   inputDelegate: self)
//        block.node = sprite
        sprite.position = cell.scenePosition
        interactiveNode.addChild(sprite)
        cell.block = block
        
        //change grid, nad node connection
        if let node = pathGraph.node(atGridPosition: cell.gridPosition), let neib = node.connectedNodes as? [CustomGridNode]{
            if cell.fieldMapCellType == .road && cell.content == .block{
                cell.neighbors = neib//node.connectedNodes  //for fast connection updates if block removed
                node.removeConnections(to: node.connectedNodes,
                                       bidirectional: true)
            }
            updatePaths()
        }
    }
    
    func removeBlockFromCell(_ cell: GridCell){
        guard cell.content == .block else { return }

        // TODO: return funds to player
        if let block = cell.block{
            block.node?.removeAllActions()
            block.node?.removeFromParent()
            block.node = nil
            cell.block = nil
            cell.fieldMapCellType = .road
            cell.content = .empty
//            cell.node?.type = .road
        }
        if let node = pathGraph.node(atGridPosition: cell.gridPosition){
            node.addConnections(to: cell.neighbors, bidirectional: true)
        }
        updatePaths()
    }
    
    func upgradeBlockinCell(_ cell: GridCell){
        print("block upgraded")
        //block model changes, player funds changed, animation to cell.node / cell.block.node
    }
}
// MARK: - RoadBuildingMenuOutput
extension Field: RoadBuildingMenuOutputDelegateProtocol{
    func handleNewRoadBuilding(new: RoadBuildingType) {
        if let cell = selectedCell{
            switch new {
                case .block:
                    addBlockToCell(cell)
                case .trap:
                    print("trap added")
            }
        } else {
            print("cell not found")
        }
        fieldOutputDelegate?.handleNewState(state: .run)
    }
    
}
// MARK: -  BlockModifyMenuOutputDelegateProtocol
extension Field: BlockModifyMenuOutputDelegateProtocol{
    func handleBlockModifySellEvent() {
        if let cell = selectedCell{
            removeBlockFromCell(cell)
        }
        fieldOutputDelegate?.handleNewState(state: .run)
    }
    
    func handleBlockModifyUpgradeEvent() {
        if let cell = selectedCell{
            upgradeBlockinCell(cell)
        }
        fieldOutputDelegate?.handleNewState(state: .run)
    }
    
}

// MARK: - RaidDataInformer InfoSource
extension Field: Informable{
    
}

// MARK: - Helpers
extension Field {
    func cellInLocation(_ location: CGPoint) throws -> GridCell {
        let gridPos = convertToGridPosition(cgPoint: location,
                                            pathGraph: pathGraph )
//        print("tapped at pos: \(gridPos)")
        guard gridPos.x >= 0, gridPos.x < Int32(gridWidth),
                gridPos.y >= 0, gridPos.y < Int32(gridHeight) else {
            print("Invalid grid position: \(gridPos)")
            throw MavRaidError.invalidLocation
        }
        return grid[Int(gridPos.y)][Int(gridPos.x)]
    }
    //vector_int2 -> GridCell
//    func cellInGridPosition(_ position: vector_int2) -> GridCell{
//        grid[Int(position.y)][Int(position.x)]
//    }

    //CGPoint -> vector_int2
    private func convertToGridPosition(cgPoint: CGPoint,
                                       pathGraph: GKGridGraph<CustomGridNode>) -> vector_int2 {
        let x = Int32(floor(cgPoint.x / cellSize))
        let y = Int32(floor(cgPoint.y / cellSize))
        print("point: \(cgPoint), x: \(x), y: \(y)")
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
//    private func gridPositionToScene(x: Int, y: Int) -> CGPoint {
//        let sceneX = CGFloat(x) * cellSize + cellSize / 2
//        let sceneY = CGFloat(y) * cellSize + cellSize / 2
//        return CGPoint(x: sceneX, y: sceneY)
//    }
}
