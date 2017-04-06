//
//  ViewController.swift
//  Raptor
//
//  Created by admin on 4/5/17.
//  Copyright © 2017 JPDaines. All rights reserved.
//

import GLKit

class ViewController: GLKViewController {
    
    private let _sprite = Sprite()
    private var _lastUpdate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let glkView: GLKView = view as! GLKView
        glkView.drawableColorFormat = .RGBA8888
        
        glkView.context = EAGLContext(api: .openGLES2)
        EAGLContext.setCurrent(glkView.context)
        
        setup()
        
    }


    private func setup(){
        glClearColor(0.50, 0.35, 0.73, 1.0)
        
    }
    
    // Gameloop - runs before frame is drawn
    func update(){
        let now = Date()
        let elapsed = now.timeIntervalSince(_lastUpdate)
        
        // TODO: call gamemodel.executeGameLoop(elapsed)
        _sprite.position.positionX += Float(elapsed * 0.005)
    }
    
    
    // Display loop - actually draws the frame
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        _sprite.draw()
        
    }
}

