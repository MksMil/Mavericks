
protocol MainHudOutputDelegateProtocol: AnyObject{
    var mainHudInputDelegate: MainHudInputDelegateProtocol? { get set}
    func handleEvent(_ hudEvent: MainHudButtonType)
}
