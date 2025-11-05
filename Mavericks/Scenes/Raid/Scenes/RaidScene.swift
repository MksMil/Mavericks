#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import SpriteKit
import GameplayKit


enum SceneState {
    case paused, run, initial,finished, towerBuild, towerUpgrade,blockBuild,blockUpgrade, questMenu, heroSelected, monsterSelected
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
    
    var field: Field?
    
    weak var bank: RaidDataSource?
    var state: SceneState = .initial
    var selectedCell: GridCell?
    var selectedNode: HudButton?
    
    var cameraNode = SKCameraNode()
    var hudNode: RaidDataInformer?
    
    private let cellSize: CGFloat = 100.0
    
    private var resourceCount: Int = 0
    private let resourceLimit: Int = 100
    
    private var isCollecting: Bool = false
    private var waveNumber: Int = 0
    
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
    
    deinit{
        print("raid scene deinit")
    }
}

// MARK: - State
extension RaidScene {
    func changeState(newState: SceneState){
        state = newState

        switch newState {
            case .paused:
                //controlInputDelegate = hud
                //field - > pause
                //hud -> pause
                //state = newState
                field?.pause()
//                hudNode?.changeState(newState: .pause)
            case .run:
                field?.run()
//                hudNode?.changeState(newState: .run)
            case .initial:
                print("initial raid state")

            case .finished:
                // animation
                // data transfer
                
                mainViewDelegate?.presentScene(.home)
                print("finish raid")
            @unknown default: return
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
        hudNode = HudNode(withCameraSize: view?.frame.size ?? .zero,bank: bank)
        hudNode?.outputDelegate = self
        guard let hudNode  = hudNode as? SKNode else {
            print("can't load hud, unexpected behavior in setupHUD")
            return
        }
        cameraNode.addChild(hudNode)
    }
    
    func handleHudEvent(withNode node: HudButton){
        
            switch node.name {
                case NodeNames.pause.rawValue:
                    switch self.state {
                        case .initial:
                            self.field?.start()
                            self.state = .run
                        case .paused:
                            print("unpause")
                            self.state = .run
                            field?.fieldNode.isPaused = false
                            hudNode?.hidePauseMenu()
                        case .run:
                            print("pause")
                            changeState(newState: .paused)
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
                    state = .run
                case NodeNames.poison.rawValue:
                    print("poison tower")
                    guard let selectedCell else { return }
                    field?.addTower(TowerType.poison, toCell: selectedCell)
                    hudNode?.hideMenu()
                    state = .run
                case NodeNames.fire.rawValue:
                    print("fire tower")
                    guard let selectedCell else { return }
                    field?.addTower(TowerType.fire, toCell: selectedCell)
                    hudNode?.hideMenu()
                    state = .run
                case NodeNames.frost.rawValue:
                    print("fire tower")
                    guard let selectedCell else { return }
                    field?.addTower(TowerType.freeze, toCell: selectedCell)
                    hudNode?.hideMenu()
                    state = .run
                case NodeNames.electro.rawValue:
                    print("electro tower")
                    guard let selectedCell else { return }
                    field?.addTower(TowerType.electric, toCell: selectedCell)
                    hudNode?.hideMenu()
                    state = .run
                case NodeNames.stun.rawValue:
                    print("stun tower")
                    guard let selectedCell else { return }
                    field?.addTower(TowerType.stun, toCell: selectedCell)
                    hudNode?.hideMenu()
                    state = .run
                    
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
//                    state = .towerBuild
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
#if os(iOS)
    func processLocation(with event: UIEvent){
//        if let tappedNode = nodes(at: location).first,
//           let tappedName = tappedNode.name{
//            switch tappedName{
//                case NodeNames.startButton.rawValue:
//                    print("start tapped")
//                case NodeNames.pause.rawValue:
//                    print("pause tapped")
//                case NodeNames.road.rawValue:
//                    print("road tapped")
//                case NodeNames.field.rawValue:
//                    print("field tapped")
//                default: return
////                    controlInputDelegate = self
//            }
//        } else {
////            controlInputDelegate = self
//        }
    }

    
#elseif os(macOS)
    func processEvent(_ event: NSEvent, tapEnd: Bool){
        let location = event.location(in: self)
        if let tappedNode = nodes(at: location).first as? BaseRaidNode{
            if !tapEnd{
                print("touch down")
                //mouse down
                if tappedNode.type == .hud,
                    let buttonNode = tappedNode as? HudButton {
                    selectedNode = buttonNode
                    buttonNode.changeStateToTapped(true)
                }
            } else {
                print("touch up: tapped \(tappedNode.type)")
                if selectedNode?.type == .hud, tappedNode != selectedNode{
                    print("1")
                    selectedNode?.changeStateToTapped(false)
                } else {
                    print("2")
                    //mouse up
                    //paused, run, initial,finished
                    switch state {
                        case .initial:
                            switch tappedNode.type {
                                case .field:
                                    print("field tapped")
                                    // -> selectedCell
                                    // hud -> show towerbuildmenu
                                case .base:
                                    print("base tapped")
                                case .hud:
                                    if let buttonNode = tappedNode as? HudButton{
                                        selectedNode = nil
                                        //start temporary
                                        if buttonNode.name == NodeNames.pause.rawValue{
                                            buttonNode.changeStateToTapped(false) {[weak self] in
                                                guard let self else { return }
                                                self.field?.start()
                                                self.state = .run
                                            }
                                        }
                                    }
                                default:
                                    return
                            }
                            
                            
                        case .run:
                            switch tappedNode.type {
                                case .field:
                                    print("field tapped")
                                    // -> selectedCell
                                    // hud -> show towerbuildmenu
                                    selectedCell = try? field?.cellInLocation(location)
                                    state = .towerBuild
                                    hudNode?.showMenu(inPosition: convert(tappedNode.position,to: hudNode as! SKNode))
                                case .base:
                                    print("base tapped")
                                case .hud:
                                    if let buttonNode = tappedNode as? HudButton{
                                        selectedNode = nil
                                        //pause state
                                        if buttonNode.name == NodeNames.pause.rawValue{
                                            buttonNode.changeStateToTapped(false) { [weak self] in
                                                guard let self else { return }
                                                self.hudNode?.showPauseMenu()
                                                self.field?.pause()
                                                self.state = .paused
                                            }
                                        }
                                    }
                                default:
                                    return
                            }
                            
                        case .paused:
                            switch tappedNode.type {
                                case .hud:
                                    if let buttonNode = tappedNode as? HudButton{
                                        selectedNode = nil
                                        if buttonNode.name == NodeNames.resume.rawValue{
                                            buttonNode.changeStateToTapped(false) {[weak self] in
                                                guard let self else { return }
                                                self.hudNode?.hidePauseMenu()
                                                self.field?.run()
                                                self.state = .run
                                            }
                                        }
                                    }
                                default:
                                    return
                            }
                            
                        case .finished:
                            print("finished")
                        case .towerBuild:
                            print("towerBuild")
                            switch tappedNode.type {
                                case .hud:
                                    if let buttonNode = tappedNode as? HudButton{
                                        //animation?
                                        selectedNode = nil
                                        //pause state
                                       
                                        if let name = buttonNode.name,
                                           let selectedCell,
                                           NodeNames.towers.contains(name),
                                           let towerName = NodeNames(rawValue: name) {
                                            hudNode?.hideMenu()
                                            field?.addTowerWithName(towerName, toCell: selectedCell)
                                        }
                                    }
                                default: break
                            }
                            hudNode?.hideMenu()
                            state = .run
                        case .towerUpgrade:
                            print("towerUpgrade")
                        case .blockBuild:
                            print("blockBuild")
                        case .blockUpgrade:
                            print("blockUpgrade")
                        case .questMenu:
                            print("quest")
                        case .heroSelected:
                            print("hero")
                        case .monsterSelected:
                            print("monster")
                    }
                }
            }
        }
    }
#endif
    
    // MARK: outputDelegate
    func processRaidEvent(raidEvent: RaidEvent){
        
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
    func handleMouseUp(with event: NSEvent) {
//        controlInputDelegate?.handleMouseUp(with: event)
        processEvent(event,tapEnd: true)
    }
    func handleMouseDown(with event: NSEvent) {
        processEvent(event,tapEnd: false)
 
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

