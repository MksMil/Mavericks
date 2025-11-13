
protocol TowerModifyMenuInputDelegateProtocol: AnyObject, NodeTappedHandlable, ShowableProtocol,HidableProtocol{
    var towerModifyMenuOutputDelegate: TowerModifyMenuOutputDelegateProtocol? {get set}
    
    
}
