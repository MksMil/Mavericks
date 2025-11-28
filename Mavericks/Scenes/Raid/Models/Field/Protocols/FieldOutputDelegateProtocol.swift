
protocol FieldOutputDelegateProtocol: AnyObject {
    var fieldInputDelegate: FieldInputDelegateProtocol? {get set}
    func handleNewState(state: SceneState)
    func baseTakeDamage(damage: Int)
}
