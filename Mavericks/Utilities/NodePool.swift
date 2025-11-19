
import SpriteKit

class NodePool<T: SKNode> {
    private var pool: [T] = []
    private let factory: () -> T
    
    init(size: Int, factory: @escaping () -> T) {
        self.factory = factory
        for _ in 0..<size { pool.append(factory()) }
    }
    
    func get() -> T { pool.isEmpty ? factory() : pool.removeLast() }
    func recycle(_ node: T) { pool.append(node) }
}
