
import Foundation

protocol FieldBuildingMenuOutputDelegateProtocol: AnyObject{
    var fieldBuildingMenuInputDelegate: FieldBuildingMenuInputDelegateProtocol? {get set}
    func handleNewTower(new: TowerType)
    func cancel()
}
