import SpriteKit

class FieldBuildingMenuNode: BaseRaidNode {
    weak var fieldBuildingMenuOutputDelegate: FieldBuildingMenuOutputDelegateProtocol?
    let bank: RaidDataSource
    let iconSize: CGSize
    
    let towers:[TowerType] // towers available to build
    
    let arrowNode: HudButton
    let poisonNode: HudButton
    let fireNode: HudButton
    let frostNode: HudButton
    let electroNode: HudButton
    let stunNode: HudButton
    
    // player towers available info -> setupMenu with this towers
    init(towers: [TowerType],iconSize: CGSize,bank: RaidDataSource) {
        self.iconSize = iconSize
        self.bank = bank
        self.towers = towers
        let towerTextures = [
            bank.interactiveAtlas.textureNamed("arrowTower"),
            bank.interactiveAtlas.textureNamed("poisonTower"),
            bank.interactiveAtlas.textureNamed("fireTower"),
            bank.interactiveAtlas.textureNamed("frostTower"),
            bank.interactiveAtlas.textureNamed("electroTower"),
            bank.interactiveAtlas.textureNamed("stunTower")
        ]
        
        self.arrowNode = HudButton(type: .hud,
                                   inputDelegate: nil,
                                   texture: towerTextures[0])
        self.arrowNode.name = NodeNames.arrow.rawValue
        self.poisonNode = HudButton(type: .hud,
                                    inputDelegate: nil,
                                    texture: towerTextures[1])
        self.poisonNode.name = NodeNames.poison.rawValue
        self.fireNode = HudButton(type: .hud,
                                  inputDelegate: nil,
                                  texture: towerTextures[2])
        self.fireNode.name = NodeNames.fire.rawValue
        self.frostNode = HudButton(type: .hud,
                                   inputDelegate: nil,
                                   texture: towerTextures[3])
        self.frostNode.name = NodeNames.frost.rawValue
        self.electroNode = HudButton(type: .hud,
                                     inputDelegate: nil,
                                     texture: towerTextures[4])
        self.electroNode.name = NodeNames.electro.rawValue
        self.stunNode = HudButton(type: .hud,
                                  inputDelegate: nil,
                                  texture: towerTextures[5])
        self.stunNode.name = NodeNames.stun.rawValue
        super.init(type: .hud,
                   inputDelegate: nil)

        zPosition = 100
        xScale = 0
        yScale = 0
        setupMenu(towers: towers)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMenu(towers: [TowerType],rad: CGFloat = .zero){
        guard !towers.isEmpty else { return }
        var towerNodes = towers.map{towerNodeWithType($0)}
        let radius: CGFloat = rad == .zero ? iconSize.width : rad
       
        //temp cancel texture
        let cancelButton = HudButton(type: .hud,
                                     inputDelegate: nil,
                                     texture: bank.hudAtlas.textureNamed("cancelHUDButton"))
        cancelButton.name = NodeNames.cancel.rawValue
        towerNodes.insert(cancelButton, at: 0)
        towerNodes.forEach{$0.size = iconSize}
        let startAngle = 3 * CGFloat.pi / 2.0
        
        let angleStep = 2 * CGFloat.pi / CGFloat(towerNodes.count)
        for index in (0..<towerNodes.count) {
            let angle = startAngle + CGFloat(index) * angleStep
            let x = radius * cos(angle)
            let y = radius * sin(angle)
            addChild(towerNodes[index])
            towerNodes[index].inputDelegate = self
            towerNodes[index].position = CGPoint(x: x, y: y)
            
        }
    }
}

// MARK: - Helper
extension FieldBuildingMenuNode {
    func towerNodeWithType(_ type: TowerType) -> HudButton{
        switch type {
            case .arrow:
                return arrowNode
            case .poison:
                return poisonNode
            case .frost:
                return frostNode
            case .electro:
                return electroNode
            case .fire:
                return fireNode
            case .stun:
                return stunNode
        }
    }
}

// MARK: - TowerBuildMenuInputDelegate
extension FieldBuildingMenuNode: FieldBuildingMenuInputDelegateProtocol{
    func handleNode(_ tappedNode: BaseRaidNode,
                    isTapEnded: Bool,
                    state: SceneState,
                    sceneLocation: CGPoint) {
        if !isTapEnded{
            if let name = tappedNode.name{
                if NodeNames.towers.contains(name){
                    if let type = TowerType(rawValue: name){
                        fieldBuildingMenuOutputDelegate?.handleNewTower(new: type)
                    } else {
                        print("error tower type")
                    }
                    
                } else if name == NodeNames.cancel.rawValue{
                    hide()
                    fieldBuildingMenuOutputDelegate?.cancel()
                }
            }
        }
    }
    
    func show(_ inPosition: CGPoint) {
        isHidden = false
        self.position = inPosition
        run(SKAction.scale(to: 1, duration: 0.1))
    }
    
    func hide() {
        run(SKAction.scale(to: 0, duration: 0.1)){
            self.isHidden = true
        }
    }
}
