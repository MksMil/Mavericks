import SpriteKit

class TowersMenuNode: SKNode {
    
    let bank: RaidDataSource
    let iconSize: CGSize
    
    // player towers available info -> setupMenu with this towers
    init(iconSize: CGSize,bank: RaidDataSource) {
        self.iconSize = iconSize
        self.bank = bank
        super.init()
        testSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //for test
    func testSetup(){
         let towerTextures = bank.towerMenuTextures
        //TODO: availlable towers from player info, make a single node aka TowerMenuNode, with inputDelegate
        //add some bg
        
        let arrowNode = HudButton(type: .hud, texture: towerTextures[0])
        arrowNode.name = NodeNames.arrow.rawValue
        let poisonwNode = HudButton(type: .hud, texture: towerTextures[1])
        poisonwNode.name = NodeNames.poison.rawValue
        let fireNode = HudButton(type: .hud, texture: towerTextures[2])
        fireNode.name = NodeNames.fire.rawValue
        let frostNode = HudButton(type: .hud, texture: towerTextures[3])
        frostNode.name = NodeNames.frost.rawValue
        let electroNode = HudButton(type: .hud, texture: towerTextures[4])
        electroNode.name = NodeNames.electro.rawValue
        let stunNode = HudButton(type: .hud, texture: towerTextures[5])
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
        
        addChild(arrowNode)
        addChild(poisonwNode)
        addChild(fireNode)
        addChild(frostNode)
        addChild(electroNode)
        addChild(stunNode)

        setScale(1 / 2)
    }
    
    override func mouseDown(with event: NSEvent) {
        print("menu node tapped")
    }
}
