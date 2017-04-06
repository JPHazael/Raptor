//
//  Sprite.swift
//  Raptor
//
//  Created by admin on 4/5/17.
//  Copyright © 2017 JPDaines. All rights reserved.
//

import GLKit


class Sprite {

    //Implementation that runs for every sprite
    
    var position: Vector = Vector()
    var width: Float = 1.0
    var hieght: Float = 1.0
    
    
    func draw(){
        if Sprite._program == 0{
        Sprite.setup()
        }
        glUniform2f(glGetUniformLocation(Sprite._program, "translate"), position.positionX, position.positionY)
        glUniform2f(glGetUniformLocation(Sprite._program, "scale"), width, hieght)
        glUniform4f(glGetUniformLocation(Sprite._program, "color"), 0.3, 0.3, 0.8, 1.0)
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 4)
        
    }
}

//class Movable: Sprite{
//    
//    
//    var startTime: Double
//    var endTime: Double
//    var path: [Vector]
//    
//    
//}
//
//class Displayable: Movable{
//    
//    
//}
