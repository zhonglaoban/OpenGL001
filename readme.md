# 在iOS中如何使用OpenGL
在iOS中如何使用`OpenGL`呢，有3种方式，它们都来自系统的库`GLKit`中。下面我们来看看如何使用他们（我们这里主要讲一些简单的初始化工作，循序渐进）。
## GLKViewController
创建一个控制器继承于`GLKViewController`，在`viewDidLoad`中设置一个`EAGLContext`，然后重写`glkView:drawInRect:`的方法，就可以在里面做OpenGL相关的绘制啦。
```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    GLKView *glView = (GLKView *)self.view;
    glView.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    GLKView *glView = (GLKView *)self.view;
    [EAGLContext setCurrentContext:glView.context];
    glClearColor(1, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
}
```
## GLKView
创建一个视图继承于`GLKView`，在`init`中设置一个`EAGLContext`，然后重写`drawRect:`的方法，也可以在里面做OpenGL相关的绘制啦。
```objc
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
```
## CAEAGLLayer
通过`CAEAGLLayer `的方式来初始化`OpenGL`相对来说，要稍微复杂一点，需要做这么几件事情，初始化Layer，初始化OpenGL，绘制相关代码。
### 初始化Layer
```objc
- (void)setupLayer {
    _eaglLayer = (CAEAGLLayer *)self.layer;
}
```
### 初始化OpenGL
创建`OpenGL`需要的上下文，创建帧缓冲，创建渲染缓冲。
渲染缓冲存储的是颜色、深度、模版等描述信息，不可直接用于渲染。
帧缓冲存储的是颜色、深度、模版描述信息处理后的直接可以显示的像素。
```objc
- (void)setupOpenGL {
    _glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:_glContext];
    glGenFramebuffers(1, &_frameBuffer);
    glGenRenderbuffers(1, &_renderBuffer);
}
```
### 绘制相关代码
`OpenGL`是一个状态机，设置哪个上下文就是在操作哪个上下文的数据，我们这里需要确保是操作当前上下文。
```objc
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
```
运行项目，可以看到3个OpenGL渲染出来的视图，它们分别是红绿蓝三个颜色。
[Github地址](https://github.com/zhonglaoban/OpenGL001)
