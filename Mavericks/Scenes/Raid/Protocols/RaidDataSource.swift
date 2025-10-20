//protocol for objects to get 'game info'
import SpriteKit

protocol RaidDataSource: AnyObject {
    var moveRightTextures:[SKTexture] {get set}
    var moveUpTextures:[SKTexture] {get set}
    var moveDownTextures:[SKTexture] {get set}
    
    var towerTextures: [SKTexture] {get set}
    
    var hudTextures: [SKTexture] {get set}
    var towerMenuTextures: [SKTexture] {get set}
    var upgradeSellTextures: [SKTexture] {get set}
    var fieldTextures: [SKTexture] {get set}
    var pauseMenuTextures: [SKTexture] {get set}
    
    
}
