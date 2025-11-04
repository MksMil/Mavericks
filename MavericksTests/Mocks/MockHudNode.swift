//
//  MockHudNode.swift
//  Mavericks
//
//  Created by Миляев Максим on 04.11.2025.
//
@testable import Mavericks
import XCTest


class MockHudNode: HudNode {
    var lastState: HudState = .pause
    var changeStatePauseCalled = false
    var changeStateRunCalled = false
    var changeStateFinishRaidCalled = false
    
    init(bank: RaidDataSource,
         delegate: RaidScene) {
        super.init(withCameraSize: .zero,
                   bank: bank,
                   outputDelegate: delegate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func changeState(newState: HudState) {
        lastState = newState
        switch newState {
            case .pause:
                changeStatePauseCalled = true
            case .run:
                changeStateRunCalled = true
            case .finishRaid:
                changeStateFinishRaidCalled = true
        }
    }
}
