//
//  SceneHelper.swift
//  Mavericks
//
//  Created by Миляев Максим on 13.10.2025.
//

import SpriteKit


enum SceneHelper {
    
    static func distanceToScenePoint(_ end: CGPoint, from start: CGPoint )->CGFloat{
        //первое либо второе слагаемое равно нулю так как движение строго вертикальное или горизонтальное
        CGFloat(abs((end.x - start.x) + (end.y - start.y)))
    }
    
    static func distanceFromGridCell(position startGridPos: vector_int2, toPosition endGridPos: vector_int2) -> CGFloat{
        let start = SceneHelper.gridPositionToScene(position: startGridPos)
        let end = SceneHelper.gridPositionToScene(position: endGridPos)
        return SceneHelper.distanceToScenePoint(end, from: start)
    }
    
    static func gridPositionToScene(position: vector_int2) -> CGPoint {
         let cellSize = 100.0
         let sceneX = CGFloat(position.x) * cellSize + cellSize / 2
         let sceneY = CGFloat(position.y) * cellSize + cellSize / 2
         return CGPoint(x: sceneX, y: sceneY)
     }
    
    //    // Конвертация пути в точки сцены
    //    func convertPathToCoord(path: [GridCell]) -> [CGPoint]{
    //        let scenePath = path.map {
    //            MonsterModel.gridPositionToScene(position:$0.gridPosition)
    //        }
    //        return scenePath
    //    }
    
    // Конвертация позиции сцены в координаты сетки
//    private func sceneToGridPosition(_ point: CGPoint) -> vector_int2 {
//        let x = Int32(floor(point.x / cellSize))
//        let y = Int32(floor(point.y / cellSize))
//        print(" tapped x: \(x), y: \(y)")
//        return vector_int2(x: x, y: y)
//    }
//    //vector_int2 -> CGPoint
//    private func gridPositionToScene(x: Int, y: Int) -> CGPoint {
//        let sceneX = CGFloat(x) * cellSize + cellSize / 2
//        let sceneY = CGFloat(y) * cellSize + cellSize / 2
//        return CGPoint(x: sceneX, y: sceneY)
//    }

    
}
