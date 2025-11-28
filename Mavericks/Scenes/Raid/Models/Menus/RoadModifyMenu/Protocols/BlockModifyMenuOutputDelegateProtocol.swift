

protocol BlockModifyMenuOutputDelegateProtocol: AnyObject{
    var blockModifyMenuInputDelegate: BlockModifyMenuInputDelegateProtocol? { get set}
    func handleBlockModifySellEvent()
    func handleBlockModifyUpgradeEvent()
    func cancel()
}
