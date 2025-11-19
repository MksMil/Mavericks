import AppKit

protocol NodeTappedHandlable {
    func handleNode(_ tappedNode:BaseRaidNode,
                    isTapEnded: Bool,
                    state: SceneState,
                    sceneLocation: CGPoint)
}
