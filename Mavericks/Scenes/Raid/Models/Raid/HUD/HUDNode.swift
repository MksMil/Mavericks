import SpriteKit
import GameplayKit
import Foundation

//all child nodes must have show() hide() with animations

//enum HudState {
//    case pause, run, finishRaid
//}

class HudNode: SKNode, RaidDataInformer{
    weak var outputDelegate: RaidScene?
    
    let bank: RaidDataSource
//    weak var controlInputDelegate: ControlInputDelegate?
    
    var mainHUD: RaidMainHUD
    //protocol !
    var bottomPanel = SKNode()
    
    var towerMenu: TowersMenuNode
    //protocol !
    var upgradeTowerMenu = SKNode()
    //protocol !
    var roadMenu = SKNode()
    //protocol !
    var upgradeBlockMenu = SKNode()
    //protocol !
    var pauseMenu: PauseMenuNode
    /*
     states:
        - pause Menu
        - tower build Menu
        - tower sell/upgrade Menu
        - block/trap build Menu
        - block/trap sell/upgrade Menu
        - unit info Menu
        - resource info Menu
        - Hero Menu
        - Quest / Dialog Menu
        - empty State
     */
//    var stateMachine: GKStateMachine?
    
    var size: CGSize
    
    init(withCameraSize size: CGSize,
         bank: RaidDataSource) {
        self.size = size
        self.bank = bank
        
        towerMenu = TowersMenuNode(iconSize: CGSize(width: 64,
                                                    height: 64),
                                   bank: bank)
        mainHUD = RaidMainHUD(bank: bank,
                          camSize: size)
        pauseMenu = PauseMenuNode(sceneSize: size,
                                  bank: bank)
        super.init()
        
        position = CGPoint(x: -size.width / 2,
                           y: -size.height / 2)
        setup()
//        pauseMenu.outputDelegate = self
        addChild(pauseMenu)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("hud deinit")
    }
    
//    func changeState(newState: HudState){
////        self.state = newState
//        switch newState {
//            case .pause:
////                controlInputDelegate = pauseMenu
////                outputDelegate?.changeState(newState: .pauseMenu)
//                showPauseMenu()
//            case .run:
////                outputDelegate?.changeState(newState: .raid)
//                hidePauseMenu()
//                print("runned")
//            case .finishRaid:
//                print("hud finished")
//                hidePauseMenu()
////                pauseMenu.outputDelegate = nil
////                outputDelegate?.changeState(newState: .finish)
//           @unknown default: break
//        }
//    }
    
    func showMenu(inPosition: CGPoint) {
        towerMenu.position = inPosition
        addChild(towerMenu)
    }
    
    func hideMenu() {
        towerMenu.removeFromParent()
    }
    /*
        pause / menu settings
        resourse counter
        timer
        info
     */
    
    func setup(){
        zPosition = 100
        let pauseButton = HudButton(type: .hud, texture: SKTexture(imageNamed: "pause"))
        pauseButton.position = CGPoint(x: size.width / 2,
                                            y: size.height - 30)
        pauseButton.name = NodeNames.pause.rawValue
        addChild(pauseButton)
    }
    
  
    func showPauseMenu(){
        pauseMenu.show()        //alpha - 0
        // + animation
    }
    func hidePauseMenu(){
        pauseMenu.hide()
    }
    
    func showInfo(contentOwner: any Informable) {
        
     }
}






