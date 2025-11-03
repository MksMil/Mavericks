#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import SpriteKit
import GameplayKit


enum SceneState {
    case pauseMenu, raid, initial, towerMenu, towerUpgrade,blockMenu,blockUpgrade, questMenu,finish, heroSelected, monsterSelected
}

class RaidScene: SKScene, RootScene {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(size: CGSize,bank: RaidDataSource) {
        self.bank = bank
        super.init(size: size)
    }
    weak var mainViewDelegate: MainViewDelegateProtocol?
    weak var controlInputDelegate: ControlInputDelegate?
    weak var field: Field?
    
    weak var bank: RaidDataSource?
    var state: SceneState = .initial
    var selectedCell: GridCell?
    
    private var resourceCount: Int = 0
    private let resourceLimit: Int = 100
    
    private var isCollecting: Bool = false
    private var waveNumber: Int = 0
    
    var cameraNode = SKCameraNode()
    
    var hudNode: RaidDataInformer?
    
    private let cellSize: CGFloat = 100.0
    
    private let gridWidth = 30
    private let gridHeight = 30
    
    //camera constraints for expand level
    //expandable size
    
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
        field?.generateField()
        setupCamera()
        setupHUD()
    }
    
    override func willMove(from view: SKView) {
        
        hudNode = nil  // ← КРИТИЧЕСКИ ВАЖНО
    }
    
    deinit{
        print("raid scene deinit")
    }
}

// MARK: - State
extension RaidScene {
    func changeState(newState: SceneState){
        state = newState

        switch newState {
            case .pauseMenu:
                //controlInputDelegate = hud
                //field - > pause
                //hud -> pause
                //state = newState
                field?.pause()
                hudNode?.changeState(newState: .pause)
            case .raid:
                field?.run()
//            case .initial:
//                <#code#>
//            case .towerMenu:
//                <#code#>
//            case .towerUpgrade:
//                <#code#>
//            case .blockMenu:
//                <#code#>
//            case .blockUpgrade:
//                <#code#>
//            case .questMenu:
//                <#code#>
            case .finish:
                // animation
                // data transfer
                mainViewDelegate?.presentScene(.home)
                print("finish raid")
                removeAllActions()
                enumerateChildNodes(withName: "//*") { node, _ in
                    node.removeAllActions()
                }
                removeAllChildren()
                hudNode = nil
                controlInputDelegate = nil
                //            case .heroSelected:
//                <#code#>
//            case .monsterSelected:
//                <#code#>
            default: return
        }
    }
}

// MARK: - Camera
extension RaidScene{
    //TODO: add scene camCanMove camCanScale constraints, and change constraints when level extended
    
    // Настройка камеры
    private func setupCamera() {
        cameraNode.name = NodeNames.camera.rawValue
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: cellSize * CGFloat(gridWidth) / 2, y: cellSize * CGFloat(gridHeight) / 2)
        
        let newScale = max(CGFloat(gridWidth) * cellSize / size.width,(CGFloat(gridHeight) * cellSize)/size.height)
        cameraNode.setScale(newScale)
    }
}
// MARK: - Hud
extension RaidScene {
    
    func setupHUD(){
        guard let bank else { return }
        hudNode = HudNode(withCameraSize: view?.frame.size ?? .zero,bank: bank,outputDelegate: self)
//        hudNode?.outputDelegate = self
        guard let hudNode  = hudNode as? SKNode else {
            print("can't load hud, unexpected behavior in setupHUD")
            return
        }
        cameraNode.addChild(hudNode)
    }
    
    func handleHudEvent(withNode node: HudButton){
        print("handle hud event")
            switch node.name {
                case NodeNames.pause.rawValue:
                    switch self.state {
                        case .initial:
                            self.field?.start()
                            self.state = .raid
                        case .pauseMenu:
                            print("unpause")
                            self.state = .raid
                            field?.fieldNode.isPaused = false
                            hudNode?.hidePauseMenu()
                        case .raid:
                            print("pause")
                            changeState(newState: .pauseMenu)
//                            hudNode?.showPauseMenu()
//                        case .towerMenu:
//                            break
//                        case .blockMenu:
//                            break
//                        case .questMenu:
//                            break
//                        case .towerUpgrade:
//                            <#code#>
//                        case .blockUpgrade:
//                            <#code#>
//                        case .finish:
//                            <#code#>
//                        case .heroSelected:
//                            <#code#>
//                        case .monsterSelected:
//                            <#code#>
                        default: break
                    }
                case NodeNames.arrow.rawValue:
                    print("arrow tower")
                    guard let selectedCell else { return }
                    field?.addTower(TowerType.arrow, toCell: selectedCell)
                    hudNode?.hideMenu()
                    state = .raid
                case NodeNames.poison.rawValue:
                    print("poison tower")
                    guard let selectedCell else { return }
                    field?.addTower(TowerType.poison, toCell: selectedCell)
                    hudNode?.hideMenu()
                    state = .raid
                case NodeNames.fire.rawValue:
                    print("fire tower")
                    guard let selectedCell else { return }
                    field?.addTower(TowerType.fire, toCell: selectedCell)
                    hudNode?.hideMenu()
                    state = .raid
                case NodeNames.frost.rawValue:
                    print("fire tower")
                    guard let selectedCell else { return }
                    field?.addTower(TowerType.freeze, toCell: selectedCell)
                    hudNode?.hideMenu()
                    state = .raid
                case NodeNames.electro.rawValue:
                    print("electro tower")
                    guard let selectedCell else { return }
                    field?.addTower(TowerType.electric, toCell: selectedCell)
                    hudNode?.hideMenu()
                    state = .raid
                case NodeNames.stun.rawValue:
                    print("stun tower")
                    guard let selectedCell else { return }
                    field?.addTower(TowerType.stun, toCell: selectedCell)
                    hudNode?.hideMenu()
                    state = .raid
                    
                default: break
            }
        
    }
}

// MARK: - Event Handling
extension RaidScene {
    func handleEventForCell(_ cell: GridCell,
                            event: NSEvent){
        switch cell.type {
            case .road:
                if cell.state == .empty{
                    field?.addBlockToCell(cell)
                    print("added block")
                } else {
                    print("cant add block on enemy")
                }
            case .field:
                //case build tower or smthng else
                print("field tapped")
                selectedCell = cell
                if let node = hudNode as? SKNode{
                  let pos = event.location(in: node)
                    state = .towerMenu
                    hudNode?.showMenu(inPosition: pos)
                }
//                field.addTowerToCell(cell)
            case .base: print("base tapped")
            case .resource: print("resource tapped")
            case .spawn: print("spawn tapped")
            case .decor: print("decor tapped")
            case .block:
                print("block tapped")
                field?.removeBlockFromCell(cell)
            case .tower:
                print("hide tower menu")
                //tower control menu

//                cell.position
        @unknown default: print("unknown cell tapped")
        }
    }
    
    func processLocation(_ location: CGPoint){
        if let tappedNode = nodes(at: location).first,
           let tappedName = tappedNode.name{
            switch tappedName{
                case NodeNames.startButton.rawValue:
                    print("start tapped")
                case NodeNames.pause.rawValue:
                    print("pause tapped")
                case NodeNames.road.rawValue:
                    print("road tapped")
                case NodeNames.field.rawValue:
                    print("field tapped")
                default:
                    controlInputDelegate = self
            }
        } else {
            controlInputDelegate = self
        }
    }
}

// MARK: - Control Input Delegate
extension RaidScene: ControlInputDelegate {
    // iOS: обработка касаний
    #if os(iOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
    }
    #endif
    
    // macOS: обработка событий
    #if os(macOS)
    func handleMouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        //node type -> change state with nodes value
        // hud -> pause / settings / abilities
        // empty cell -> tower/block
        // unit -> hero / quest
        // monster -> info
        // tower / block -> hud menu
        
        // define delegate for node.name / type

        switch state {
            case .pauseMenu:
                controlInputDelegate = hudNode?.controlInputDelegate
                controlInputDelegate?.handleMouseDown(with: event)
                return
            case .raid:
                if let tappedNode = nodes(at: location).first as? HudButton{
                    handleHudEvent(withNode: tappedNode)
                    return
                }
                do{
                    if let cell = try field?.fieldPieceInLocation(location){
                        handleEventForCell(cell, event: event)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .initial:
                if let tappedNode = nodes(at: location).first as? HudButton{
                    handleHudEvent(withNode: tappedNode)
                    return
                }
                do{
                    if let cell = try field?.fieldPieceInLocation(location){
                        handleEventForCell(cell, event: event)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .towerMenu:
                if let tappedNode = nodes(at: location).first as? HudButton{
                    handleHudEvent(withNode: tappedNode)
                    print("towerMenu tapped")
                    return
                } else {
                    hudNode?.hideMenu()
                    state = .raid
                    return
                }
//            case .blockMenu:
//                return
//            case .questMenu:
//                return
//            case .towerUpgrade:
//                <#code#>
//            case .blockUpgrade:
//                <#code#>
//            case .finish:
//                <#code#>
//            case .heroSelected:
//                <#code#>
//            case .monsterSelected:
//                <#code#>
            default: return
        }
    }
    
    func handleScrollWheel(with event: NSEvent) {
//        camera?.position.x -= event.scrollingDeltaX * 0.1
//        camera?.position.y += event.scrollingDeltaY * 0.1
    }
    
    func handleMagnify(with event: NSEvent) {
//        let newScale = max(0.5, min(2.0, (camera?.xScale ?? 1.0) + event.magnification))
//        camera?.setScale(newScale)
    }
    
    func handleRotate(with event: NSEvent) {}
    
    func handleMouseUp(with event: NSEvent) {
        controlInputDelegate?.handleMouseUp(with: event)
    }
    
    
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

