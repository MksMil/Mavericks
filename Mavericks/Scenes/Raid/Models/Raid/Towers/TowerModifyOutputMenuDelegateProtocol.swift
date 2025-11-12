

protocol TowerModifyMenuOutputDelegateProtocol: AnyObject{
    var towerModifyMenuInputDelegate: TowerModifyMenuInputDelegateProtocol? {get set}
    func handleTowerModifySellEvent()
    func handleTowerModifyUpgradeEvent()
    func cancel()
}
