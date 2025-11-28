//
//  BaseRaidNode.swift
//  Mavericks
//
//  Created by Миляев Максим on 05.11.2025.
//

import SpriteKit

enum BaseRaidNodeType {
    case field // tower build menu
    case tower // tower upgrade
    case road // block build
    case block // block upgrade
    case monster // monster info
    case hero // hero
    case quest // quest
    case hud //
    case base // base info/actions
    case spawn // monster spawn
    case resorses // resourses info/actions
    case empty
}

enum InputDelegateType{
    case mainHudInputDelegate
    case settingsMenuInputDelegate
    case fieldInputDelegate
    case towerBuildMenuInputDelegate, towerModifyMenuInputDelegate
    case blockBuildMenuInputDelegate, blockModifyMenuInputDelegate
    
    case none
}

class BaseRaidNode: SKSpriteNode {
    var type: BaseRaidNodeType
    var infoSource: Informable?
    var inputDelegate: NodeTappedHandlable? //handle this node touches
    init(type: BaseRaidNodeType,
         inputDelegate: NodeTappedHandlable?,
         infoSource: Informable? = nil,
         texture: SKTexture? = nil,
         color: NSColor = .clear,
         size: CGSize = .zero) {
        self.type = type
        self.inputDelegate = inputDelegate
        self.infoSource = infoSource
        var newsize = size
        if let texture, size == .zero {
            newsize = texture.size()
        }
        super.init(texture: texture, color: color, size: newsize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
