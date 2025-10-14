import GameplayKit

//  основная задача класса - раздать всем монстрам
//  массив ключевых точек для перемещения.
//  и предоставить новый путь,
//  если карта изменилась - появились блоки или убраны блоки


class FieldPathComponent: GKComponent{
    
    var cellSize: CGFloat
    
    var startPoint: GridCell
    var endPoint: GridCell
    
    var spawn: SpawnModel
    var actualPath: [GKGridGraphNode] = []
    
    init(cellSize: CGFloat,
         spawn: SpawnModel) {
        self.cellSize = cellSize
        self.startPoint = spawn.spawn
        self.endPoint = spawn.goal
        self.spawn = spawn
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func makeInitialPath(){
        self.actualPath = makePathFromGridGraph()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        let newPath = makePathFromGridGraph()
        actualPath = newPath
        updateMonstersPaths()
    }
    
    func updateMonstersPaths()  {
        spawn.updateMonstersPaths(with: makePathFromGridGraph(start:))
    }
}

// MARK: - Find path
extension FieldPathComponent{
    //monsters use this to refresh path
    func makePathFromGridGraph(start: CGPoint)->[GKGridGraphNode]{
       let field = spawn.field
        
        if let startNode = field.pathGraph.node(atGridPosition: convertToGridPosition(cgPoint: start)),
           let endNode = field.pathGraph.node(atGridPosition: endPoint.gridPosition){
            //find path
            
            guard let path = field.pathGraph.findPath(from: startNode, to: endNode) as? [GKGridGraphNode], path.count >= 2 else {
                print("No valid path for monster from spawn \(startPoint) ")
                return []
            }
            var newPath = path
            //check nearest
            if (SceneHelper.distanceToScenePoint(SceneHelper.gridPositionToScene(position: path[0].gridPosition), from: start) + SceneHelper.distanceToScenePoint(SceneHelper.gridPositionToScene(position: path[1].gridPosition), from: SceneHelper.gridPositionToScene(position: path[0].gridPosition))) > SceneHelper.distanceToScenePoint(SceneHelper.gridPositionToScene(position: path[1].gridPosition), from: start) {
                newPath.remove(at: 0)
                return newPath
            }
            //return fields gridCells pointers
            return path
        } else {
            return []
        }
    }
    
    //new actual path
    func makePathFromGridGraph()->[GKGridGraphNode]{
        let field  = spawn.field 
        if let startNode = field.pathGraph.node(atGridPosition: startPoint.gridPosition),
           let endNode = field.pathGraph.node(atGridPosition: endPoint.gridPosition){
            //find path
            guard let path = field.pathGraph.findPath(from: startNode, to: endNode) as? [GKGridGraphNode], path.count >= 2 else {
                print("No valid path for monster from spawn \(startPoint) ")
                return []
            }
            //return fields gridCells pointers
            return path
        } else {
            return []
        }
    }
}

// MARK: - Convert Helpers
extension FieldPathComponent {
    
    //vector_int2 -> CGPoint
    private func gridPositionToScene(x: Int, y: Int) -> CGPoint {
        let sceneX = CGFloat(x) * cellSize + cellSize / 2
        let sceneY = CGFloat(y) * cellSize + cellSize / 2
        return CGPoint(x: sceneX, y: sceneY)
    }
    
    //CGPoint -> vector_int2
    private func convertToGridPosition(cgPoint: CGPoint) -> vector_int2 {
        let x = Int32(floor(cgPoint.x / cellSize))
        let y = Int32(floor(cgPoint.y / cellSize))
        
        return vector_int2(x: x, y: y)
//        let maxX = Int32(pathGraph.gridWidth - 1)
//        let maxY = Int32(pathGraph.gridHeight - 1)
//        let clampedX = max(0, min(x, maxX))
//        let clampedY = max(0, min(y, maxY))
//        
//        if pathGraph.node(atGridPosition: vector_int2(clampedX, clampedY)) != nil {
//            return vector_int2(clampedX, clampedY)
//        } else {
//            print("Warning: No valid node at position (\(clampedX), \(clampedY))")
//            return vector_int2(clampedX, clampedY)
//        }
    }
}
