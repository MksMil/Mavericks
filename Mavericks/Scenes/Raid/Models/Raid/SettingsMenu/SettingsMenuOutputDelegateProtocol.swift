
protocol SettingsMenuOutputDelegateProtocol: AnyObject{
    var settingsMenuInputDelegate: SettingsMenuInputDelegateProtocol? { get set}
    func handleEvent(_ hudEvent: MainHudButtonType)
}
