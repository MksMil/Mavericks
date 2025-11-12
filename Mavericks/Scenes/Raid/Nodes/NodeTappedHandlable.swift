import AppKit

protocol NodeTappedHandlable {
    func handleNode(_ tappedNode:BaseRaidNode,
                    isTapped: Bool,
                    state: SceneState,
                    sceneLocation: CGPoint)
}
