//
//  Created by Миляев Максим on 14.03.2025.
//

import Foundation
import SpriteKit

class ObstacleNode: SKSpriteNode{
    
    func setup(texture: SKTexture,size: CGSize,def: SKTileDefinition){
        self.texture = texture
        self.size = size
        self.name = NodeNames.bg.rawValue
        zPosition = 20
        var isWall = false
        if def.userData?["isWall"] as? Int == 1 {
            print("isWall")
            isWall = true
        }
        setupPhysics(texture: texture, isWall: isWall)
    }
    
    func setupPhysics(texture: SKTexture, isWall: Bool){
        var txtSize: CGSize = CGSize(width:  texture.size().width,
                                     height:  texture.size().height)
        var txtCenter: CGPoint = CGPoint(x: 32, y: 32)
        
        //visible rect
        if let visibleRect = ObstacleNode.visibleRect(from: texture){
            txtSize = visibleRect.size
            txtCenter = CGPoint(x: visibleRect.width / 2 + visibleRect.origin.x - 32,
                                    y:  32 - visibleRect.origin.y - visibleRect.height / 2)
        }
        physicsBody = SKPhysicsBody(rectangleOf: txtSize,center: txtCenter)
        physicsBody?.restitution = 0//отскок(упругость) [0:1] 0 - не отскакиевает
        physicsBody?.density = 100 //плотность
        physicsBody?.isDynamic = false
//        physicsBody?.isResting = true
            
        physicsBody?.friction = isWall ? 0 : 1 //сопротивление
        physicsBody?.affectedByGravity = false
        physicsBody?.linearDamping = 0 //затухание линейной скорости
        physicsBody?.angularDamping = 0 //затухание угловой скорости
        
        physicsBody?.allowsRotation = false
//        let rect = SKShapeNode(rectOf: CGSize(width: 64, height: 64))
//        rect.strokeColor = .red
//        addChild(rect)
        physicsBody?.categoryBitMask = isWall ? PhysicsCategory.Edges: PhysicsCategory.Obstacle //своя категория
        physicsBody?.contactTestBitMask = PhysicsCategory.Player //с какой категорией проводится тест на контакт при симуляции физики
        
        physicsBody?.collisionBitMask = isWall ? PhysicsCategory.Edges:PhysicsCategory.Player// контакт с какой категорией влияет на это тело, по умоланию все категории
    }
    
    static func visibleRect(from texture: SKTexture) -> CGRect? {
        let image = texture.cgImage()
        let width = image.width
        let height = image.height
        let pixelData = CFDataGetBytePtr(image.dataProvider?.data)
        
        var minX = width, maxX = 0, minY = height, maxY = 0
        
        for y in 0..<height {
            for x in 0..<width {
                let index = (y * width + x) * 4 // 4 байта на пиксель (RGBA)
                let alpha = pixelData?[index + 3] ?? 0
                
                if alpha > 0 { // Если пиксель не прозрачный
                    minX = min(minX, x)
                    maxX = max(maxX, x)
                    minY = min(minY, y)
                    maxY = max(maxY, y)
                }
            }
        }
        
        if minX >= maxX || minY >= maxY { return nil } // Полностью прозрачная текстура
        
        let visibleWidth = maxX - minX + 1
        let visibleHeight = maxY - minY + 1
        return CGRect(x: minX, y: minY, width: visibleWidth, height: visibleHeight)
    }
    
}
