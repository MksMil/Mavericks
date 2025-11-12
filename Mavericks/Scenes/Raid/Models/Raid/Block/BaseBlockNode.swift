import SpriteKit

class BaseBlockNode: BaseRaidNode{
    
    let parentUnit: BlockModel
    
    // MARK: Init
    init(texture: SKTexture? = nil,
         size: CGSize = .zero,
         parentUnit: BlockModel,
         inputDelegate: NodeTappedHandlable?) {
        self.parentUnit = parentUnit
        
        super.init(type:.block,
                   inputDelegate: inputDelegate,
                   texture: texture,
                   color: .clear,
                   size: size)
        self.name = NodeNames.block.rawValue
    }
    init(color: NSColor,
         size: CGSize,
         parentUnit: BlockModel,
         inputDelegate: NodeTappedHandlable?){
        self.parentUnit = parentUnit
        super.init(type: .block,
                   inputDelegate: inputDelegate,
                   texture: nil,
                   color: color,
                   size: size)
        self.name = NodeNames.block.rawValue
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit{
        print("block node deinit")
    }
}
