#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import SpriteKit
import GameplayKit


enum SceneState {
    case paused, run, initial,finished
    case fieldBuild, towerUpgrade
    case roadBuild,blockUpgrade
    case questMenu
    case heroSelected, monsterSelected
}


// protocols input + output
// pauseMenuDelegate settings
// field -> TowerBuild menu
// road -> block/trap build
// creature
// hero
// spawn
// resourse
// quest



class PlayerData {
    
}


class RaidScene: SKScene, RootScene {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(size: CGSize,bank: RaidDataSource) {
        self.bank = bank
        super.init(size: size)
    }
    
    let playerData = PlayerData() // future dependency
    
    weak var mainViewDelegate: MainViewDelegateProtocol?
    weak var bank: RaidDataSource?
    
    var mainHudInputDelegate: MainHudInputDelegateProtocol?
    var fieldInputDelegate: FieldInputDelegateProtocol?
   
    var state: SceneState = .initial
    
    var selectedCell: GridCell?
    var selectedNode: HudButton?
    
    var cameraNode = SKCameraNode()
//    var hudNode: RaidDataInformer?
    
    private let cellSize: CGFloat = 64.0
    
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
        setupCamera()
        setupHUD()
    }
    
    deinit{
        print("raid scene deinit")
    }
    
//    override func didChangeSize(_ oldSize: CGSize) {
//        print("size changed")
//    }
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
        
        let newScale = max(CGFloat(gridWidth) * cellSize / size.width,
                           (CGFloat(gridHeight) * cellSize)/size.height)
        cameraNode.setScale(newScale)
    }
}
// MARK: - Hud
extension RaidScene {
    
    func setupHUD(){
        guard let bank else { return }
        mainHudInputDelegate = HudNode(withCameraSize: view?.frame.size ?? .zero,bank: bank)
        mainHudInputDelegate?.mainHudOutputDelegate = self
        guard let hudNode  = mainHudInputDelegate else {
            print("can't load hud, unexpected behavior in setupHUD")
            return
        }
        cameraNode.addChild(hudNode)
    }
}

// MARK: - Event Handling
extension RaidScene {

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
    func processEvent(_ event: NSEvent,
                      isTapped: Bool){
        let location = event.location(in: self)
        if let tappedNode = nodes(at: location).first as? BaseRaidNode{
            let delegate = tappedNode.inputDelegate
            delegate?.handleNode(tappedNode,
                                 isTapped: isTapped,
                                 state: state,
                                 sceneLocation: location)
        }
    }
#endif
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
        print("mouse up \(state)")

        processEvent(event,isTapped: false)
    }
    func handleMouseDown(with event: NSEvent) {
//        print("mouse down")
//        processEvent(event,isTapped: true)
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
    func handleMouseMoved(with event: NSEvent) {
        //move cam
    }
    func handlePressureChange(with event: NSEvent) {}
    func handleKeyUp(with event: NSEvent) {
        //move action?
    }
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

// MARK: - MainHudOutputDelegateProtocol
extension RaidScene: MainHudOutputDelegateProtocol {
    func handleEvent(_ hudEvent: MainHudButtonType) {
        switch hudEvent {
            case .resume:
                print("resume button tapped")
                self.state = .run
                fieldInputDelegate?.run()
            case .options:
                print("options button tapped")
            case .exit:
                print("exit button tapped")
                fieldInputDelegate?.stop()
                state = .finished
            case .start:
                print("game started")
                fieldInputDelegate?.start()
                self.state = .run
                
            case .settings:
                fieldInputDelegate?.pause()
                state = .paused
        }
    }
}


// MARK: - FieldOutput
extension RaidScene: FieldOutputDelegateProtocol{
    func handleNewState(state: SceneState){
        self.state = state
        print(self.state)
    }
}


