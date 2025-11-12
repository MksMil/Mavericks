import SpriteKit
import GameplayKit
import Foundation

//all child nodes must have show() hide() with animations

class HudNode: SKNode{
    let bank: RaidDataSource
    
    weak var mainHudOutputDelegate: MainHudOutputDelegateProtocol?
    
    var settingsMenuInputDelegate: SettingsMenuInputDelegateProtocol?
    
    var bottomPanel = SKNode()

    init(withCameraSize camSize: CGSize,
         bank: RaidDataSource) {
        self.bank = bank
        
        let pauseMenu = PauseMenuNode(sceneSize: camSize,
                                  bank: bank)
        settingsMenuInputDelegate = pauseMenu
        super.init()
        settingsMenuInputDelegate?.settingsMenuOutputDelegate = self
        zPosition = 100
        position = CGPoint(x: -camSize.width / 2,
                           y: -camSize.height / 2)
        addChild(pauseMenu)
        
        let upperBG = BaseRaidNode(type: .hud,
                                   inputDelegate: nil,
                                   color: NSColor.white)
        upperBG.size = CGSize(width: camSize.width,
                              height: 80)
        upperBG.position = CGPoint(x: camSize.width / 2,
                                   y: camSize.height - 40)
        upperBG.name = NodeNames.bg.rawValue
        upperBG.alpha = 0.7
        addChild(upperBG)

        //start
        let startButton = HudButton(
            type: .hud,
            inputDelegate: self,
            texture: bank.hudTextures[4],
            position: CGPoint(x: camSize.width / 2 ,
                              y: camSize.height - 40))
        startButton.name = NodeNames.start.rawValue
        addChild(startButton)
        
        //settings
        let settingsButton = HudButton(
            type: .hud,
            inputDelegate: self,
            texture: bank.hudTextures[6],
            position: CGPoint(x: camSize.width - 40,
                              y: camSize.height - 40))
        settingsButton.name = NodeNames.settings.rawValue
        addChild(settingsButton)
        
    }
    func removeStartButton(){
        let startNode = childNode(withName: NodeNames.start.rawValue)
        startNode?.removeFromParent()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("hud deinit")
    }
    func showInfo(contentOwner: any Informable) {
        
     }
    
    func start(){
        removeStartButton()
    }
}

extension HudNode: MainHudInputDelegateProtocol{
    
    func handleNode(_ node: BaseRaidNode,
                    isTapped: Bool,
                    state: SceneState,
                    sceneLocation: CGPoint) {
            //TODO: node animation
//        print("\(node.name)")
            var type: MainHudButtonType = .resume
            if let name = node.name{
                if name == NodeNames.resume.rawValue{
                    type = .resume
                } else if name == NodeNames.options.rawValue{
                    type = .options
                } else if name == NodeNames.start.rawValue{
                    type = .start
                    start()
                } else if name == NodeNames.settings.rawValue{
                    type = .settings
                    settingsMenuInputDelegate?.show()
                    print("settings tapped")
                }
            }
            mainHudOutputDelegate?.handleEvent(type)
    }
    
    
}

// MARK: - SettigsMenuOutputDelegate
extension HudNode: SettingsMenuOutputDelegateProtocol{
    func handleEvent(_ hudEvent: MainHudButtonType) {
        mainHudOutputDelegate?.handleEvent(hudEvent)
        
    }
}





