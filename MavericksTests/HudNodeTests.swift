//
//  HudNodeTests.swift
//  Mavericks
//
//  Created by Миляев Максим on 03.11.2025.
//


import XCTest
import SpriteKit
@testable import Mavericks

final class HudNodeTests: XCTestCase {
    let mockBank = TextureBank(levelInfo: "", cellSize: 64)
    
    
    
    // MARK: - Setup
//    func testSetup_CreatesPauseButton() {
//        let scene = setupSKView()
//        let hud = HudNode(withCameraSize: .zero, bank: mockBank, outputDelegate: scene)
//        
//        XCTAssertNotNil(hud.pauseButton)
//        XCTAssertEqual(hud.pauseButton.name, NodeNames.pauseButton.rawValue)
//        XCTAssertTrue(hud.children.contains(hud.pauseButton))
//    }
    
    func testSetup_CreatesPauseMenu() {
        let scene = setupSKView()
        let hud = HudNode(withCameraSize: .zero, bank: mockBank, outputDelegate: scene)
        
        XCTAssertNotNil(hud.pauseMenu)
        XCTAssertTrue(hud.children.contains(where: { $0 === hud.pauseMenu }))
    }
    
    // MARK: - Menu Animations
    func testShowMenu_AnimatesPauseMenu() {
        let scene = setupSKView()
        let hud = HudNode(withCameraSize: .zero, bank: mockBank, outputDelegate: scene)
        scene.addChild(hud)
        
        let exp = expectation(description: "show menu")
        
        hud.showPauseMenu()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let menu = hud.pauseMenu
            XCTAssertEqual(menu.globalBgNode.alpha, 0.3, accuracy: 0.01)
            XCTAssertEqual(menu.menuBgNode.alpha, 0.7, accuracy: 0.01)
            XCTAssertEqual(menu.menuBgNode.xScale, 1.0, accuracy: 0.01)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testHideMenu_AnimatesPauseMenu() {
        let scene = setupSKView()
        let hud = HudNode(withCameraSize: scene.size,
                          bank: mockBank,
                          outputDelegate: scene)
        scene.addChild(hud)
        let menu = hud.pauseMenu
        XCTAssertEqual(menu.globalBgNode.alpha, 0.0, accuracy: 0.01)
        XCTAssertEqual(menu.menuBgNode.alpha, 0.0, accuracy: 0.01)
        XCTAssertEqual(menu.menuBgNode.xScale, 0.0, accuracy: 0.01)
        hud.showPauseMenu()
        let expShow = expectation(description: "show menu")
        let expHide = expectation(description: "hide menu")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(menu.globalBgNode.alpha, 0.3, accuracy: 0.01)
            XCTAssertEqual(menu.menuBgNode.alpha, 0.7, accuracy: 0.01)
            XCTAssertEqual(menu.menuBgNode.xScale, 1.0, accuracy: 0.01)
            expShow.fulfill()
            hud.hidePauseMenu()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            
            XCTAssertEqual(menu.globalBgNode.alpha, 0.0, accuracy: 0.01)
            XCTAssertEqual(menu.menuBgNode.alpha, 0.0, accuracy: 0.01)
            XCTAssertEqual(menu.menuBgNode.xScale, 0.0, accuracy: 0.01)
            expHide.fulfill()
        }
        wait(for: [expShow,expHide], timeout: 2.5)
    }
    
    // MARK: - Button Interaction
    func testPauseButton_Tap_ShowsMenu() {
        let scene = setupSKView()
        let hud = HudNode(withCameraSize: scene.size, bank: mockBank, outputDelegate: scene)
        scene.addChild(hud)
        
//        let pauseButton = hud.pauseButton
        
        let exp = expectation(description: "menu shown")

        hud.showPauseMenu()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let menu = hud.pauseMenu
            XCTAssertEqual(menu.globalBgNode.alpha, 0.3, accuracy: 0.01)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - State Change
    func testChangeState_Pause_ShowsMenu() {
        let scene = setupSKView()
        let hud = HudNode(withCameraSize: scene.size, bank: mockBank, outputDelegate: scene)
        scene.addChild(hud)
        
        let exp = expectation(description: "menu shown on pause")
        
        hud.changeState(newState: .pause)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let menu = hud.pauseMenu
            XCTAssertEqual(menu.globalBgNode.alpha, 0.3, accuracy: 0.01)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testChangeState_Run_HidesMenu() {
        let scene = setupSKView()
        let hud = HudNode(withCameraSize: scene.size,
                          bank: mockBank,
                          outputDelegate: scene)
        scene.addChild(hud)
        hud.changeState(newState: .pause)  // Сначала показываем
        
        let exp = expectation(description: "menu hidden on run")
        
        hud.changeState(newState: .run)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let menu = hud.pauseMenu
            XCTAssertEqual(menu.globalBgNode.alpha, 0.0, accuracy: 0.01)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Deinit
    func testDeinit_CalledWhenRemoved() {
        let scene = setupSKView()
        var strongRef: HudNode? = HudNode(withCameraSize: .zero, bank: mockBank, outputDelegate: scene)
        weak var weakRef = strongRef
        
        strongRef = nil
        XCTAssertNil(weakRef)
    }
}

// MARK: - Helper
extension HudNodeTests {
    func setupSKView() -> RaidScene {
        let window = NSWindow(
            contentRect: CGRect(x: 0, y: 0, width: 800, height: 600),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.makeKeyAndOrderFront(nil)
        let view = SKView(frame: window.contentView!.bounds)
        window.contentView!.addSubview(view)
        let scene = RaidScene(size: .zero,
                              bank: mockBank)
        view.presentScene(scene)
        return scene
    }

}
