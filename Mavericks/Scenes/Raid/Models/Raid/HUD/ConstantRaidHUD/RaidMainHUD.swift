//
//  RaidHUD.swift
//  Mavericks
//
//  Created by Миляев Максим on 24.10.2025.
//

import SpriteKit
import GameplayKit

class RaidMainHUD: SKNode {
    var camSize: CGSize
    let bank: RaidDataSource
    
    init(bank: RaidDataSource, camSize: CGSize) {
        self.camSize = camSize
        self.bank = bank
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup(){
        zPosition = 100
       
        let pauseButton = HudButton()
        
        pauseButton.setup(withName: "pause",
                          size: CGSize(width: 50, height: 50),
                          position: CGPoint(x: camSize.width / 2,
                                            y: camSize.height - 30))
        pauseButton.name = NodeNames.pause.rawValue
        print(frame)
        print(pauseButton.position)
        addChild(pauseButton)

    }
}
