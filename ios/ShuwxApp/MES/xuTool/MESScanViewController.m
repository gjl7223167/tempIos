//
//  MESScanViewController.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/28.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MESScanViewController.h"
#import "WRNavigationBar.h"
#import "LBXAlertAction.h"
#import "scanInputView.h"
#import "UrlRequest.h"

#import "MesScanResultViewController.h"

#ifdef LBXScan_Define_UI
#import "LBXScanView.h"
#endif

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface MESScanViewController ()

@property (nonatomic ,assign)CGFloat cropBottom;

@property (nonatomic ,strong)UILabel *firstTipL;
@property (nonatomic ,strong)UIButton *manualInputBtn;
@property (nonatomic ,strong)UILabel *secondTipL;

@property (nonatomic ,strong)scanInputView *scanInputV;

@end

@implementation MESScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.cameraInvokeMsg = @"相机启动中";
    [self scanCodeTypeChoose];
    [self setNavi];
}

-(void)setNavi
{
    self.title = @"扫描";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIButton  *leftButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    showback mes_back
    [leftButton setImage:[UIImage imageNamed:@"mes_right_black"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(setScan) forControlEvents:UIControlEventTouchUpInside];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [leftButton setFrame:CGRectMake(0,0,40,40)];
    //    [leftButton sizeToFit];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    leftBarButton.enabled = YES;
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    // 设置导航栏颜色
    //[self wr_setNavBarBarTintColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0]];
    [self wr_setNavBarBarTintColor:[UIColor whiteColor]];
    
    // 设置初始导航栏透明度
    [self wr_setNavBarBackgroundAlpha:1];
    
    // 设置导航栏按钮和标题颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTitleColor:[UIColor blackColor]];

   
}

-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!_cropBottom) {
        CGRect cropRect = [LBXScanView getScanRectWithPreView:self.view style:self.style];
        _cropBottom = (cropRect.origin.x + cropRect.size.width)*CGRectGetHeight(self.view.frame);
    }
    //将二维码/条形码放入框内，即可自动扫描   mes_manualinput  输入条形码
    if (!_firstTipL) {
        _firstTipL = [UILabel new];
        _firstTipL.text = @"将二维码/条形码放入框内，即可自动扫描";
        _firstTipL.textColor = [UIColor whiteColor];
        _firstTipL.font = [UIFont systemFontOfSize:12];
        _firstTipL.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_firstTipL];
        
        _firstTipL.frame = CGRectMake(0, _cropBottom + 20, self.qRScanView.frame.size.width, 20);
    }
    if (!_manualInputBtn) {
        _manualInputBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_manualInputBtn setImage:[UIImage imageNamed:@"mes_manualinput"] forState:UIControlStateNormal];
        [_manualInputBtn addTarget:self action:@selector(manualInput) forControlEvents:UIControlEventTouchUpInside];
        _manualInputBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2.0 - 21, _cropBottom + 100, 42, 42);
        [self.view addSubview:_manualInputBtn];
    }
    if (!_secondTipL) {
        _secondTipL = [UILabel new];
        _secondTipL.text = @"输入条形码";
        _secondTipL.textColor = [UIColor whiteColor];
        _secondTipL.font = [UIFont systemFontOfSize:12];
        _secondTipL.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_secondTipL];
        
        _secondTipL.frame = CGRectMake(0, _cropBottom + 152, self.qRScanView.frame.size.width, 20);
    }
    
}

-(void)scanCodeTypeChoose{
    
    if (self.scanType == scanApplyInStoreInfo||self.scanType == scanApplyOutStoreInfo) {
        self.libraryType = SLT_ZXing;
        self.scanCodeType = SCT_BarCode128;
    }

}

-(void)manualInput
{
    [self.view.window addSubview:self.scanInputV];
    [self.scanInputV.contentTF becomeFirstResponder];
}

- (scanInputView *)scanInputV
{
    if (!_scanInputV) {
        _scanInputV = [[scanInputView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        WS(weakSelf)
        _scanInputV.InputContentB = ^(NSString * _Nullable input) {
            [weakSelf.scanInputV removeFromSuperview];
            if (input) {
                //确定
                [weakSelf invocateScan:input];
            }
            else{
                //取消
            }
        };
    }
    return _scanInputV;
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
    NSLog(@"strResult ====== %@",strResult);
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //TODO: 这里可以根据需要自行添加震动或播放声音提示相关代码
    //...
    [self invocateScan:strResult];
//    [self showNextVCWithScanResult:scanResult];
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
    

    
}

// json 转 字典
- (NSDictionary *)jsonToDictionary:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
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


-(void)invocateScan:(NSString *)code
{
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:
                                    code,@"code",
                                    nil];
    WS(weakSelf)
    if (self.scanType == scanWorkingProcedureMain) {
        
        [UrlRequest requestWorkScanWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
            if (result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:NO];
                    if (weakSelf.ScanBackB) {
                        weakSelf.ScanBackB(data);
                    }
                });
            }
        }];
    }
    else if(self.scanType == scanMaterialDetail)
    {
        [UrlRequest requestMaterialDetailScanWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
            if (result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:NO];

                    if (weakSelf.ScanBackB) {
                        weakSelf.ScanBackB(data);
                    }
                    
                });
            }
        }];
    }
    else if(self.scanType == scanStoreDetailRequire)
    {
        param = [NSDictionary dictionaryWithObjectsAndKeys:
                self.myId,@"id",
                code,@"code",
                nil];
        [UrlRequest requestInOutRequireScanWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
            if (result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.ScanBackB) {
                        weakSelf.ScanBackB(data);
                    }
                    [weakSelf.navigationController popViewControllerAnimated:NO];
                    
                });
            }
        }];
    }
    else if(self.scanType == scanApplyInStoreInfo)
    {
        param = [NSDictionary dictionaryWithObjectsAndKeys:
        code,@"id",
        nil];
        [UrlRequest requestInStoreRequireScanWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
            if (result) {
                if ([data isKindOfClass:[NSDictionary class]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (weakSelf.ScanBackB) {
                            weakSelf.ScanBackB(data);
                        }
                        [weakSelf.navigationController popViewControllerAnimated:NO];
                        
                    });
                }else{
                    [self popAlertMsgWithScanResult:nil];
                }
            }
        }];
    }
    else if(self.scanType == scanApplyOutStoreInfo)
    {
        param = [NSDictionary dictionaryWithObjectsAndKeys:
                 self.myDic[@"batchNo"],@"batch",
                 self.myDic[@"materialId"],@"materialId",
                 code,@"positionId",
                 self.myDic[@"qty"],@"qty",
                 nil];
        [UrlRequest requestOutStoreRequireLocationScanWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
            if (result) {
                if ([data isKindOfClass:[NSDictionary class]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (weakSelf.ScanBackB) {
                            weakSelf.ScanBackB(data);
                        }
                        [weakSelf.navigationController popViewControllerAnimated:NO];
                        
                    });
                }else{
                    [self popAlertMsgWithScanResult:nil];
                }
                
            }
        }];
    }else if(self.scanType == scanInOutCreateStore)
    {
//        code = @"02210";
        param = [NSDictionary dictionaryWithObjectsAndKeys:
                 code,@"code",
                 nil];
        [UrlRequest requestMaterialScanWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
            if (result) {
                if ([data isKindOfClass:[NSDictionary class]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (weakSelf.ScanBackB) {
                            weakSelf.ScanBackB(data);
                        }
//                        [weakSelf.navigationController popViewControllerAnimated:NO];
                        
                    });
                }else
                {
                    //没有找到此物料
                    [self popAlertMsgWithScanResult:@"没有找到物料信息"];
                }
                
            }
        }];
    }else if(self.scanType == scanInOutCreateStoreOut)
    {
//        code = @"02210";
        param = [NSDictionary dictionaryWithObjectsAndKeys:
                 code,@"code",
                 nil];
        [UrlRequest requestOutMaterialScanWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
            if (result) {
                if ([data isKindOfClass:[NSDictionary class]])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (weakSelf.ScanBackB) {
                            weakSelf.ScanBackB(data);
                        }
//                        [weakSelf.navigationController popViewControllerAnimated:NO];

                    });
                }else{
                    //没有找到
                    [self popAlertMsgWithScanResult:@"没有找到物料信息"];
                }
                
            }
        }];
    }else if(self.scanType == scanQualityInspectionPlanManage)
    {
        param = [NSDictionary dictionaryWithObjectsAndKeys:
        code,@"code",
        nil];
        [UrlRequest requestQualityInspectionScanWithParam:param completion:^(BOOL result, id  _Nonnull data, NSString * _Nonnull error) {
            if (result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.ScanBackB) {
                        weakSelf.ScanBackB(data);
                    }
                    [weakSelf.navigationController popViewControllerAnimated:NO];
                    
                });
            }
        }];
    }else if(self.scanType == scanUnqualityHandleMain)
    {
        MesScanResultViewController *vc = [[MesScanResultViewController alloc] init];
        vc.code = code;
        vc.titleArr = self.titleArr;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        
    }
    
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
