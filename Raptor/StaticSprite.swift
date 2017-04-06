//
//  StaticSprite.swift
//  Raptor
//
//  Created by admin on 4/6/17.
//  Copyright © 2017 JPDaines. All rights reserved.
//


import GLKit

extension Sprite{
    
    // static pieces of the class that run once
    static internal var _program: GLuint = 0
    static private let _quad: [Float] = [
        -0.5, -0.5,
        0.5, -0.5,
        -0.5, 0.5,
        0.5, 0.5
    ]
    
    internal static func setup(){
        
        let vertexShaderSource: NSString = "attribute vec2 position; \n uniform vec2 translate; \n  uniform vec2 scale; \n"
            + "void main() \n"
            + "{ \n" +
            "    gl_Position = vec4(position.x * scale.x + translate.x, position.y * scale.y + translate.y, 0.0, 1.0);  \n" +
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
        
        let fragmentShaderSource: NSString = " uniform highp vec4 color; \n " +
            "void main() \n{ \n" +
            "    gl_FragColor = color;  \n" +
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
        
        //then you can point to the shapes you made in memory
        glVertexAttribPointer(0, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, _quad)
    }
}
