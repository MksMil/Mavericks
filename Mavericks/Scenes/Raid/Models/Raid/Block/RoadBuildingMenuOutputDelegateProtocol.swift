
protocol RoadBuildingMenuOutputDelegateProtocol: AnyObject {
    var roadBuildingMenuInputDelegate: RoadBuildingMenuInputDelegateProtocol? { get set}
    func handleNewRoadBuilding(new: RoadBuildingType)
    func cancel()
    
}
