import Foundation

protocol RoadBuildingMenuInputDelegateProtocol: AnyObject, NodeTappedHandlable, ShowableProtocol,HidableProtocol{
    var roadBuildingMenuOutputDelegate: RoadBuildingMenuOutputDelegateProtocol? {get set}
    func show(_ inPosition: CGPoint)
    func hide()
}
