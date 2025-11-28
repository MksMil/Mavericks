
protocol SettingsMenuInputDelegateProtocol: AnyObject,NodeTappedHandlable{
    var settingsMenuOutputDelegate: SettingsMenuOutputDelegateProtocol? { get set}
    func show()
    func hide()
}
