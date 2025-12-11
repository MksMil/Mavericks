
import GameplayKit

class CustomGridNode: GKGridGraphNode {
    var isEdge: Bool = false
    
    override func cost(to node: GKGraphNode) -> Float {
        // предпочтительно чтобы монстры шли по центру дороги - хотя бы на расстоянии 1й ячейки от края дороги
        return isEdge ? 4 : 1
    }
}
