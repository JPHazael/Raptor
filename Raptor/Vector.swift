//
//  Vector.swift
//  Raptor
//
//  Created by admin on 4/5/17.
//  Copyright © 2017 JPDaines. All rights reserved.
//

import Foundation


class Vector{
    
    var positionX: Float = 0.0
    var positionY: Float = 0.0
    

    init(_ pX: Float, _ pY: Float) {
        positionX = pX
        positionY = pY
    }
    
    convenience init(){
    self.init(0.0, 0.0)
    }
    
    
}


func vectorAddition(v1: Vector, v2: Vector) -> Vector{
    return Vector(v1.positionX + v2.positionX, v1.positionY + v2.positionY)
}

func scalarMultiply(vector: Vector, scalar: Float) -> Vector {
    return Vector(vector.positionX * scalar, vector.positionY * scalar)
}


