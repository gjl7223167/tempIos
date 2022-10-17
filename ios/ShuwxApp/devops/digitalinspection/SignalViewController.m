//
//  SignalViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/27.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "SignalViewController.h"
#import "SignatureView.h"
#import "AppDelegate.h"
#import "UIDevice+Orientation.h"

#import "WRNavigationBar.h"



@interface SignalViewController ()<UINavigationControllerDelegate>
@property (nonatomic, strong) SignatureView *signatureView;
@property (nonatomic, strong) UIView * allView;
@end

@implementation SignalViewController

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];

    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //   [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.delegate = self;

    self.navigationItem.title = @"签名";
    
    UIButton  *leftButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    //    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"showback"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(setScan) forControlEvents:UIControlEventTouchUpInside];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [leftButton setFrame:CGRectMake(20,20,40,40)];
    //    [leftButton sizeToFit];
    
//    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    leftBarButton.enabled = YES;
//    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    [self.view addSubview:leftButton];
    
    // 设置导航栏颜色
    [self wr_setNavBarBarTintColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0]];
    
    // 设置初始导航栏透明度
    [self wr_setNavBarBackgroundAlpha:1];
    
    // 设置导航栏按钮和标题颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTitleColor:[UIColor whiteColor]];
    
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    //允许转成横屏
//    appDelegate.allowRotation = 1;
//    //调用横屏代码
//    [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight];
    
    self.allView = [[UIView alloc] init];
   self. allView.frame = CGRectMake(10,10,SCREEN_WIDTH - 20,300);
      [self.view addSubview:self.allView];
    
  self.  allView.layer.cornerRadius = 10;
   self.    allView.clipsToBounds = YES;
   self.    allView.layer.borderWidth = 1;
   self.    allView.layer.borderColor = [[UIColor colorWithRed:193.0/255.0 green:195.0/255.0 blue:225.0/255.0 alpha:1] CGColor];
    
    self.signatureView = [[SignatureView alloc] init];
   self. signatureView.frame = CGRectMake(10,10,SCREEN_WIDTH - 20,300);
    [self.allView addSubview:self.signatureView];
    
    
    self.saveBtn.layer.cornerRadius = 8;
    self.saveBtn.clipsToBounds = YES;
    
    self.clearBtn.layer.cornerRadius = 8;
    self.clearBtn.clipsToBounds = YES;
    self.clearBtn.layer.borderWidth = 1;
    self.clearBtn.layer.borderColor = [[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255.0/225.0 alpha:1] CGColor];
    
    [self initView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
   
    self.allView.frame = CGRectMake(30, 10, SCREEN_WIDTH - 60, 270);
    self. signatureView.frame = CGRectMake(10,10,SCREEN_WIDTH - 60,270);
    self.kongjView.frame = CGRectMake(30, 300, SCREEN_WIDTH - 60, 40);

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"SignalViewController"];
    
    //在视图出现的时候，将allowRotate改为1，
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotation = 1;
    [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"SignalViewController"];
    
    //在视图出现的时候，将allowRotate改为1，
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotation = 0;
    [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // do something before rotation
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        //  屏幕从竖屏变为横屏时执行
       
    }else{
        //  屏幕从横屏变为竖屏时执行
    
    }

}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // do something after rotation
}

-(void)setScan{
    
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appDelegate.allowRotation = 0;//关闭横屏仅允许竖屏
//    //切换到竖屏
//    [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
    
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}

- (void)initView{
    [self.saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.clearBtn addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.navigationController) {
        //禁用侧滑手势方法
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.navigationController) {
        //打开侧滑手势方法
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)clear {
    [self.signatureView clearScreen];
}

- (void)revoke {
    [self.signatureView revoke];
}

- (void)save {
    NSLog(@"保存图片: %@",self.signatureView.image);
    
    [self saveImage:self.signatureView.image];
}



- (void)saveImage:(UIImage*)image {
    
    NSArray*paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString*filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"signal.png"]];// 保存文件的名称
    
    BOOL result =[UIImagePNGRepresentation(image)writeToFile:filePath  atomically:YES];// 保存成功会返回YES
    
    if(result ==YES) {
        
            NSLog(@"保存成功");
        
        __weak typeof(self) weakself = self;
          if (weakself.returnValueBlock) {
              //将自己的值传出去，完成传值
              weakself.returnValueBlock(image,filePath);
          }
        [self setScan];
     }
    
}

- (void)getImage {
    
    NSArray*paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);NSString*filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"signal.png"]];
    
    // 保存文件的名称
    
    UIImage*img = [UIImage imageWithContentsOfFile:filePath];
    
    NSLog(@"=== %@", img);
    
}



#pragma mark - 自定义处理手势冲突接口
#if 0
- (BOOL)cw_gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;// 可以在这里实现自己需要处理的手势冲突逻辑
}
#endif

@end
