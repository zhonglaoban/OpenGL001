//
//  ViewController.m
//  OpenGL001
//
//  Created by 钟凡 on 2020/12/11.
//

#import "ViewController.h"
#import "OpenGLViewController.h"
#import "OpenGLView.h"
#import "OpenGLLayerView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    OpenGLViewController *vc = [[OpenGLViewController alloc] init];
    [self addChildViewController:vc];
    
    OpenGLView *view = [[OpenGLView alloc] init];
    OpenGLLayerView *lView = [[OpenGLLayerView alloc] init];
    
    [self.stackView addArrangedSubview:vc.view];
    [self.stackView addArrangedSubview:view];
    [self.stackView addArrangedSubview:lView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
