//
//  BlockModel.swift
//  Mavericks
//
//  Created by Миляев Максим on 22.10.2025.
//

import GameplayKit

struct BlockType {
    
    var matrix: [[Bool]] = [
        [false,false,false],
        [false,false,false],
        [false,false,false]
    ]
   mutating func compareWithBlock(_ block: BlockType, inDirection direction: UnitDirection){
        switch direction {
            case .north:
                matrix[0] = block.matrix[0]
            case .south:
                matrix[2] = block.matrix[2]
            case .east:
                for i in 0..<3 {
                    matrix[i][2] = block.matrix[i][2]
                }
            case .west:
                for i in 0..<3 {
                    matrix[i][0] = block.matrix[i][0]
                }
        }
    }
}

//enum BlockType {
//    case single
//    
//    case eEdge
//    case wEdge
//    case nEdge
//    case sEdge
//    
//    case hLine
//    case vLine
//    
//    case hNFullLine
//    case hSFullLine
//    
//    case vWFullLine
//    case vEFullLine
//    
//    case full
//    
//    case nwCorner
//    case neCorner
//    case swCorner
//    case seCorner
//    
//    case nwFullCorner
//    case neFullCorner
//    case swFullCorner
//    case seFullCorner
//    
//    case cross
//    case neCross
//    case nwCross
//    case seCross
//    case swCross
//    
//    case empty
//    
//}

class BlockModel: GKEntity {
    let id: String
    var health: Int
    var node: SKSpriteNode?

    init(health: Int = 100) {
        self.id = UUID().uuidString
        self.health = health
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BlockModel: Informable{
    
}


//class BlockVisualComponenet: GKComponent{
//    let bank: RaidDataSource
//    var model: BlockModel
//    
//    init(block: BlockModel,bank: RaidDataSource){
//        self.model = block
//        self.bank = bank
//        super.init()
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func update(deltaTime seconds: TimeInterval) {
////        let neighbors = model.cell.neighbors
//        
//        //cell
//        //neighbors
//        // -> texture
//        
//    }
//}
