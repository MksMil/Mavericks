import SpriteKit

enum SceneFactory {
    
    static func makeScene(levelInfo: String,
                          initialSize: CGSize,
                          cellSize: CGFloat) -> RootScene{
        
        let bank = TextureBank()

        let scene = RaidScene(size: initialSize,bank: bank)
        
        let field = Field(scene: scene,
                          bank: bank,
                          cellSize: cellSize,
                          map: FieldModel.TestLevel)
        scene.fieldInputDelegate = field
        return scene
    }
}


