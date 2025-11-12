
protocol FieldBuildingMenuInputDelegateProtocol: AnyObject, NodeTappedHandlable, ShowableProtocol,HidableProtocol{
    var fieldBuildingMenuOutputDelegate:FieldBuildingMenuOutputDelegateProtocol? {get set}
}
