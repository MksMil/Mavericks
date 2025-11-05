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
}

class BaseRaidNode: SKSpriteNode {
    let type: BaseRaidNodeType
    init(type: BaseRaidNodeType, texture: SKTexture? = nil, color: NSColor = .clear, size: CGSize) {
            self.type = type
            super.init(texture: texture, color: color, size: size)
        }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
