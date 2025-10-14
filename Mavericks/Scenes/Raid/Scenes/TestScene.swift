//
//  TestScene.swift
//  Mavericks
//
//  Created by Миляев Максим on 06.10.2025.
//


import SpriteKit

class TestScene: SKScene, RootScene {
    
    
    weak var mainViewDelegate: (any MainViewDelegateProtocol)?
    
    private var monsterSprite: SKSpriteNode?
    private var headOffsetLabel: SKLabelNode?
    private var leftLegOffsetLabel: SKLabelNode?
    private var headRotationLabel: SKLabelNode?
    private var leftLegRotationLabel: SKLabelNode?
    
    
    // Настройка камеры
    private func setupCamera() {
        let cameraNode = SKCameraNode()
        cameraNode.name = "cameraNode"
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width / 2,
                                    y: size.height / 2)
        camera?.setScale(0.5)
//        print(size)
        
        addChild(cameraNode)
//        cameraNode.position = CGPoint(x: cellSize * CGFloat(gridWidth) / 2, y: cellSize * CGFloat(gridHeight) / 2)
//        
//        let newScale = max(CGFloat(gridWidth) * cellSize / size.width,(CGFloat(gridHeight) * cellSize)/size.height)
//        cameraNode.setScale(newScale)
    }
    
    override func didMove(to view: SKView) {
        // Загружаем текстуры из атласа
        super.didMove(to: view)
        size = view.frame.size
        scaleMode = .aspectFill
        backgroundColor = .gray
        view.showsFPS = true
        view.showsNodeCount = true
        view.showsDrawCount = true
        view.showsFields = true
        setupCamera()
        
        let atlas = SKTextureAtlas(named: "Monster")
                
        let headTexture = atlas.textureNamed("monster_head")
        let bodyTexture = atlas.textureNamed("monster_body")
        let leftLegTexture = atlas.textureNamed("monster_left_leg")
        let rightLegTexture = atlas.textureNamed("monster_right_leg")
        let leftArmTexture = atlas.textureNamed("monster_left_arm")
        let rightArmTexture = atlas.textureNamed("monster_right_arm")
        
        let cmbTextures = TextureFactory.makeSequence(
            headTexture: headTexture,
            bodyTexture: bodyTexture,
            leftArmTexture: leftArmTexture,
            rightArmTexture: rightArmTexture,
            leftLegTexture: leftLegTexture,
            rightLegTexture: rightLegTexture,
            angle: CGFloat.pi / 8
        )
        let lightNode = SKLightNode()
        lightNode.position = CGPoint(x: size.width / 2, y: size.height / 2 )
        lightNode.categoryBitMask = 0b0001
//        lightNode.lightColor = .white.withAlphaComponent(1)
        lightNode.ambientColor = .white.withAlphaComponent(0.1)
//        lightNode.shadowColor = .black.withAlphaComponent(0.1)
        lightNode.falloff = 0.5
        lightNode.zPosition = 20
        addChild(lightNode)
        
        // Инициализируем базовую текстуру с начальными трансформациями
        if let combinedTexture = TextureFactory.combineTextures(headTexture: headTexture,
                                                                bodyTexture: bodyTexture,
                                                                leftArmTexture: leftArmTexture,
                                                                rightArmTexture: rightArmTexture,
                                                                leftLegTexture: leftLegTexture,
                                                                rightLegTexture: rightLegTexture,
//                                                                leftLegOffset: CGPoint(x: -20, y: -10),
//                                                                leftLegRotation: .pi / 6,
//                                                                rightLegOffset: CGPoint(x: 20, y: -10),
//                                                                rightLegRotation: -.pi/6
        ) {
            monsterSprite = SKSpriteNode(texture: combinedTexture)
            monsterSprite?.position = CGPoint(x: size.width / 2, y: size.height / 2)
            addChild(monsterSprite!)
        } else {
            print("texture - nil")
        }
        
        
        for i in 0..<cmbTextures.count{
            let node = SKSpriteNode(texture: cmbTextures[i].generatingNormalMap())
            node.position = CGPoint(x: size.width / 2 - 200 + CGFloat(i * 70), y: size.height / 2 + 100)
            addChild(node)
        }
        let node = SKSpriteNode(texture: cmbTextures[0])
        node.lightingBitMask = 0b0001
        node.shadowedBitMask = 0b0001
//        node.shadowCastBitMask = 0b0001
        let normaltxt = cmbTextures.map{$0.generatingNormalMap()}
        node.normalTexture = normaltxt[0]
        node.position = CGPoint(x: size.width / 2, y: size.height / 2 - 100)
        
        
        addChild(node)
        node.run(SKAction.repeatForever(
            SKAction.group([SKAction.animate(with: cmbTextures, timePerFrame: 0.1,resize: true, restore: false),
                            SKAction.animate(withNormalTextures: normaltxt,
                                             timePerFrame: 0.1,resize: true,restore: false)])))
        

    }
    

}


//MARK: - handle events
extension TestScene {
    func handleScrollWheel(with event: NSEvent) {
        
    }
    
    func handleMagnify(with event: NSEvent) {
        
    }
    
    func handleRotate(with event: NSEvent) {
        
    }
    
    func handleMouseDown(with event: NSEvent) {
        
//        guard let touch = touches.first else { return }
//        let location = event.location(in: self)
        
//        if let node = nodes(at: location).first?.parent as? SKShapeNode {
//            switch node.name {
//            case "headOffsetArea":
//                updateHeadOffset()
//            case "headRotationArea":
//                updateHeadRotation()
//            case "leftLegOffsetArea":
//                updateLeftLegOffset()
//            case "leftLegRotationArea":
//                updateLeftLegRotation()
//            default:
//                break
//            }
//        }
    }
    
    func handleMouseUp(with event: NSEvent) {
        
    }
    
    func handleMouseMoved(with event: NSEvent) {
        
    }
    
    func handlePressureChange(with event: NSEvent) {
        
    }
    
    func handleKeyUp(with event: NSEvent) {
        
    }
    
    func handleKeyDown(with event: NSEvent) {
        
    }
}

