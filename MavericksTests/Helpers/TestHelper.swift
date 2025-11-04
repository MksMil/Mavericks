//
//  File.swift
//  Mavericks
//
//  Created by Миляев Максим on 04.11.2025.
//
@testable import Mavericks
import XCTest
import SpriteKit

enum TestHelper {
    static let mockBank = TextureBank(levelInfo: "", cellSize: 64)
    static func setupSKView() -> RaidScene {
        let window = NSWindow(
            contentRect: CGRect(x: 0, y: 0, width: 800, height: 600),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.makeKeyAndOrderFront(nil)
        
        let view = SKView(frame: window.contentView!.bounds)
        window.contentView!.addSubview(view)
        
        let scene = RaidScene(size: CGSize(width: 800, height: 600),
                              bank: mockBank)
        let field = Field(scene: scene,
                          bank: mockBank)
        scene.field = field
        view.presentScene(scene)
        
        return scene
    }
}
