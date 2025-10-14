#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import SpriteKit
import GameplayKit


class RaidScene: SKScene, RootScene {
    weak var mainViewDelegate: MainViewDelegateProtocol?
    
    var field: Field = Field()
    
    //    private var baseNode: SKSpriteNode!
    //    private var resourceNode: SKSpriteNode!
    private var monsterSpawns: [SKSpriteNode] = []
    
    private var turrets: [SKSpriteNode] = []
    private var blocks: [SKSpriteNode] = []
    
    private var monsters: [GKEntity] = []
    
    private var resourceCount: Int = 0
    private let resourceLimit: Int = 100
    
    private var isCollecting: Bool = false
    private var waveNumber: Int = 0
    
    private var grid: [[GridCell]] = []
    
    private var pathGraph: GKGridGraph<GKGridGraphNode>!
    
    private let cellSize: CGFloat = 100.0
    
    private let gridWidth = 30
    private let gridHeight = 30
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        size = view.frame.size
        scaleMode = .aspectFill
        backgroundColor = .black
        view.showsFPS = true
        view.showsNodeCount = true
        view.showsDrawCount = true
        view.showsFields = true
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        //loading Screen
        //make field, when finished -> loading screen finished
        field.scene = self
        field.generateField()
        setupCamera()
        //        for i in 0..<4 {
        //            let lightNode = SKLightNode()
        //            lightNode.position = CGPoint(x: size.width / 2 + CGFloat(i * 100), y: size.height / 2 + 10000)
        //            lightNode.categoryBitMask = 0b0001
        ////            lightNode.lightColor = .white.withAlphaComponent(0.25) // Уменьшенная интенсивность
        //            lightNode.ambientColor = .white.withAlphaComponent(0.2)
        //            lightNode.falloff = 0.01
        //            lightNode.shadowColor = .black.withAlphaComponent(0.0) // Отключение теней
        //            addChild(lightNode)
        //        }
        
        //
        field.startSpawn()
    }
    
    
    
   
    
    // Обработка события
    //    private func handleEvent(_ event: Event) {
    //        guard event.type == .blockPlaced else { return }
    //
    //        print("Processing event: \(event.type) at position \(event.position)")
    //        field.updatePaths()
    //    }
    
    // Размещение башни или блока
    //    private func placeObject(at location: CGPoint, isTurret: Bool) {
    //        let gridPos = sceneToGridPosition(location)
    //        guard gridPos.x >= 0, gridPos.x < Int32(gridWidth), gridPos.y >= 0, gridPos.y < Int32(gridHeight) else {
    //            print("Invalid grid position: \(gridPos)")
    //            return
    //        }
    //        print("gridPos = \(gridPos)")
    //        let cell = grid[Int(gridPos.x)][Int(gridPos.y)]
    //        if isTurret && cell.type == .field {
    //            let turret = SKSpriteNode(color: .blue, size: CGSize(width: cellSize * 0.8, height: cellSize * 0.8))
    ////            turret.position = gridPositionToScene(x: Int(gridPos.x), y: Int(gridPos.y))
    //            turret.name = "turret"
    //            addChild(turret)
    //            turrets.append(turret)
    //
    //            // Стрельба
    //            let shootAction = SKAction.repeatForever(SKAction.sequence([
    //                SKAction.wait(forDuration: 1.0),
    //                SKAction.run { [weak self] in
    //                    guard let self = self, let target = self.monsters.first?.component(ofType: GKSKNodeComponent.self)?.node else { return }
    //                    let bullet = SKSpriteNode(color: .white, size: CGSize(width: 10, height: 10))
    //                    bullet.position = turret.position
    //                    self.addChild(bullet)
    //                    let move = SKAction.move(to: target.position, duration: 0.5)
    //                    bullet.run(move) {
    //                        bullet.removeFromParent()
    //                        target.removeFromParent()
    //                        if let index = self.monsters.firstIndex(where: { $0.component(ofType: GKSKNodeComponent.self)?.node == target }) {
    //                            self.monsters.remove(at: index)
    //                            // Очистка монстра из словаря путей
    //                            for (pathId, data) in self.pathsDictionary {
    //                                if var monsterList = data["monsters"] as? [GKEntity], let monsterIndex = monsterList.firstIndex(where: { $0 === target.entity }) {
    //                                    monsterList.remove(at: monsterIndex)
    //                                    self.pathsDictionary[pathId]?["monsters"] = monsterList
    //                                }
    //                            }
    //                        }
    //                    }
    //                }
    //            ]))
    //            turret.run(shootAction)
    //        } else if !isTurret && cell.type == .road {
    //            let block = SKSpriteNode(color: .gray, size: CGSize(width: cellSize * 0.8, height: cellSize * 0.8))
    ////            block.position = gridPositionToScene(x: Int(gridPos.x), y: Int(gridPos.y))
    //            block.name = "block"
    //            addChild(block)
    //            blocks.append(block)
    //
    //            // Обновление графа: ячейка становится непроходимой
    //            grid[Int(gridPos.y)][Int(gridPos.x)].type = .field
    ////            grid[Int(gridPos.y)][Int(gridPos.x)].node?.color = colorForCellType(.field)
    ////            updatePathGraph()
    //
    //            // Создание события и обработка
    //            let event = Event(type: .blockPlaced, position: gridPos)
    //            handleEvent(event)
    //        } else {
    //            print("Cannot place \(isTurret ? "turret" : "block") on \(cell.type.rawValue)")
    //        }
    //    }
    
    
    
    // Активация добычи
    //    private func startCollecting() {
    //        isCollecting = true
    //        let collectAction = SKAction.repeatForever(SKAction.sequence([
    //            SKAction.wait(forDuration: 1.0),
    //            SKAction.run { [weak self] in
    //                guard let self = self else { return }
    //                if self.resourceCount < self.resourceLimit {
    //                    self.resourceCount += 10
    //                    print("Collected: \(self.resourceCount)/\(self.resourceLimit)")
    //                    if self.resourceCount >= self.resourceLimit {
    //                        self.endRaid(success: true)
    //                    }
    //                }
    //            }
    //        ]))
    //        run(collectAction, withKey: "collectResources")
    //    }
    
    // Завершение рейда
    //    private func endRaid(success: Bool) {
    //        removeAction(forKey: "spawnMonsters")
    //        removeAction(forKey: "collectResources")
    //        print(success ? "Raid succeeded with \(resourceCount) resources" : "Raid failed")
    //        mainViewDelegate?.presentScene(.home)
    //    }
    
}
// MARK: - Event Handling
extension RaidScene {
    func handleEventForCell(_ cell: GridCell){
        switch cell.type {
            case .road:
//                print("road tapped")
                if cell.state == .empty{
                    field.addBlockToCell(cell)
                    print("added block")
                } else {
                    print("cant add block on enemy")
                }
            case .field:
                //case build tower or smthng else
                print("field tapped")
                field.addTowerToCell(cell)
            case .base: print("base tapped")
            case .resource: print("resource tapped")
            case .lair: print("lair tapped")
            case .decor: print("decor tapped")
            case .block:
                print("block tapped")
                field.removeBlockFromCell(cell)
            case .tower:
                print("tower tapped")
                //tower control menu
//                cell.position
        @unknown default: print("unknown cell tapped")
        }
    }
}

// MARK: - Camera
extension RaidScene{
    // Настройка камеры
    private func setupCamera() {
        let cameraNode = SKCameraNode()
        cameraNode.name = "cameraNode"
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: cellSize * CGFloat(gridWidth) / 2, y: cellSize * CGFloat(gridHeight) / 2)
        
        let newScale = max(CGFloat(gridWidth) * cellSize / size.width,(CGFloat(gridHeight) * cellSize)/size.height)
        cameraNode.setScale(newScale)
    }
}

// MARK: - Control Input Delegate
extension RaidScene: ControlInputDelegate {
    // iOS: обработка касаний
    #if os(iOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if resourceNode.contains(location) && !isCollecting {
            startCollecting()
        } else {
            // Временная логика: первый тап — башня, второй — блок
            let isTurret = turrets.count <= blocks.count
            placeObject(at: location, isTurret: isTurret)
        }
    }
    #endif
    
    // macOS: обработка событий
    #if os(macOS)
    func handleMouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        
//        let nodes = nodes(at: location)
            // Клик с Shift — блок, без — башня
//            let isTurret = !event.modifierFlags.contains(.shift)
//            placeObject(at: location, isTurret: isTurret)
        
        do{
            let cell = try field.filedPieceInLocation(location)
            handleEventForCell(cell)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func handleScrollWheel(with event: NSEvent) {
        camera?.position.x -= event.scrollingDeltaX * 0.1
        camera?.position.y += event.scrollingDeltaY * 0.1
    }
    
    func handleMagnify(with event: NSEvent) {
        let newScale = max(0.5, min(2.0, (camera?.xScale ?? 1.0) + event.magnification))
        camera?.setScale(newScale)
    }
    
    func handleRotate(with event: NSEvent) {}
    func handleMouseUp(with event: NSEvent) {}
    func handleMouseMoved(with event: NSEvent) {}
    func handlePressureChange(with event: NSEvent) {}
    func handleKeyUp(with event: NSEvent) {}
    func handleKeyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0: camera?.position.x -= 10 // A
        case 2: camera?.position.x += 10 // D
        case 13: camera?.position.y += 10 // W
        case 1: camera?.position.y -= 10 // S
        default: break
        }
    }
    #endif
}

// MARK: - Converter
extension RaidScene {
    // Конвертация позиции сцены в координаты сетки
    private func sceneToGridPosition(_ point: CGPoint) -> vector_int2 {
        let x = Int32(floor(point.x / cellSize))
        let y = Int32(floor(point.y / cellSize))
        print(" tapped x: \(x), y: \(y)")
        return vector_int2(x: x, y: y)
    }
    //vector_int2 -> CGPoint
    private func gridPositionToScene(x: Int, y: Int) -> CGPoint {
        let sceneX = CGFloat(x) * cellSize + cellSize / 2
        let sceneY = CGFloat(y) * cellSize + cellSize / 2
        return CGPoint(x: sceneX, y: sceneY)
    }
}

