//
//  LevelScene.swift
//  Mavericks
//
//  Created by Миляев Максим on 24.06.2025.
//

import GameplayKit
import SpriteKit
import SwiftUI

class LevelScene: SKScene {
    weak var mainViewDelegate: MainViewDelegateProtocol?
    
    enum LevelScneState {
        case paused, playing
    }

    var entities = [GKEntity]()
    var graphs = [String: GKGraph]()

    let physicDelegate = PhysicDetector()

    //for test
//    var unit = UnitModel()

    // last update scene time
    var lastUpdateTime: TimeInterval = 0

    // delta between lastUpdate
    var dt: TimeInterval = 0

    var sceneState: LevelScneState = .playing

//    var bgNode: DungeonBackgroundNode = DungeonBackgroundNode()

    var levelSize: CGSize {
        CGSize(width: size.width, height: size.height)
    }
    var cameraScaleFactor: CGFloat = 1
    var cameraSize: CGSize = .zero

    //// MARK: - Init
    //        convenience init?(fileNamed: String) {
    //            guard let scene = SKScene(fileNamed: fileNamed) else { return nil }
    //            self.init(size: scene.size)
    //            scene.children.forEach({
    //                $0.removeFromParent()
    //                addChild($0)
    //            })
    //        }
    //        override init(size: CGSize) {
    //            super.init(size: size)
    //        }
    //        required init?(coder aDecoder: NSCoder) {
    //            super.init(coder: aDecoder)
    //        }
    // MARK: - didMove
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = physicDelegate
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)

        cameraSize = view.frame.size
        if let edgeNode = childNode(withName: "Edge Node") as? SKTileMapNode {
            //            makeEdgeFromMap(edgeNode)
        }
        if let mapNode = childNode(withName: "Obstacles Map Node")
            as? SKTileMapNode
        {
            makeLevelFromMap(mapNode)
            mapNode.removeFromParent()
        }
//        view.isMultipleTouchEnabled = true
        setup()
    }

    //    func makeEdgeFromMap(_ map: SKTileMapNode){
    //        var bodies: [SKPhysicsBody] = []
    //        var nodes: [ObstacleNode] = []
    //        for row in 0..<map.numberOfRows{
    //            for column in 0..<map.numberOfColumns{
    //                if let def =  map.tileDefinition(atColumn: column, row: row){
    //                    let tileNode = ObstacleNode()
    //                    tileNode.setup(size: map.tileSize, def: def)
    //                    tileNode.position = CGPoint(x: CGFloat(column) * tileNode.size.width /*- size.width / 2*/ + tileNode.size.width / 2,
    //                                                y: CGFloat(row) * tileNode.size.height /*- size.height / 2*/ + tileNode.size.height / 2)
    //                    nodes.append(tileNode)
    //                }
    //            }
    //        }
    //        nodes.map{
    //            if let body = $0.physicsBody{
    //
    //            bodies.append(body)
    //        }
    //            $0.physicsBody = nil
    //        }
    //        let newBody = SKPhysicsBody(bodies: bodies)
    //        let newNode = SKNode()
    //        newNode.position = map.position
    //        print("position: \(map.position)")
    //        newNode.zPosition = 20
    //        newBody.isDynamic = false
    //        newNode.physicsBody = newBody
    //        print("info")
    //        print("New node physicsBody: \(newNode.physicsBody?.description ?? "nil")")
    //        nodes.map{addChild($0)}
    //        addChild(newNode)
    //    }
    // MARK: - Methods

    //    func makeCameraConstraints(){
    //        if let camera {
    //            camera.constraints = [
    //                SKConstraint.positionX(SKRange(lowerLimit: size.width  / 2, upperLimit: bgNode.bounds.size.width - size.width / 2),
    //                                       y: SKRange(lowerLimit: size.height / 2, upperLimit: bgNode.bounds.height - size.height / 2))
    //            ]
    //        }
    //    }

    //    func makeLevelFromMap(_ map: SKTileMapNode) {
    //        // Создаём физическое тело как границу всей карты

    //    }

    func makeLevelFromMap(_ map: SKTileMapNode) {

        for row in 0..<map.numberOfRows {
            for column in 0..<map.numberOfColumns {
                if let def = map.tileDefinition(atColumn: column, row: row) {
//                    let tileTexturesArray = def.textures
//                    let texture = tileTexturesArray[0]
//
//                    let tileNode = ObstacleNode()
//                    tileNode.setup(
//                        texture: texture,
//                        size: map.tileSize,
//                        def: def
//                    )
//                    tileNode.position = CGPoint(
//                        x: CGFloat(column)
//                            * tileNode.size.width /*- size.width / 2*/
//                            + tileNode.size.width / 2,
//                        y: CGFloat(row)
//                            * tileNode.size.height /*- size.height / 2*/
//                            + tileNode.size.height / 2
//                    )
//
//                    addChild(tileNode)
                }
            }
        }
    }

    func setup() {
        let cameraNode = SKCameraNode()
        cameraNode.setScale(cameraSize.width / size.width)
        cameraNode.name = NodeNames.camera.name
        cameraNode.position = CGPoint(
            x: size.width / 2,
            y: size.height / 2
        )
        //        makeCameraConstraints()

        addChild(cameraNode)
        camera = cameraNode

//        bgNode.setup(withSize: cameraSize, fullSize: size)
//        bgNode.position = CGPoint(
//            x: cameraNode.frame.width / 2,
//            y: cameraNode.frame.height / 2
//        )
//        cameraNode.addChild(bgNode)
//        let pControlComponent = PlayerControlComponent(
//            camera: cameraNode,
//            size: cameraSize,
//            unit: unit,
//            scene: self
//        )
//        let entity = unit.makeEntity()
//        entity.addComponent(pControlComponent)
//        entities.append(entity)
//
//        unit.node.zPosition = 20
//        unit.node.position = CGPoint(
//            x: size.width / 2,
//            y: size.height / 2
//        )
//        addChild(unit.node)

    }

    // MARK: - Update
    override func update(_ currentTime: TimeInterval) {

        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime

        if dt > 0.01 {
            //            print("scene update")
            if let position = camera?.position {
//                bgNode.updateBG(pos: position)
            }
            for entity in entities {
                entity.update(deltaTime: dt)
            }
        }
    }
}

extension LevelScene: RootScene{
     
    
    func handleScrollWheel(with event: NSEvent) {
        print("scroll")
    }
    
    func handleMagnify(with event: NSEvent) {
        print("magnify")
    }
    
    func handleRotate(with event: NSEvent) {
        print("rotate")
    }
    
    func handleMouseDown(with event: NSEvent) {
        print("mouse down")
    }
    
    func handleMouseUp(with event: NSEvent) {
        print("mouse up")
    }
    
    func handleMouseMoved(with event: NSEvent) {
        print("mouse moved")
    }
    
    func handlePressureChange(with event: NSEvent) {
        print("pressure")
    }
    
    func handleKeyUp(with event: NSEvent) {
        print("key up: \(event.keyCode)")
    }
    
    func handleKeyDown(with event: NSEvent) {
        print("key down: \(event.keyCode)")
     
    }
}

