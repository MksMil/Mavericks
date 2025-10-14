import SpriteKit
import CoreGraphics
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
enum TextureFactory{
    
    struct AnglesForState {
        //static values for different class texture
    }
    //custom sequence for test texture
    static func makeSequence(headTexture: SKTexture, bodyTexture: SKTexture,
                             leftArmTexture: SKTexture, rightArmTexture: SKTexture,
                             leftLegTexture: SKTexture, rightLegTexture: SKTexture,
                             angle: CGFloat,count: Int = 6) -> [SKTexture]{
        
        //direction
        //textures(head arms body legs shield weapon...)
        //step(points)
        //angle for legs
        //angle for arms
        //step for head
        //step gor body
        //step for arms
        let step = angle / 2
        var result:[SKTexture] = []
        for i in 0 ... count - 1 {
            var lArmAngle: CGFloat = .zero
            var rArmAngle: CGFloat = .zero
            var lLegAngle: CGFloat = .zero
            var rLegAngle: CGFloat = .zero
            
            switch i {
                case 0:
                    lArmAngle = 0
                    rArmAngle = 0
                    lLegAngle = 0
                    rLegAngle = 0
                    
                case 1:
                    lArmAngle = 0
                    rArmAngle = step / 4
                    lLegAngle = -step
                    rLegAngle = 0
                    
                case 2:
                    lArmAngle = 0
                    rArmAngle = step / 2
                    lLegAngle = -step * 2
                    rLegAngle = 0
                    
                case 3:
                    lArmAngle = -step / 4
                    rArmAngle = step / 4
                    lLegAngle = -step
                    rLegAngle = step
                    
                case 4:
                    lArmAngle = -step / 2
                    rArmAngle = 0
                    lLegAngle = 0
                    rLegAngle = step
                    
                case 5:
                    lArmAngle = -step / 4
                    rArmAngle = 0
                    lLegAngle = 0
                    rLegAngle = step / 2
                
                default : break
            }
            
            if let txt = combineTextures(headTexture: headTexture,
                                         bodyTexture: bodyTexture,
                                         leftArmTexture: leftArmTexture,
                                         rightArmTexture: rightArmTexture,
                                         leftLegTexture: leftLegTexture,
                                         rightLegTexture: rightLegTexture,
                                         headOffset: .zero,headRotation: .zero,
                                         bodyOffset: .zero,bodyRotation: .zero,
                                         leftArmOffset: .zero,leftArmRotation: lArmAngle,
                                         rightArmOffset: .zero,rightArmRotation: rArmAngle,
                                         leftLegOffset: .zero,leftLegRotation: lLegAngle,
                                         rightLegOffset: .zero,rightLegRotation: rLegAngle){
                result.append(txt)
            }
        }
        return result
    }
    
    
   static func combineTextures(headTexture: SKTexture, bodyTexture: SKTexture,
                               leftArmTexture: SKTexture, rightArmTexture: SKTexture,
                               leftLegTexture: SKTexture, rightLegTexture: SKTexture,
                               headOffset: CGPoint = .zero, headRotation: CGFloat = 0,
                               bodyOffset: CGPoint = .zero, bodyRotation: CGFloat = 0,
                               leftArmOffset: CGPoint = .zero, leftArmRotation: CGFloat = 0,
                               rightArmOffset: CGPoint = .zero, rightArmRotation: CGFloat = 0,
                               leftLegOffset: CGPoint = .zero, leftLegRotation: CGFloat = 0,
                               rightLegOffset: CGPoint = .zero, rightLegRotation: CGFloat = 0) -> SKTexture? {
        let maxWidth = max(headTexture.size().width, bodyTexture.size().width, leftLegTexture.size().width, rightLegTexture.size().width) * 2

        let totalHeight = headTexture.size().height + bodyTexture.size().height + leftLegTexture.size().height// + rightLegTexture.size().height
        
#if os(iOS)
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: maxWidth, height: totalHeight))
        let combinedImage = renderer.image { context in
            let cgContext = context.cgContext
            
            cgContext.interpolationQuality = .none
            // Голова
            cgContext.saveGState()
            //anchor point
            //|-------|
            //|       |
            //|       |
            //|       |
            //|---0---|
            cgContext.translateBy(x: maxWidth / 2,
                                  y: totalHeight / 2 + bodyTexture.size().height / 2 - bodyTexture.size().height / 9)
            cgContext.rotate(by: headRotation)
            //rect for draw
            cgContext.draw(headTexture.cgImage(),
                           in: CGRect(x: -headTexture.size().width / 2,
                                      y: 0/*headTexture.size().height*/ ,
                                      width: headTexture.size().width,
                                      height: headTexture.size().height))
            cgContext.restoreGState()
            
            // Левая нога
            cgContext.saveGState()
            //anchor point
            //|---0---|
            //|       |
            //|       |
            //|       |
            //|-------|
            cgContext.translateBy(x: maxWidth / 2 - bodyTexture.size().width / 4 ,
                                  y: totalHeight / 2 + leftLegTexture.size().width / 9 - bodyTexture.size().height / 2)
            cgContext.rotate(by: leftLegRotation)
            cgContext.draw(leftLegTexture.cgImage(),
                           in: CGRect(x: -leftLegTexture.size().width / 2,
                                      y: 0 ,
                                      width: leftLegTexture.size().width,
                                      height: -leftLegTexture.size().height))
            cgContext.restoreGState()
            
            // Правая нога
            cgContext.saveGState()
            //anchor point
            //|---0---|
            //|       |
            //|       |
            //|       |
            //|-------|
            cgContext.translateBy(x: maxWidth / 2 + bodyTexture.size().width / 4,
                                  y: totalHeight / 2 + rightLegTexture.size().height / 9 - bodyTexture.size().height / 2)
            cgContext.rotate(by: rightLegRotation)
            cgContext.draw(rightLegTexture.cgImage(),
                           in: CGRect(x: -rightLegTexture.size().width / 2,
                                      y: 0,
                                      width: rightLegTexture.size().width,
                                      height: -rightLegTexture.size().height))
            cgContext.restoreGState()
            
            //Правая рука
            cgContext.saveGState()
            //anchor point
            //0-------|
            //|       |
            //|       |
            //|       |
            //|-------|
            cgContext.translateBy(x: maxWidth / 2 + bodyTexture.size().width / 2 - rightArmTexture.size().width / 9,
                                  y: totalHeight / 2 + bodyTexture.size().height / 2 - bodyTexture.size().height / 9)
            cgContext.rotate(by: rightArmRotation)
            cgContext.draw(rightArmTexture.cgImage(),
                           in: CGRect(x: 0,
                                      y: 0,
                                      width: rightArmTexture.size().width,
                                      height: -rightArmTexture.size().height))
            cgContext.restoreGState()
            
            //левая рука
            cgContext.saveGState()
            //anchor point
            //|-------0
            //|       |
            //|       |
            //|       |
            //|-------|
            cgContext.translateBy(x: maxWidth / 2 - bodyTexture.size().width / 2 + leftArmTexture.size().width / 9,
                                  y: totalHeight / 2 + bodyTexture.size().height / 2 - bodyTexture.size().height / 9)
            cgContext.rotate(by: leftArmRotation)
            cgContext.draw(leftArmTexture.cgImage(),
                           in: CGRect(x: 0,
                                      y: 0,
                                      width: -leftArmTexture.size().width,
                                      height: -leftArmTexture.size().height))
            cgContext.restoreGState()
            
            // Туловище
            cgContext.saveGState()
            //anchor point
            //|-------|
            //|       |
            //|   0   |
            //|       |
            //|-------|
            cgContext.translateBy(x: maxWidth / 2,
                                  y: totalHeight / 2)
            cgContext.rotate(by: bodyRotation)
            cgContext.draw(bodyTexture.cgImage(),
                           in: CGRect(x: -bodyTexture.size().width / 2,
                                      y: -bodyTexture.size().height / 2,
                                      width: bodyTexture.size().width,
                                      height: bodyTexture.size().height))
            cgContext.restoreGState()
        }
        return SKTexture(image: combinedImage)
        
#elseif os(macOS)
        let image = NSImage(size: NSSize(width: maxWidth, height: totalHeight))
        
       
       
       
        // Создание NSBitmapImageRep для рисования
        if let bitmapRep = NSBitmapImageRep(bitmapDataPlanes: nil,
                                            pixelsWide: Int(maxWidth),
                                            pixelsHigh: Int(totalHeight),
                                            bitsPerSample: 8,
                                            samplesPerPixel: 4,
                                            hasAlpha: true,
                                            isPlanar: false,
                                            colorSpaceName: .deviceRGB,
                                            bytesPerRow: 0,
                                            bitsPerPixel: 0) {
            
            if let context = NSGraphicsContext(bitmapImageRep: bitmapRep) {
                NSGraphicsContext.saveGraphicsState()
                NSGraphicsContext.current = context
                
                let cgContext = context.cgContext
                cgContext.setShouldAntialias(false)
                cgContext.interpolationQuality = .none
                
                
                // Голова
                cgContext.saveGState()
                //anchor point
                //|-------|
                //|       |
                //|       |
                //|       |
                //|---0---|
                cgContext.translateBy(x: maxWidth / 2,
                                      y: totalHeight / 2 + bodyTexture.size().height / 2 - bodyTexture.size().height / 9)
                cgContext.rotate(by: headRotation)
                //rect for draw
                cgContext.draw(headTexture.cgImage(),
                               in: CGRect(x: -headTexture.size().width / 2,
                                          y: 0/*headTexture.size().height*/ ,
                                          width: headTexture.size().width,
                                          height: headTexture.size().height))
                cgContext.restoreGState()
                
                // Левая нога
                cgContext.saveGState()
                //anchor point
                //|---0---|
                //|       |
                //|       |
                //|       |
                //|-------|
                cgContext.translateBy(x: maxWidth / 2 - bodyTexture.size().width / 4 ,
                                      y: totalHeight / 2 + leftLegTexture.size().width / 9 - bodyTexture.size().height / 2)
                cgContext.rotate(by: leftLegRotation)
                cgContext.draw(leftLegTexture.cgImage(),
                               in: CGRect(x: -leftLegTexture.size().width / 2,
                                          y: 0 ,
                                          width: leftLegTexture.size().width,
                                          height: -leftLegTexture.size().height))
                cgContext.restoreGState()
                
                // Правая нога
                cgContext.saveGState()
                //anchor point
                //|---0---|
                //|       |
                //|       |
                //|       |
                //|-------|
                cgContext.translateBy(x: maxWidth / 2 + bodyTexture.size().width / 4,
                                      y: totalHeight / 2 + rightLegTexture.size().height / 9 - bodyTexture.size().height / 2)
                cgContext.rotate(by: rightLegRotation)
                cgContext.draw(rightLegTexture.cgImage(),
                               in: CGRect(x: -rightLegTexture.size().width / 2,
                                          y: 0,
                                          width: rightLegTexture.size().width,
                                          height: -rightLegTexture.size().height))
                cgContext.restoreGState()
                
                //Правая рука
                cgContext.saveGState()
                //anchor point
                //0-------|
                //|       |
                //|       |
                //|       |
                //|-------|
                cgContext.translateBy(x: maxWidth / 2 + bodyTexture.size().width / 2 - rightArmTexture.size().width / 9,
                                      y: totalHeight / 2 + bodyTexture.size().height / 2 - bodyTexture.size().height / 9)
                cgContext.rotate(by: rightArmRotation)
                cgContext.draw(rightArmTexture.cgImage(),
                               in: CGRect(x: 0,
                                          y: 0,
                                          width: rightArmTexture.size().width,
                                          height: -rightArmTexture.size().height))
                cgContext.restoreGState()
                
                //левая рука
                cgContext.saveGState()
                //anchor point
                //|-------0
                //|       |
                //|       |
                //|       |
                //|-------|
                cgContext.translateBy(x: maxWidth / 2 - bodyTexture.size().width / 2 + leftArmTexture.size().width / 9,
                                      y: totalHeight / 2 + bodyTexture.size().height / 2 - bodyTexture.size().height / 9)
                cgContext.rotate(by: leftArmRotation)
                cgContext.draw(leftArmTexture.cgImage(),
                               in: CGRect(x: 0,
                                          y: 0,
                                          width: -leftArmTexture.size().width,
                                          height: -leftArmTexture.size().height))
                cgContext.restoreGState()
                
                // Туловище
                cgContext.saveGState()
                //anchor point
                //|-------|
                //|       |
                //|   0   |
                //|       |
                //|-------|
                cgContext.translateBy(x: maxWidth / 2,
                                      y: totalHeight / 2)
                cgContext.rotate(by: bodyRotation)
                cgContext.draw(bodyTexture.cgImage(),
                               in: CGRect(x: -bodyTexture.size().width / 2,
                                          y: -bodyTexture.size().height / 2,
                                          width: bodyTexture.size().width,
                                          height: bodyTexture.size().height))
                cgContext.restoreGState()
                
                
                NSGraphicsContext.restoreGraphicsState()
                image.addRepresentation(bitmapRep)
            }
        }
        
        if let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) {
            return SKTexture(cgImage: cgImage)
        }
        return nil
#endif
    }
    
   static func generarateNormalMapsFrom(textures: [SKTexture]) -> [SKTexture]{
        textures.map{$0.generatingNormalMap()}
    }
}

