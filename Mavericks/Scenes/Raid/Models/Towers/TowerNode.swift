import SpriteKit

class BaseTowerNode: BaseRaidNode{
    
    let parentUnit: TowerModel
    
    // MARK: Init
    init(texture: SKTexture? = nil,
         size: CGSize = .zero,
         parentUnit: TowerModel,
         inputDelegate: NodeTappedHandlable?) {
        self.parentUnit = parentUnit
        
        super.init(type:.tower,
                   inputDelegate: inputDelegate,
                   texture: texture,
                   color: .clear,
                   size: size)
        self.name = NodeNames.tower.rawValue
    }
    init(color: NSColor,
         size: CGSize,
         parentUnit: TowerModel,
         inputDelegate: NodeTappedHandlable?){
        self.parentUnit = parentUnit
        super.init(type: .tower,
                   inputDelegate: inputDelegate,
                   texture: nil,
                   color: color,
                   size: size)
        self.name = NodeNames.tower.rawValue
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit{
        print("tower node deinit")
    }
}
