//protocol for objects to get 'game info'
import SpriteKit

protocol RaidDataSource: AnyObject {
    var mapAtlas: SKTextureAtlas { get }
    var contentAtlas: SKTextureAtlas { get }
    var interactiveAtlas: SKTextureAtlas { get }
    var hudAtlas: SKTextureAtlas {get }
 
    func preload(completion: @escaping () -> Void)
}
