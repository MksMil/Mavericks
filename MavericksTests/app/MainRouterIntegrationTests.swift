//
//  MainRouterIntegrationTests.swift
//  Mavericks
//
//  Created by Миляев Максим on 04.11.2025.
//


import XCTest
import SpriteKit
import SwiftUI
@testable import Mavericks

@available(iOS 13.0, macOS 10.15, *)
@MainActor
final class MainRouterIntegrationTests: XCTestCase {
    
    var router: MainRouter!
    var rootView: RootSKView!
    var window: NSWindow!
    
    override func setUp() {
        super.setUp()
        
        // Создаём окно
        window = NSWindow(
            contentRect: CGRect(x: 0, y: 0, width: 800, height: 600),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.makeKeyAndOrderFront(nil)
        
        // Создаём RootSKView
        rootView = RootSKView()
        rootView.frame = window.contentView!.bounds
        window.contentView!.addSubview(rootView)
        
        // Создаём MainRouter
        router = MainRouter()
        router.renderDelegate = rootView
        rootView.router = router
    }
    
    override func tearDown() {
        window.close()
        router = nil
        rootView = nil
        super.tearDown()
    }
    
    // MARK: - Present Scene
    func testPresentHome_LoadsHomeScene() async {
        router.presentScene(.home)
        
        try? await Task.sleep(nanoseconds: 1200_000_000)  //
        
        XCTAssertTrue(rootView.scene is HomeScene)
//        XCTAssertTrue(router.activeScene is HomeScene)
    }
    
    func testPresentRaid_ReplacesScene() async {
        // Сначала Home
        router.presentScene(.home)
        try? await Task.sleep(nanoseconds: 1300_000_000)
        let homeScene = rootView.scene
        
        // Затем Raid
        router.presentScene(.raidScene)
        try? await Task.sleep(nanoseconds: 1300_000_000)
        
        XCTAssertTrue(rootView.scene is RaidScene)
//        XCTAssertTrue(router.activeScene is RaidScene)
        XCTAssertNil(homeScene?.parent)  // Старая сцена удалена
    }
    
    // MARK: - Full Transition Cycle
    func testHome_Raid_Home_DeallocatesOldScene() async {
        weak var weakHomeScene: SKScene?
        weak var weakRaidScene: SKScene?
        
        // 1. Home
        router.presentScene(.home)
        try? await Task.sleep(nanoseconds: 1100_000_000)
        weakHomeScene = rootView.scene
        
        // 2. Raid
        router.presentScene(.raidScene)
        try? await Task.sleep(nanoseconds: 1100_000_000)
        XCTAssertNil(weakHomeScene)
        weakRaidScene = rootView.scene
        
        // 3. Back to Home
        router.presentScene(.home)
        try? await Task.sleep(nanoseconds: 1100_000_000)
        
        // THEN: старые сцены должны быть deinit
        XCTAssertTrue(rootView.scene is HomeScene)
        XCTAssertNil(weakRaidScene)
    }
    
    // MARK: - Deinit Chain
    func testDeinit_RouterAndView_ReleaseAll() async {
        var localRouter: MainRouter? = MainRouter()
        var localView: RootSKView? = RootSKView()
        
        localRouter?.renderDelegate = localView
        localView?.router = localRouter
        
        weak var weakRouter = localRouter
        weak var weakView = localView
//        weak var weakScene = localRouter?.activeScene
        
        localRouter?.presentScene(.home)
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        localRouter = nil
        localView = nil
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertNil(weakRouter)
        XCTAssertNil(weakView)
//        XCTAssertNil(weakScene)
    }
}
