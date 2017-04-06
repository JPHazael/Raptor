//
//  ViewController.swift
//  Raptor
//
//  Created by admin on 4/5/17.
//  Copyright © 2017 JPDaines. All rights reserved.
//

import GLKit

class ViewController: GLKViewController {
    
    
    
    private var _program: GLuint = 0

    private var _translateX: Float = 0.0
    private var _translateY: Float = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let glkView: GLKView = view as! GLKView
        glkView.drawableColorFormat = .RGBA8888
        
        glkView.context = EAGLContext(api: .openGLES2)
        EAGLContext.setCurrent(glkView.context)
        
        
        setup()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setup(){
        glClearColor(0.50, 0.35, 0.73, 1.0)
        
        let vertexShaderSource: NSString = "attribute vec2 position; \n uniform vec2 translate; \n"
        + "void main() \n"
        + "{ \n" +
        "    gl_Position = vec4(position.x + translate.x, position.y + translate.y, 0.0, 1.0);  \n" +
        " }\n" as NSString
        
 
        //Create and compile vertex shader
        let vertexShader: GLint = GLint(glCreateShader(GLenum(GL_VERTEX_SHADER)))
        
        var vertexShaderSourceUTF8 = vertexShaderSource.utf8String
        
        glShaderSource(GLuint(vertexShader), 1, &vertexShaderSourceUTF8 , nil)
        
        glCompileShader(GLuint(vertexShader))
        
        var vertexShaderCompileStatus: GLint = GL_FALSE
        glGetShaderiv(GLuint(vertexShader), GLenum(GL_COMPILE_STATUS), &vertexShaderCompileStatus)
        
        //Run the world's most complicated error check on the vertex shader source code
        
        if vertexShaderCompileStatus == GL_FALSE{
            var vertexShaderLogLength: GLint = 0
            glGetShaderiv(GLuint(vertexShader), GLenum(GL_INFO_LOG_LENGTH), &vertexShaderLogLength)
            
            let vertexShaderLog = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(vertexShaderLogLength))
            
            glGetShaderInfoLog(GLuint(vertexShader), vertexShaderLogLength, nil, vertexShaderLog)
            
            let vertexShaderLogString = NSString(utf8String: vertexShaderLog)!
            
            print("Vertex Shader Compile Failure ERROR: \(vertexShaderLogString)")
        }
        
        
        
        //Create and compile fragment shader
        
        let fragmentShaderSource: NSString = " void main() \n" +
            "{ \n" +
            "    gl_FragColor = vec4(1.0, 1.0, 0.0, 1.0);  \n" +
            " }\n" as NSString
        
        
        
        let fragmentShader: GLint = GLint(glCreateShader(GLenum(GL_FRAGMENT_SHADER)))
        
        var fragmentShaderSourceUTF8 = fragmentShaderSource.utf8String
        
        glShaderSource(GLuint(fragmentShader), 1, &fragmentShaderSourceUTF8 , nil)
        
        glCompileShader(GLuint(fragmentShader))
        
        var fragmentShaderCompileStatus: GLint = GL_FALSE
        glGetShaderiv(GLuint(fragmentShader), GLenum(GL_COMPILE_STATUS), &fragmentShaderCompileStatus)
        
        //Run the world's most complicated error check on the fragment shader source code
        
        if fragmentShaderCompileStatus == GL_FALSE{
            var fragmentShaderLogLength: GLint = 0
            glGetShaderiv(GLuint(fragmentShader), GLenum(GL_INFO_LOG_LENGTH), &fragmentShaderLogLength)
            
            let fragmentShaderLog = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(fragmentShaderLogLength))
            
            glGetShaderInfoLog(GLuint(fragmentShader), fragmentShaderLogLength, nil, fragmentShaderLog)
            
            let fragmentShaderLogString = NSString(utf8String: fragmentShaderLog)!
            
            print("Fragment Shader Compile Failure ERROR: \(String(describing: fragmentShaderLogString))")
        }
        
        
        //Link the shaders into a program and upload it into the GPU
        
        _program = glCreateProgram()
        
        glAttachShader(_program, GLuint(vertexShader))
        glAttachShader(_program, GLuint(fragmentShader))
        
        glBindAttribLocation(_program, 0, "position")
        glLinkProgram(_program)
        
        var programLinkStatus: GLint = GL_FALSE
        
        glGetProgramiv(_program, GLenum(GL_LINK_STATUS), &programLinkStatus)
        
        if programLinkStatus == GL_FALSE{
            
            var programLogLength: GLint = 0
            glGetProgramiv(GLuint(fragmentShader), GLenum(GL_INFO_LOG_LENGTH), &programLogLength)
            
            let programLog = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(programLogLength))
            
            glGetShaderInfoLog(GLuint(fragmentShader), programLogLength, nil, programLog)
            
            let programString = NSString(utf8String: programLog)
            
            print("Program Link Compile Failure ERROR: \(String(describing: programString))")
            
        }
        
        
        glUseProgram(_program)
        glEnableVertexAttribArray(0)
        
        
        //Ask the GPU to draw a triangle
        
        
        
        
    }
    
    // Gameloop - runs before frame is drawn
    func update(){
        
    }
    
    
    // Display loop - actually draws the frame
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        
        
        // the default open GL coordinate system is -1 to 1 in x and -1 to 1 in y
        let triangle: [Float] = [
        -0.5, 0.0,
        0.0, 0.0,
        0.0, 0.5
        ]
        
        _translateX += 0.01
        _translateY -= 0.005
        
        
        //draw a triangle
        glVertexAttribPointer(0, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, triangle)
        glUniform2f(glGetUniformLocation(_program, "translate"), _translateX, _translateY)
        glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)
        
        glUniform2f(glGetUniformLocation(_program, "translate"), _translateX, -_translateY)
        glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)
        
        
        glUniform2f(glGetUniformLocation(_program, "translate"), -_translateX, -_translateY)
        glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)
        
        glUniform2f(glGetUniformLocation(_program, "translate"), -_translateX, _translateY)
        glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)
        
    }
}

