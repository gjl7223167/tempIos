//
//  ServiceFeedViewController.m
//  ShuwxApp
//
//  Created by apple on 2018/11/22.
//  Copyright © 2018年 tiantuosifang. All rights reserved.
//

#import "ServiceFeedViewController.h"
#import "WRNavigationBar.h"


@interface ServiceFeedViewController ()<HXPhotoViewDelegate,UIImagePickerControllerDelegate, HXPhotoViewCellCustomProtocol,UITextViewDelegate>
@end

@implementation ServiceFeedViewController

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
#ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        [self preferredStatusBarUpdateAnimation];
        [self changeStatus];
    }
#endif
}
- (UIStatusBarStyle)preferredStatusBarStyle {
#ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return UIStatusBarStyleLightContent;
        }
    }
#endif
    return UIStatusBarStyleDefault;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ServiceFeedViewController"];
    [self changeStatus];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ServiceFeedViewController"];
    [self changeStatus];
}

-(NSMutableArray *)photoList{
    if (!_photoList) {
        _photoList = [NSMutableArray array];
    }
    return _photoList;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
- (void)changeStatus {
#ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            return;
        }
    }
#endif
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.allView.frame = CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 50);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    self.navigationItem.title = @"意见反馈";
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
    
    [self initView];
}

-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initView{
    _settextView.delegate = self;
    _settextView.placeholder = @"请输入内容（必填）";
    _settextView.canPerformAction = NO;
     _settextView.backgroundColor = [UIColor whiteColor];
    
    [self photoList];
    
      [self.submitBtn addTarget:self action:@selector(setZdOk) forControlEvents:UIControlEventTouchUpInside];
    
    self.feedtishi.numberOfLines = 0;//表示label可以多行显示
    self.feedtishi.lineBreakMode = NSLineBreakByCharWrapping;//换行模式，与上面的计算保持一致。
    
    UITapGestureRecognizer *ggggg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGesture2)];
    [self.mylabelView addGestureRecognizer:ggggg];
    
    self.photoView =   [self setPhotoView:self.imageView:0];
    
    
}

-(void)tagGesture2 {
    [self.view endEditing:YES];
}
-(void)tap:(UITapGestureRecognizer*)sender{
    
}

// 转单接受
-(void)setZdOk{
    
    CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"提示" message:@"确定提交意见反馈？" ];
    
    CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
    }];
    
    CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
        [self getServiceFeedback];
        
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    
    [self presentViewController:alertVC animated:NO completion:nil];
}


-(void)getServiceFeedback{
    NSMutableDictionary * nsMuDic =   [self queryData];
    NSString *ptoken = [nsMuDic objectForKey:@"ptoken"];
    
    NSString * serviceFeedValue = _settextView.text;
    if ([self isBlankString:serviceFeedValue]) {
        [self showToast:@"意见反馈不能为空"];
       
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:serviceFeedValue forKey:@"description"];
     [diction setValue:ptoken forKey:@"token"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    
    [PPNetworkHelper openLog];
    NSString * url = [self getPinjieNSString:baseUrl :addOpinionReturnId];

    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    __weak typeof(self) weakSelf = self;
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        __strong typeof(self) strongSelf = weakSelf;
        id myResult =  [ strongSelf getMyResult:responseObject];
        NSString * myStr = [strongSelf getIntegerValue:myResult];
        if ([myResult isKindOfClass:[NSArray class]]) {
            
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
          
        }
        strongSelf.settextView.text = @"";
        [strongSelf showToast:@"上传意见反馈成功！"];
        [strongSelf setServiceFeedback:myStr];
        
    } failure:^(NSError *error) {
        //请求失败
        NSString * errorStr =  [self getError:error];
        [self showToastTwo:errorStr];
    }];
}
-(void)setServiceFeedback:(id)myResult{
    NSString * data = myResult;
    [self uploadPicture:data];
}


-(void)uploadPicture:(NSString * )data{
    
    if (nil == self.photoList || [self.photoList count] <= 0) {
        return;
    }
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
  
    NSString * fileUrl = [self getPinjieNSString:baseUrl:addOpinionImgs];
    
    __weak typeof(self) weakSelf = self;
    [self setUploadVideoPic:fileUrl :self.photoList :@{@"token":ptoken,@"opinionId":data,@"version_code":@(app_Version)} completionHandler:^( id  _Nullable responseObject, NSError * _Nullable error) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf showToast:@"上传图片成功！"];
        [strongSelf performSelector:@selector(setScan) withObject:nil afterDelay:3.0f];
        [strongSelf showToast:@"操作完成"];
    }];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
        if ([text rangeOfString:@"\n"].length > 0) {
                [textView resignFirstResponder];
                return NO;
            }
    
        int maxTextCount = 250;
        NSString *string = nil;
        if (range.length > 0) {
                if ([textView.text length] >= range.location) {
                        string = [textView.text substringToIndex:range.location];
                    }
                string = [NSString stringWithFormat:@"%@%@", string, text];
                if ([textView.text length] > range.location + range.length) {
                        string = [NSString stringWithFormat:@"%@%@", string, [textView.text substringFromIndex:range.location + range.length]];
                    }
            } else {
                    string = [NSString stringWithFormat:@"%@%@", textView.text, text];
                }
        if (string.length > maxTextCount) {
                NSRange rangeIndex = [string rangeOfComposedCharacterSequenceAtIndex:maxTextCount];
                if (rangeIndex.length == 1) {//字数超限
                        textView.text = [string substringToIndex:maxTextCount];
                    }else{
                            NSRange rangeRange = [string rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxTextCount)];
                            textView.text = [string substringWithRange:rangeRange];
                        }
                return NO;
            }
        return YES;
}

//  选择图片后回调
- (void)photoViewCurrentSelected:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    for (HXPhotoModel *photoModel in allList) {
        NSSLog(@"当前选择----> %@", photoModel.selectIndexStr);
        
    }
}
- (void)photoView:(HXPhotoView *)photoView currentDeleteModel:(HXPhotoModel *)model currentIndex:(NSInteger)index {
    NSSLog(@"%@ --> index - %ld",model,index);
}

- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
        
//    [self setPhotoAndVideoList:allList :self.photoList];
    [self.photoList removeAllObjects];
    for(HXPhotoModel * photoModel in allList){
        PHAssetResource * resource = [[PHAssetResource assetResourcesForAsset:photoModel.asset] firstObject];
        NSString * tempFilename = resource.originalFilename;
        if (photoModel.subType == HXPhotoModelMediaSubTypePhoto) {
          UIImage * myImage =  photoModel.previewPhoto;
            [self saveImageAndVideo:myImage:tempFilename];
        }else{
            NSString *tempPrivateFileURL = [resource valueForKey:@"privateFileURL"];
            NSSLog(@"videocount----%@",tempPrivateFileURL);
//            NSSLog(@"videocount----%@",tempFilename);
            if (nil != tempPrivateFileURL) {
                [self.photoList addObject:tempPrivateFileURL];
            }
        }
       
    }

}

- (void)saveImageAndVideo:(UIImage*)image:(NSString *)fileNmae {

NSArray*paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString*filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:fileNmae]];// 保存文件的名称

BOOL result =[UIImagePNGRepresentation(image)writeToFile:filePath  atomically:YES];// 保存成功会返回YES

if(result ==YES && nil != filePath) {
    NSURL *outPutURL = [NSURL fileURLWithPath:filePath];
    NSSLog(@"videocount----%@",outPutURL);
    [self.photoList addObject:outPutURL];
 }
   
}


@end
