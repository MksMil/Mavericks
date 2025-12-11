import SpriteKit

class HealthBarNode: SKNode{
    let source: Damageable
    let size: CGSize
    
    let frameBar: SKSpriteNode
    let bar: SKSpriteNode
    
    var isChanging: Bool = false
    
    init(source: Damageable,size: CGSize) {
        self.source = source
        self.size = size
        let atlas = SKTextureAtlas(named: "interactive")
        let barTexture = atlas.textureNamed("healthBar")
        let frameTexture = atlas.textureNamed("healthBarRect")
        self.frameBar = SKSpriteNode(texture: frameTexture)
        self.bar = SKSpriteNode(texture: barTexture)
        super.init()
        
        addChild(bar)
        bar.zPosition = 1
        bar.anchorPoint = CGPoint(x: 0, y: 0.5)
        addChild(frameBar)
        frameBar.position = CGPoint(x: size.width / 2,
                                    y: 0)
        frameBar.zPosition = 2
    }
    
    func changeHealth(){
        let current = source.currentHealth
        let base = source.maxHealth
        let scaleFactor: CGFloat = CGFloat(current) / CGFloat(base)
        if !isChanging {
            isChanging = true
            bar.run(SKAction.scaleX(to: scaleFactor, duration: 0.1)){
                self.isChanging = false
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
