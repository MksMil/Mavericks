import SpriteKit

protocol RootScene: SKScene, ControlInputDelegate{
    var mainViewDelegate: MainViewDelegateProtocol? {get set}
}


