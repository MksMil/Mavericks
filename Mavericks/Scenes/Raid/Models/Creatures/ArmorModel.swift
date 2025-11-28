//
//  ArmorModel.swift
//  Mavericks
//
//  Created by Миляев Максим on 16.10.2025.
//

import Foundation

struct ArmorModel {
    
    var physic: CGFloat   //1...100
    var fire: CGFloat     //1...100
    var chemic: CGFloat   //1...100
    
    static var Base: ArmorModel{
        ArmorModel(physic: 10, fire: 10, chemic: 10)
    }
    
    func reducedDamage(_ dmg: DamageModel,
                       withEquippedArmor eq: ArmorModel) -> DamageModel{
        
        let fullArmor = ArmorModel(physic: physic + eq.physic,
                                   fire: fire + eq.fire,
                                   chemic: chemic + eq.chemic)
        
        let k = 250.0
        //min:20% of dmg  max:99.6% of dmg
        let rDmg = DamageModel(physic: dmg.physic * (1 - fullArmor.physic / k),
                               fire: dmg.fire * (1 - fullArmor.fire / k),
                               chemic: dmg.chemic * (1 - fullArmor.chemic / k))
        
        return rDmg
    }
}
