#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

import SpriteKit
import GameplayKit

class RaidScene: SKScene, RootScene {
    weak var mainViewDelegate: MainViewDelegateProtocol?
    private var baseNode: SKSpriteNode!
    private var resourcePoint: SKSpriteNode!
    private var monsterSpawn: SKSpriteNode!
    private var turrets: [SKSpriteNode] = []
    private var monsters: [GKEntity] = []
    private var resourceCount: Int = 0
    private let resourceLimit: Int = 100
    private var isCollecting: Bool = false
    private var waveNumber: Int = 0
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        size = view.frame.size
        scaleMode = .aspectFill
        backgroundColor = .black
        
        setupCamera()
        setupMap()
        setupWaveSystem()
    }
    
    // Настройка камеры
    private func setupCamera() {
        let cameraNode = SKCameraNode()
        cameraNode.name = RaidNodeNames.camera.rawValue
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
    }
    
    // Настройка карты
    private func setupMap() {
        // База (корабль)
        baseNode = SKSpriteNode(color: .green, size: CGSize(width: 50, height: 50))
        baseNode.position = CGPoint(x: size.width / 4, y: size.height / 4)
        baseNode.name = RaidNodeNames.base.rawValue
        baseNode.physicsBody = SKPhysicsBody(rectangleOf: baseNode.size)
        baseNode.physicsBody?.isDynamic = false
        addChild(baseNode)
        
        // Точка добычи
        resourcePoint = SKSpriteNode(color: .yellow, size: CGSize(width: 30, height: 30))
        resourcePoint.position = CGPoint(x: size.width * 3 / 4, y: size.height * 3 / 4)
        resourcePoint.name = RaidNodeNames.resourcePoint.rawValue
        addChild(resourcePoint)
        
        // Логово монстров
        monsterSpawn = SKSpriteNode(color: .red, size: CGSize(width: 30, height: 30))
        monsterSpawn.position = CGPoint(x: size.width * 3 / 4, y: size.height / 4)
        monsterSpawn.name = RaidNodeNames.monsterSpawn.rawValue
        addChild(monsterSpawn)
        
        // Дорога (визуальная, для прототипа)
        let path = SKShapeNode(rect: CGRect(x: size.width / 4, y: size.height / 4, width: size.width / 2, height: size.height / 2))
        path.fillColor = .gray
        path.zPosition = -1
        addChild(path)
    }
    
    // Настройка системы волн
    private func setupWaveSystem() {
        let spawnAction = SKAction.sequence([
            SKAction.run { self.spawnMonster() },
            SKAction.wait(forDuration: 2.0)
        ])
        run(SKAction.repeatForever(spawnAction), withKey: "spawnMonsters")
    }
    
    // Создание монстра
    private func spawnMonster() {
        let monsterNode = SKSpriteNode(color: .purple, size: CGSize(width: 20, height: 20))
        monsterNode.position = monsterSpawn.position
        monsterNode.name = RaidNodeNames.monster.rawValue
        monsterNode.physicsBody = SKPhysicsBody(rectangleOf: monsterNode.size)
        monsterNode.physicsBody?.isDynamic = true
        
        let monsterEntity = GKEntity()
        let spriteComponent = GKSKNodeComponent(node: monsterNode)
        monsterEntity.addComponent(spriteComponent)
        monsters.append(monsterEntity)
        
        addChild(monsterNode)
        
        // Движение к базе
        let moveAction = SKAction.move(to: baseNode.position, duration: 5.0)
        monsterNode.run(moveAction) {
            self.baseNode.removeFromParent()
            self.endRaid(success: false)
        }
        
        waveNumber += 1
    }
    
    // Размещение турели
    private func placeTurret(at position: CGPoint) {
        let turret = SKSpriteNode(color: .blue, size: CGSize(width: 25, height: 25))
        turret.position = position
        turret.name = RaidNodeNames.turret.rawValue
        addChild(turret)
        turrets.append(turret)
        
        // Стрельба по ближайшему монстру
        let shootAction = SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.run { [weak self] in
                guard let self = self, let target = self.monsters.first?.component(ofType: GKSKNodeComponent.self)?.node else { return }
                let bullet = SKSpriteNode(color: .white, size: CGSize(width: 10, height: 10))
                bullet.position = turret.position
                self.addChild(bullet)
                let move = SKAction.move(to: target.position, duration: 0.5)
                bullet.run(move) {
                    bullet.removeFromParent()
                    target.removeFromParent()
                    if let index = self.monsters.firstIndex(where: { $0.component(ofType: GKSKNodeComponent.self)?.node == target }) {
                        self.monsters.remove(at: index)
                    }
                }
            }
        ]))
        turret.run(shootAction)
    }
    
    // Активация добычи
    private func startCollecting() {
        isCollecting = true
        let collectAction = SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.run { [weak self] in
                guard let self = self else { return }
                if self.resourceCount < self.resourceLimit {
                    self.resourceCount += 10
                    print("Collected: \(self.resourceCount)/\(self.resourceLimit)")
                    if self.resourceCount >= self.resourceLimit {
                        self.endRaid(success: true)
                    }
                }
            }
        ]))
        run(collectAction, withKey: "collectResources")
    }
    
    // Завершение рейда
    private func endRaid(success: Bool) {
        removeAction(forKey: "spawnMonsters")
        removeAction(forKey: "collectResources")
        print(success ? "Raid succeeded with \(resourceCount) resources" : "Raid failed")
        mainViewDelegate?.presentScene(.home)
    }
    
    #if os(iOS)
    // iOS: обработка касаний
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if resourcePoint.contains(location) && !isCollecting {
            startCollecting()
        } else if !nodes(at: location).contains(where: { $0.name == RaidNodeNames.turret.rawValue }) {
            placeTurret(at: location)
        }
    }
    
    // macOS: обработка событий
    #elseif os(macOS)
    func handleMouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        if resourcePoint.contains(location) && !isCollecting {
            startCollecting()
        } else if !nodes(at: location).contains(where: { $0.name == RaidNodeNames.turret.rawValue }) {
            placeTurret(at: location)
        }
    }
    
    func handleScrollWheel(with event: NSEvent) {
        camera?.position.x += event.scrollingDeltaX * 0.1
        camera?.position.y -= event.scrollingDeltaY * 0.1
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

// Константы
enum RaidNodeNames: String {
    case camera = "cameraNode"
    case base = "base"
    case resourcePoint = "resourcePoint"
    case monsterSpawn = "monsterSpawn"
    case turret = "turret"
    case monster = "monster"
}
