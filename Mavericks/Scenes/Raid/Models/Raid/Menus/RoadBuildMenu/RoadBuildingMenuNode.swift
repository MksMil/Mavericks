import SpriteKit

enum RoadBuildingType: String, CaseIterable {
    case block
    case trap
}

class RoadBuildingMenuNode: BaseRaidNode {
    weak var roadBuildingMenuOutputDelegate: RoadBuildingMenuOutputDelegateProtocol?
    
    let bank: RaidDataSource
    let iconSize: CGSize
    
    let buildings:[RoadBuildingType] // towers available to build
    
    let baseBlockButton: HudButton
    let trapButton: HudButton

    
    // player road buildings available info -> setupMenu with this buildings
    init(buildings: [RoadBuildingType],
         iconSize: CGSize,
         bank: RaidDataSource) {
        self.iconSize = iconSize
        self.bank = bank
        self.buildings = buildings
        let blockTexture = bank.contentAtlas.textureNamed("block")
        let trapTexture = bank.contentAtlas.textureNamed("trap")
        self.baseBlockButton = HudButton(type: .hud,
                                   inputDelegate: nil,
                                   texture: blockTexture)
        baseBlockButton.name = NodeNames.block.rawValue
        self.trapButton = HudButton(type: .hud,
                                   inputDelegate: nil,
                                   texture: trapTexture)
        trapButton.name = NodeNames.trap.rawValue

        super.init(type: .hud,
                   inputDelegate: nil)
        zPosition = 100
        xScale = 0
        yScale = 0
        setupMenu(buildings: buildings)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMenu(buildings: [RoadBuildingType],
                   rad: CGFloat = .zero){
        guard !buildings.isEmpty else { return }
        var buildingNodes = buildings.map{blockButtonNodeWithType($0)}
        buildingNodes.forEach{$0.size = iconSize}
        let radius: CGFloat = rad == .zero ? iconSize.width : rad
       
        //temp cancel texture
        let cancelButton = HudButton(type: .hud,
                                     inputDelegate: self,
                                     texture: bank.hudAtlas.textureNamed("cancelHUDButton"))
        cancelButton.name = NodeNames.cancel.rawValue
        
        buildingNodes.insert(cancelButton, at: 0)
        let startAngle = 3 * CGFloat.pi / 2.0
        
        let angleStep = 2 * CGFloat.pi / CGFloat(buildingNodes.count)
        for index in (0..<buildingNodes.count) {
            let angle = startAngle + CGFloat(index) * angleStep
            let x = radius * cos(angle)
            let y = radius * sin(angle)
            addChild(buildingNodes[index])
            buildingNodes[index].inputDelegate = self
            buildingNodes[index].position = CGPoint(x: x, y: y)
        }
    }
}

// MARK: - Helper
extension RoadBuildingMenuNode {
    func blockButtonNodeWithType(_ type: RoadBuildingType) -> HudButton{
        switch type {
            case .block:
                baseBlockButton
            case .trap:
                trapButton
        }
    }
}

// MARK: - TowerBuildMenuInputDelegate
extension RoadBuildingMenuNode: RoadBuildingMenuInputDelegateProtocol{
    
    func handleNode(_ tappedNode: BaseRaidNode,
                    isTapEnded: Bool,
                    state: SceneState,
                    sceneLocation: CGPoint) {
        if !isTapEnded{
            if let name = tappedNode.name{
                if NodeNames.roadBuildings.contains(name){
                    if name == NodeNames.cancel.rawValue{
                        roadBuildingMenuOutputDelegate?.cancel()
                        hide()
                    } else if let type = RoadBuildingType(rawValue: name){
                         roadBuildingMenuOutputDelegate?.handleNewRoadBuilding(new: type)
                         hide()
                     }
                } else {
                    print("error block building type")
                }
            }
        }
    }
    
    func show(_ inPosition: CGPoint) {
        self.position = inPosition
        run(SKAction.scale(to: 1, duration: 0.1))
    }
    
    func hide() {
        print("hide block menu")
        run(SKAction.scale(to: 0, duration: 0.1))
    }
}
