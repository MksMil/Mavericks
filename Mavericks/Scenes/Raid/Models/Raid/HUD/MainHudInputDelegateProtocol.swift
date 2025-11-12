import SpriteKit

protocol MainHudInputDelegateProtocol: SKNode, NodeTappedHandlable{
    var mainHudOutputDelegate: MainHudOutputDelegateProtocol? {get set}
}
