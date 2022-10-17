//
//  DIYScanThreeViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/8/14.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "DIYScanThreeViewController.h"
#import "LBXAlertAction.h"
#import "ScanResultViewController.h"

#import "QTEventBus.h"
#import "MyEventBus.h"
#import "QTEventBus+AppModule.h"

UIColor *MainNavBarColorFour = nil;
UIColor *MainViewColorFour = nil;

@interface DIYScanThreeViewController ()

@end

@implementation DIYScanThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.cameraInvokeMsg = @"相机启动中";
      
      self.view.backgroundColor = [UIColor colorWithRed:238/255.0 green:240/255.0 blue:255/255.0 alpha:1];
         self.navigationItem.title = @"扫描二维码";
      
      UIButton  *leftButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        //    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"write_back"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(setScan) forControlEvents:UIControlEventTouchUpInside];
        leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
        [leftButton setFrame:CGRectMake(0,0,40,40)];
        //    [leftButton sizeToFit];
        
        UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        leftBarButton.enabled = YES;
        self.navigationItem.leftBarButtonItem = leftBarButton;
      
      // 设置导航栏颜色
        [self wr_setNavBarBarTintColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0]];
        
        // 设置初始导航栏透明度
        [self wr_setNavBarBackgroundAlpha:1];
        
        // 设置导航栏按钮和标题颜色
        [self wr_setNavBarTintColor:[UIColor whiteColor]];
        [self wr_setNavBarTitleColor:[UIColor whiteColor]];
}

-(void)setScan{

[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -实现类继承该方法，作出对应处理

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (!array ||  array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //经测试，可以ZXing同时识别2个二维码，不能同时识别二维码和条形码
    //    for (LBXScanResult *result in array) {
    //
    //        NSLog(@"scanResult:%@",result.strScanned);
    //    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //TODO: 这里可以根据需要自行添加震动或播放声音提示相关代码
    //...
    
    [self showNextVCWithScanResult:scanResult];
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        
        strResult = @"识别失败";
    }
    
    __weak __typeof(self) weakSelf = self;
    [LBXAlertAction showAlertWithTitle:@"扫码内容" msg:strResult buttonsStatement:@[@"知道了"] chooseBlock:^(NSInteger buttonIdx) {
        
        [weakSelf reStartDevice];
    }];
}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
    
  NSString * result =   strResult.strScanned;
    NSArray *strList = [result componentsSeparatedByString:@"\n"];  //切割后返回一个数组
    NSMutableArray *tempList = [NSMutableArray array];
    for (NSString * string in strList) {
        [tempList addObject:string];
    }
    if ([tempList count] > 1) {
        NSString * prType = [tempList objectAtIndex:1];
         BOOL isEqual =  [prType isEqualToString:@"1"];
        if (isEqual) {
             NSString * deviceList = [tempList objectAtIndex:2];
            ScanloginViewController *scanLogin = [ScanloginViewController new];
            scanLogin.imgScan = strResult.imgScanned;
            scanLogin.strScan = deviceList;
            scanLogin.strCodeType = strResult.strBarCodeType;
             [self.navigationController pushViewController:scanLogin animated:YES];
        }
           BOOL isEqualTwo =  [prType isEqualToString:@"2"];
        if (isEqualTwo) {
              NSString * deviceList = [tempList objectAtIndex:2];
            
            NSMutableDictionary * scanDiction = [NSMutableDictionary dictionary];
            [scanDiction setValue:deviceList forKey:@"deviceuuid"];
            [scanDiction setValue:@"2" forKey:@"devicetype"];
            
            MyEventBus * myEvent = [[MyEventBus alloc] init];
                   myEvent.errorId = @"ScanShowRepairViewController";
            myEvent.diction = scanDiction;
                      [[QTEventBus shared] dispatch:myEvent];
            
            [self performSelector:@selector(setScan) withObject:nil afterDelay:3.0f];
         
//        ShowRepairViewController * allWorkOrder = [ShowRepairViewController new];
//            allWorkOrder.deviceuuid = deviceList;
//            allWorkOrder.devicetype = @"2";
//                [self.navigationController pushViewController:allWorkOrder animated:YES];
        }
          BOOL isEqualThree =  [prType isEqualToString:@"3"];
        if (isEqualThree) {
            NSString * deviceList = [tempList objectAtIndex:2];
            
            NSMutableDictionary * scanDiction = [NSMutableDictionary dictionary];
            [scanDiction setValue:deviceList forKey:@"deviceuuid"];
            [scanDiction setValue:@"3" forKey:@"devicetype"];
            
            MyEventBus * myEvent = [[MyEventBus alloc] init];
                   myEvent.errorId = @"ScanShowRepairViewController";
            myEvent.diction = scanDiction;
                      [[QTEventBus shared] dispatch:myEvent];
            
            [self performSelector:@selector(setScan) withObject:nil afterDelay:3.0f];
                 
//                ShowRepairViewController * allWorkOrder = [ShowRepairViewController new];
//                    allWorkOrder.deviceuuid = deviceList;
//                    allWorkOrder.devicetype = @"3";
//                        [self.navigationController pushViewController:allWorkOrder animated:YES];
        }
    }
    
}

// json 转 字典
- (NSDictionary *)jsonToDictionary:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    

       //再重复一次 将没有双引号的替换成有双引号的
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"([:\\[,\\{])(\\w+)\\s*:"
                                                        withString:@"$1\"$2\":"
                                                        options:NSRegularExpressionSearch
                                                        range:NSMakeRange(0, [jsonString length])];

    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

// int类型的 nsstring
-(NSString *)getIntegerValue:(NSString *)normalNum{
    NSString * normalNumTwo =  [NSString stringWithFormat:@"%@", normalNum];
    NSDecimalNumber *normalNumThree = [NSDecimalNumber decimalNumberWithString:normalNumTwo];
    return [normalNumThree stringValue];
}


@end
