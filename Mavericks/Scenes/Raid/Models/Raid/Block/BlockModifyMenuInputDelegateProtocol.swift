

protocol BlockModifyMenuInputDelegateProtocol: AnyObject, NodeTappedHandlable, ShowableProtocol,HidableProtocol{
    var blockModifyMenuOutputDelegate: BlockModifyMenuOutputDelegateProtocol? {get set}
}
