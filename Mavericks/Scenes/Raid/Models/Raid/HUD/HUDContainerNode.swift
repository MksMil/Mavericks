import SpriteKit
import GameplayKit
import Foundation

//menu types
// add block / trap
// add tower
// upgrade / sell block
// upgrade / sell tower

// show info
class HudNode: SKNode, RaidDataInformer{
    weak var controlDelegate: ControlInputDelegate?
    weak var bank: RaidDataSource?
    
    var topPanel = SKNode()
    var bottomPanel = SKNode()
    
    var towerMenu = SKNode()
    var upgradeTowerMenu = SKNode()

    var roadMenu = SKNode()
    var upgradeBlockMenu = SKNode()

    var pauseMenu = SKNode()
    
    var stateMachine: GKStateMachine?
    
    var size: CGSize
    
    init(withCameraSize size: CGSize, bank: RaidDataSource?) {
        self.size = size
        print("camera size: \(size)")
        self.bank = bank
        super.init()
        position = CGPoint(x: -size.width / 2,
                           y: -size.height / 2)
        isUserInteractionEnabled = true
        
        makeTowersMenu()
        setupMenuNode()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupStateMachine(){
        stateMachine = GKStateMachine(states: [])
    }
    
    func makeTowersMenu(){
        guard let towerTextures = bank?.towerMenuTextures else {
        print("cant load hud textures. bank: \(bank != nil)")
            return
        }
        //TODO: availlable towers from player info, make a single node aka TowerMenuNode, with inputDelegate
        //add some bg
        
        let arrowNode = HudButton(texture: towerTextures[0])
        arrowNode.name = NodeNames.arrow.rawValue
        let poisonwNode = HudButton(texture: towerTextures[1])
        poisonwNode.name = NodeNames.poison.rawValue
        let fireNode = HudButton(texture: towerTextures[2])
        fireNode.name = NodeNames.fire.rawValue
        let frostNode = HudButton(texture: towerTextures[3])
        frostNode.name = NodeNames.frost.rawValue
        let electroNode = HudButton(texture: towerTextures[4])
        electroNode.name = NodeNames.electro.rawValue
        let stunNode = HudButton(texture: towerTextures[5])
        stunNode.name = NodeNames.stun.rawValue
        
        let r = arrowNode.size.width
        let kSin: CGFloat = sqrt(3.0) / 2.0
        let kCos: CGFloat = 1 / 2.0
        
        //radial positions
        //180
        arrowNode.position = CGPoint(x: -r ,
                                     y: 0)
        //120
        poisonwNode.position = CGPoint(x: -r * kCos,
                                       y: r * kSin )
        //60
        fireNode.position = CGPoint(x: r * kCos,
                                    y: r * kSin )
        //0
        frostNode.position = CGPoint(x: r ,
                                    y: 0)
        //-60
        electroNode.position = CGPoint(x: r * kCos,
                                       y: -r * kSin)
        //-120
        stunNode.position = CGPoint(x: -r * kCos,
                                    y: -r * kSin)
        
        towerMenu.addChild(arrowNode)
        towerMenu.addChild(poisonwNode)
        towerMenu.addChild(fireNode)
        towerMenu.addChild(frostNode)
        towerMenu.addChild(electroNode)
        towerMenu.addChild(stunNode)
    }
    
    func showMenu(inPosition: CGPoint) {
        towerMenu.position = inPosition
        print("menu showed in position: \(inPosition)")
        print(size)
        print(towerMenu.debugDescription)
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
       
        let pauseButton = HudButton()
        
        pauseButton.setup(withName: "pause",
                          size: CGSize(width: 50, height: 50),
                          position: CGPoint(x: size.width / 2,
                                            y: size.height - 30))
        pauseButton.changeState()
        pauseButton.name = NodeNames.pause.rawValue
        print(frame)
        print(pauseButton.position)
        addChild(pauseButton)
    }
    
    func setupMenuNode(){
        guard let menuTextures = bank?.pauseMenuTextures else {
            print("cant load menu textures")
            return
        }
        let globalBgNode = SKSpriteNode(color: NSColor.black,
                                  size: size)
        globalBgNode.position = CGPoint(x: size.width / 2,
                                  y: size.height / 2)
        globalBgNode.alpha = 0.3
        
        pauseMenu.addChild(globalBgNode)
        let menuBgNode = SKSpriteNode(color: NSColor.white,
                                      size: CGSize(width: 200,
                                                   height: 300))
        menuBgNode.position = CGPoint(x: size.width / 2,
                                      y: size.height / 2)
        menuBgNode.alpha = 0.7
        pauseMenu.addChild(menuBgNode)
        for i in 0 ..< menuTextures.count{
            let buttonNode = HudButton(texture: menuTextures[i])
//            SKSpriteNode(texture: menuTextures[i])
            switch i {
                case 0:
                    buttonNode.name = NodeNames.resume.rawValue
                case 1:
                    buttonNode.name = NodeNames.restart.rawValue
                case 2:
                    buttonNode.name = NodeNames.options.rawValue
                case 3:
                    buttonNode.name = NodeNames.exit.rawValue
                    
                default:
                    buttonNode.name = NodeNames.empty.rawValue
            }
            buttonNode.isUserInteractionEnabled = true
            buttonNode.position = CGPoint(x: Int(size.width) / 2,
                                          y: Int(size.height) - 350 - (i * 64))
            pauseMenu.addChild(buttonNode)
        }
    }
    func showPauseMenu(){
        addChild(pauseMenu)
    }
    func hidePauseMenu(){
        pauseMenu.removeFromParent()
    }
    
    
    func showInfo(contentOwner: any Informable) {
        
     }
}





