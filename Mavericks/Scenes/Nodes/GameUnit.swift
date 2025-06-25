//
//  Created by Миляев Максим on 10.03.2025.
//

import SpriteKit

class GameUnit: SKSpriteNode{
    weak var parentUnit: UnitModel?
    
    init(texture: SKTexture? = nil,
         size: CGSize = .zero,parentUnit: UnitModel? = nil) {
        self.parentUnit = parentUnit
        super.init(texture: texture, color: .clear, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    
}


