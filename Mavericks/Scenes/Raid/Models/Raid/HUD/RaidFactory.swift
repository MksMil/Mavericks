//
//  RaidFactory.swift
//  Mavericks
//
//  Created by Миляев Максим on 20.10.2025.
//

import SpriteKit

enum SceneFactory {
    
    static func makeScene(levelInfo: String,
                          initialSize: CGSize,
                          cellSize: CGFloat,
    ) -> RootScene{
        
        let bank = TextureBank(levelInfo: levelInfo,
                               cellSize: cellSize)

        
        let scene = RaidScene(size: initialSize,bank: bank)
        
        let field = Field(scene: scene, bank: bank)
        
        scene.field = field
        return scene
    }
    
    
}


