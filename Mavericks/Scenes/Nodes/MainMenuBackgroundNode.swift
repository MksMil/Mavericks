import SpriteKit
import SwiftUI

class MainMenuBackgroundNode: SKNode{
    
    let size: CGSize
    var sunNode: SKNode = SKNode()
    
    
    var bgNodes = [
        SKSpriteNode(texture: SKTexture(imageNamed: "Background_Layer_05")),
        SKSpriteNode(texture: SKTexture(imageNamed: "Background_Layer_04")),
        SKSpriteNode(texture: SKTexture(imageNamed: "Background_Layer_03")),
        SKSpriteNode(texture: SKTexture(imageNamed: "Background_Layer_02")),
        SKSpriteNode(texture: SKTexture(imageNamed: "Background_Layer_01"))
    ]
    
    init(withSize size: CGSize) {
        self.size = size
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        //background layers (animate with paralax?)
        for i in 0..<bgNodes.count{
            let node = bgNodes[i]
            addChild(node)
            node.zPosition = CGFloat(i)
            
            node.size = CGSize(width: size.width, height: size.height / CGFloat(i + 1))
            node.position = CGPoint(x: size.width / 2,
                                    y: size.height / (2 * CGFloat(i + 1)))
            
        }
        
        //sun + animation
        sunNode = SKSpriteNode(texture: SKTexture(imageNamed: "sun_shiny"))
        sunNode.setScale(0.5)
        let sunSize = sunNode.frame.width
        sunNode.position = CGPoint(x: size.width + sunSize,
                                   y: size.height - sunSize)
        addChild(sunNode)
        sunNode.run(SKAction.repeatForever(makeSunAnimation(sunSize: sunSize)))
    }

    override func move(toParent parent: SKNode) {
        
    }
    
    func makeSunAnimation(sunSize: CGFloat) -> SKAction{
        let sunMoveToCenterActionX = SKAction.moveTo(x: size.width / 2, duration: 10)
        let sunMoveToCenterActionY = SKAction.moveTo(y: size.height - sunSize / 2, duration: 10)
        
        let sunMoveToLeftActionX = SKAction.moveTo(x: -sunSize, duration: 10)
        let sunMoveToLeftActionY = SKAction.moveTo(y: size.height - sunSize, duration: 10)
        
        let sunFadeOff = SKAction.fadeAlpha(to: 0, duration: 0.1)
        let sunFadeON = SKAction.fadeAlpha(to: 1, duration: 0.1)
        
        let sunMoveToInitialActionX = SKAction.moveTo(x: size.width + sunSize, duration: 0.1)
        let sunMoveToInitialActionY = SKAction.moveTo(y: size.height - sunSize, duration: 0.1)

        let moveToCenterAction = SKAction.group([sunMoveToCenterActionX,sunMoveToCenterActionY])
        let moveToTheEnd = SKAction.group([sunMoveToLeftActionX,sunMoveToLeftActionY])
        let moveToTheStart = SKAction.group([sunMoveToInitialActionX,sunMoveToInitialActionY])
        
        let fullMove = SKAction.sequence([moveToCenterAction,moveToTheEnd,sunFadeOff,moveToTheStart,sunFadeON])
        return fullMove
    }
    
}


#Preview {
    StartView()
}
