import SpriteKit

protocol RootScene:  ControlInputDelegate{
    var mainViewDelegate: MainViewDelegateProtocol? {get set}
}


