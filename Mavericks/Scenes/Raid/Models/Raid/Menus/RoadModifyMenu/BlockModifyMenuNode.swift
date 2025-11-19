import SpriteKit

class BlockModifyMenuNode: BaseRaidNode {
    
    let bank: RaidDataSource
    let iconSize: CGSize
    
    weak var blockModifyMenuOutputDelegate:  BlockModifyMenuOutputDelegateProtocol?
    
    // player towers available info -> setupMenu with this towers
    init(iconSize: CGSize,
         bank: RaidDataSource) {
        self.iconSize = iconSize
        self.bank = bank
        super.init(type: .hud,
                   inputDelegate: nil)
        zPosition = 100
        xScale = 0
        yScale = 0
        setupMenu(rad: iconSize.width)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("block model deinit")
    }
    
    func processWithTowerModel(tower: TowerModel){
        //change icons and state of menu using model info
    }
    
    func setupMenu(rad: CGFloat = .zero){
        let upgradeButton = HudButton(type: .hud,
                                      inputDelegate: self,
                                      texture: bank.hudAtlas.textureNamed("upgradeMenuButton"))
        upgradeButton.name = NodeNames.blockUpgrade.rawValue
        
        let sellButton = HudButton(type: .hud,
                                   inputDelegate: self,
                                   texture: bank.hudAtlas.textureNamed("sellMenuButton"))
        sellButton.name = NodeNames.blockSell.rawValue
        
        //temp cancel texture
        let cancelButton = HudButton(type: .hud,
                                     inputDelegate: self,
                                     texture: bank.hudAtlas.textureNamed("cancelHUDButton"))
        cancelButton.name = NodeNames.cancel.rawValue
        
        let menuNodes = [cancelButton,upgradeButton,sellButton]
        menuNodes.forEach{$0.size = iconSize}
        
        let startAngle = 3 * CGFloat.pi / 2.0
        let radius: CGFloat = rad == .zero ? iconSize.width : rad
        
        let angleStep = 2 * CGFloat.pi / CGFloat(menuNodes.count)
        for index in (0..<menuNodes.count) {
            let angle = startAngle + CGFloat(index) * angleStep
            let x = radius * cos(angle)
            let y = radius * sin(angle)
            addChild(menuNodes[index])
            menuNodes[index].position = CGPoint(x: x, y: y)
        }
    }
    
    
}

// MARK: - Helper
extension BlockModifyMenuNode {

}

// MARK: - TowerModifyMenuInputDelegate
extension BlockModifyMenuNode: BlockModifyMenuInputDelegateProtocol{
    
    
    func handleNode(_ tappedNode: BaseRaidNode,
                    isTapEnded: Bool,
                    state: SceneState,
                    sceneLocation: CGPoint) {
        print("in block modify handler")
        if !isTapEnded{
            if let name = tappedNode.name{
                if NodeNames.roadBuildingsModify.contains(name){
                        switch name {
                            case NodeNames.cancel.rawValue:
                                //hide menu
                                hide()
                                blockModifyMenuOutputDelegate?.cancel()
                            case NodeNames.blockSell.rawValue:
                                //hide menu
                                hide()
                                blockModifyMenuOutputDelegate?.handleBlockModifySellEvent()
                            case NodeNames.blockUpgrade.rawValue:
                                //do not hide menu?
                                blockModifyMenuOutputDelegate?.handleBlockModifyUpgradeEvent()
                            default: return
                        }
                    } else {
                        print("error menu button type")
                    }
            }
        }
    }
    
    func show(_ inPosition: CGPoint) {
        self.position = inPosition
        run(SKAction.scale(to: 1, duration: 0.1))
    }
    
    func hide() {
        run(SKAction.scale(to: 0, duration: 0.1))
    }
    
    
}
