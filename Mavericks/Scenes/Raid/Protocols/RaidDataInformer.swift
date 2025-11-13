import Foundation
//hud process
protocol RaidDataInformer: AnyObject {
//    var controlInputDelegate: ControlInputDelegate? {get set}
    var outputDelegate: RaidScene? {get set}
    var pauseMenu: SettingsMenuNode {get set}
    var size: CGSize {get set}
    func start()
    func showTowerMenu(inPosition: CGPoint)
    func hideTowerMenu()
    func showTowerUpgradeMenu(tower: TowerModel,inPosition: CGPoint)
    func hideTowerUpgradeMenu()
    func showInfo(contentOwner: Informable)
    
    func showPauseMenu()
    func hidePauseMenu()
    
//    func changeState(newState: HudState)
}
