import SpriteKit

enum SceneFactory {
    
    static func makeScene(levelInfo: String,
                          initialSize: CGSize,
                          cellSize: CGFloat) -> RootScene{
        
        let bank = TextureBank(levelInfo: levelInfo,
                               cellSize: cellSize)

        let scene = RaidScene(size: initialSize,bank: bank)
        
        let field = Field(scene: scene, bank: bank)
        scene.fieldInputDelegate = field
        return scene
    }
}


