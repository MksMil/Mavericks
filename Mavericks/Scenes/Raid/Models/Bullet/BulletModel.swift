import GameplayKit



class BulletModel: GKEntity {
    let field: BulletShotigAvailableProtocol
    let bank: RaidDataSource
    var speed: CGFloat = 0.5 //shot duration
    var node: SKSpriteNode
    
    var tower: TowerModel?
    var target: MonsterModel?
    
    init(field: BulletShotigAvailableProtocol,
        bank: RaidDataSource,
         tower: TowerModel? = nil,
         target: MonsterModel? = nil) {
        self.field = field
        self.bank = bank
        self.tower = tower
        self.target = target
        //TODO: texture and animation configure
        let sprite = SKSpriteNode(color: BulletModel.colorForBullet(type: tower?.type),
                                  size: CGSize(width: 10,height: 10))
        self.node = sprite
        sprite.position = tower?.node?.position ?? .zero
        sprite.zPosition = 100
        sprite.isHidden = true
        field.interactiveNode.addChild(sprite)
        super.init()
    }
    
    //just for test
    static func colorForBullet(type: TowerType?) -> NSColor {
        guard let type else { return .black}
        switch type {
            case .arrow:
                return .white
            case .poison:
                return .green
            case .frost:
                return .blue
            case .electro:
                return .cyan
            case .fire:
                return .red
            case .stun:
                return .brown
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
//        print("bullet mode deinit")
    }
    
    func configureBulletWith(tower: TowerModel,
                             andTarget target: MonsterModel){
        self.tower = tower
        self.target = target
        node.color = BulletModel.colorForBullet(type: tower.type)
        node.position = tower.node?.position ?? .zero
    }
    
    func getEndPosition() -> CGPoint{
        guard  let target
                else { return .zero}
        let node = target.node
        let direction = target.visualDirection
        let targetSpeed = CGFloat(target.currentSpeed)
        
        let xK: CGFloat = direction == .west ? -1 : (direction == .east ? 1 : 0)
        let yK: CGFloat = direction == .south ? -1 : (direction == .north ? 1 : 0)
        
        let endPosition = CGPoint(x: node.position.x + xK * targetSpeed * speed,
                                  y: node.position.y + yK * targetSpeed * speed)
        return endPosition
    }
    func shootOnTarget(){
        guard let tower, let target else { return }
        node.isHidden = false
        let animation = SKAction.move(to: getEndPosition(),
                                      duration: speed)
        let completion = SKAction.run {
            target.applyDamage(from: tower)
            self.node.removeAllActions()
            self.node.isHidden = true
            self.field.finishShootByBullet(self)
        }
        node.run(SKAction.sequence([animation,completion]))
    }
}
