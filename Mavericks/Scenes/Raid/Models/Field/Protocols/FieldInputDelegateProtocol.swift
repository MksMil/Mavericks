
protocol FieldInputDelegateProtocol: AnyObject, NodeTappedHandlable {
    var fieldOutputDelegate: FieldOutputDelegateProtocol? {get set}
    func start()
    func pause()
    func run()
    func stop()
}
