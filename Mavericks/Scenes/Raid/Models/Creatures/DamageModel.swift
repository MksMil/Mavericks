//
//  DamageModel.swift
//  Mavericks
//
//  Created by Миляев Максим on 16.10.2025.
//
import Foundation

struct DamageModel {
    
    var physic: CGFloat
    var fire: CGFloat
    var chemic: CGFloat
    
    var full: CGFloat{
        physic + fire + chemic
    }
}
