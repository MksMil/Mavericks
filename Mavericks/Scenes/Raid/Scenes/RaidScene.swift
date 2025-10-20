#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import SpriteKit
import GameplayKit


enum SceneState {
    case pauseMenu, raid, initial, towerMenu, blockMenu, questMenu
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
    
    weak var field: Field?
    var bank: RaidDataSource
    var state: SceneState = .initial
    var tappedCell: GridCell?
    
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
}



// MARK: - Camera
extension RaidScene{
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
        hudNode = HudNode(withCameraSize: view?.frame.size ?? .zero,bank: bank)
        hudNode?.controlDelegate = self
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
                        node.changeState()
                        self.field?.start()
                        self.state = .raid
                    case .pauseMenu:
                        self.state = .raid
                        field?.fieldNode.isPaused = false
                        node.changeState()
                        hudNode?.hidePauseMenu()
                    case .raid:
                        node.changeState()
                        self.state = .pauseMenu
                        field?.fieldNode.isPaused = true
                        hudNode?.showPauseMenu()
                    case .towerMenu:
                        break
                    case .blockMenu:
                        break
                    case .questMenu:
                        break
                }
            case NodeNames.arrow.rawValue:
                print("arrow tower")
            case NodeNames.poison.rawValue:
                print("poison tower")
            case NodeNames.fire.rawValue:
                print("fire tower")
            case NodeNames.electro.rawValue:
                print("electro tower")
            case NodeNames.stun.rawValue:
                print("stun tower")
                
            default: break
        }
    }
}

// MARK: - Event Handling
extension RaidScene {
    func handleEventForCell(_ cell: GridCell,event: NSEvent){
        switch cell.type {
            case .road:
//                print("road tapped")
//                hudNode?.showMenu(inPosition: cell.scenePosition)
                if cell.state == .empty{
                    field?.addBlockToCell(cell)
                    print("added block")
                } else {
                    print("cant add block on enemy")
                }
            case .field:
                //case build tower or smthng else
                print("field tapped")
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
                print("tower tapped")
                //tower control menu
//                cell.position
        @unknown default: print("unknown cell tapped")
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
        
        switch state {
            case .pauseMenu:
                if let tappedNode = nodes(at: location).first{
                    if tappedNode.name == NodeNames.resume.rawValue{
                        //unpause
                        self.state = .raid
                        field?.fieldNode.isPaused = false
                        //            node.changeState()
                        hudNode?.hidePauseMenu()
                   } else if tappedNode.name == NodeNames.restart.rawValue{
                   } else if tappedNode.name == NodeNames.options.rawValue{
                   } else if tappedNode.name == NodeNames.exit.rawValue{
                   }
                }
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
                    print("tower tapped")
                    return
                } else {
                    hudNode?.hideMenu()
                    state = .raid
                    return
                }
            case .blockMenu:
                return
            case .questMenu:
                return
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

