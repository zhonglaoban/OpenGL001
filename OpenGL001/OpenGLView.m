//
//  OpenGLView.m
//  OpenGL001
//
//  Created by 钟凡 on 2020/12/11.
//

#import "OpenGLView.h"

@implementation OpenGLView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupOpenGL];
    }
    return self;
}
- (void)setupOpenGL {
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
}
- (void)drawRect:(CGRect)rect {
    [EAGLContext setCurrentContext:self.context];
    glClearColor(0, 1, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
}
@end
