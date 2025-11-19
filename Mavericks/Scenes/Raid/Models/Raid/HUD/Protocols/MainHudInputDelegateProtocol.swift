import SpriteKit

protocol MainHudInputDelegateProtocol: SKNode, NodeTappedHandlable{
    var mainHudOutputDelegate: MainHudOutputDelegateProtocol? {get set}
    func showInfo(text: String)
}
