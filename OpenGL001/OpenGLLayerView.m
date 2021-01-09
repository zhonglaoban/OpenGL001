//
//  OpenGLLayerView.m
//  OpenGL001
//
//  Created by 钟凡 on 2020/12/11.
//

#import "OpenGLLayerView.h"
#import <GLKit/GLKit.h>

@interface OpenGLLayerView()

@property (nonatomic, strong) CAEAGLLayer *eaglLayer;
@property (nonatomic, strong) EAGLContext *glContext;
@property (nonatomic, assign) GLuint frameBuffer;
@property (nonatomic, assign) GLuint renderBuffer;

@end


@implementation OpenGLLayerView
+ (Class)layerClass {
    return [CAEAGLLayer class];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupLayer];
        [self setupOpenGL];
    }
    return self;
}
- (void)setupLayer {
    _eaglLayer = (CAEAGLLayer *)self.layer;
}
- (void)setupOpenGL {
    _glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:_glContext];
    glGenFramebuffers(1, &_frameBuffer);
    glGenRenderbuffers(1, &_renderBuffer);
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self drawSome];
}
- (void)drawSome {
    [EAGLContext setCurrentContext:_glContext];
    
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    //为renderBuffer分配存储空间，iOS需要这么用
    BOOL result = [_glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    if (!result) {
        printf("failed to renderbufferStorage \n");
    }
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);
    
    glClearColor(0, 0, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [self.glContext presentRenderbuffer:GL_RENDERBUFFER];
}
@end
