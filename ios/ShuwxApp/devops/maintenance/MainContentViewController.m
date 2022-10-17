//
//  MainContentViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/7/29.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainContentViewController.h"
#import "WRNavigationBar.h"

#import "QTEventBus.h"
#import "MyEventBus.h"
#import "QTEventBus+AppModule.h"
#import "YSPhotoBrowser.h"    


@interface MainContentViewController ()<UITextViewDelegate,HXPhotoViewDelegate,UIImagePickerControllerDelegate, HXPhotoViewCellCustomProtocol>

@end

@implementation MainContentViewController

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

-(NSMutableArray *)photoList{
    if (!_photoList) {
        _photoList = [NSMutableArray array];
    }
    return _photoList;
}

-(UIView *)linearOneUiView{
    if (!_linearOneUiView) {
        _linearOneUiView = [[UIView alloc] init];
        
    }
    return _linearOneUiView;
}
-(UIView *)picListView{
    if (!_picListView) {
        _picListView = [[UIView alloc] init];
        
    }
    return _picListView;
}
-(NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}
-(NSMutableArray *)spareList{
    if (!_spareList) {
        _spareList = [NSMutableArray array];
    }
    return _spareList;
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.mainScrollView.frame = CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"维保内容";
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MainContentViewController"];
    [self changeStatus];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MainContentViewController"];
    [self changeStatus];
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

-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView{
    [self photoList];
    [self.operateButton addTarget:self action:@selector(setToOperateStep) forControlEvents:UIControlEventTouchUpInside];
    
    [self.weibButton addTarget:self action:@selector(setJied) forControlEvents:UIControlEventTouchUpInside];
    
    self.weibContent.text = self.content;
    self.weibRecord.delegate = self;
    
    int is_image_int = [self.is_image intValue];
    if (is_image_int == 0) {
          [self.upPicTitBtn setTitle:@"上传图片/视频（选填）" forState:UIControlStateNormal];
    }else{
        [self.upPicTitBtn setTitle:@"上传图片/视频（必填）" forState:UIControlStateNormal];
    }
  
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
       //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
       tapGestureRecognizer.cancelsTouchesInView = NO;
       //将触摸事件添加到view上
       [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.mainScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self netPhotoList];
    
    
}

-(NSMutableArray *)netPhotoList{
    if (!_netPhotoList) {
        _netPhotoList = [NSMutableArray array];
        
        [self getSelectMasContentByContentId];
        
      self.photoView =  [self setPhotoView:self.weibPicView:51];
        
    }
    return _netPhotoList;
}



-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.weibRecord resignFirstResponder];
   
}
// 操作步骤
-(void)setToOperateStep{
    OperateStepViewController * alartDetail = [[OperateStepViewController alloc] init];
    alartDetail.content_id = self.content_id;
    [self.navigationController pushViewController:alartDetail  animated:YES];
}

// 维保条件查询
-(void)getSelectMasContentByContentId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    [diction setValue:self.content_in_id forKey:@"content_in_id"];
    
    
    NSString * url = [self getPinjieNSString:baseUrl :selectMasContentByContentId];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
    [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            [self setSelectMasContentByContentId:myResult];
        }
        if ([myResult isKindOfClass:[NSString class]]) {
            [self showToastTwo:myResult];
        }
        
    } failure:^(NSError *error) {
        //请求失败
        NSString * errorStr =  [self getError:error];
        [self showToastTwo:errorStr];
        
    }];
}
-(void)setSelectMasContentByContentId:(NSMutableDictionary *) nsmutable{
    self.spareList =  [nsmutable objectForKey:@"spareList"];
    
      
    NSMutableArray * commonImgsMul = [nsmutable objectForKey:@"commonImgs"];
    for (NSMutableDictionary * sigaction in commonImgsMul) {
         NSString * imageUrl =  [sigaction  objectForKey:@"image_url"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString * pictureUrl = [defaults objectForKey:@"pictureUrl"];
//            NSString  * defaultImage = @"uppicture";
        NSString * myImageUrl = [self getPinjieNSString:pictureUrl :imageUrl];
        if ([myImageUrl containsString:@".mp4"] || [myImageUrl containsString:@".MP4"]) {
            HXPhotoModel * hxPhotoModel = [[HXPhotoModel alloc] init];
            hxPhotoModel.networkPhotoUrl = [NSURL URLWithString:myImageUrl];
            hxPhotoModel.livePhotoVideoURL = [NSURL URLWithString:myImageUrl];
            hxPhotoModel.videoURL = [NSURL URLWithString:myImageUrl];
                  [self.netPhotoList addObject:hxPhotoModel];
        }else{
            HXPhotoModel * hxPhotoModel = [[HXPhotoModel alloc] init];
            hxPhotoModel.networkPhotoUrl = [NSURL URLWithString:myImageUrl];
                  [self.netPhotoList addObject:hxPhotoModel];
        }
        
    }
    
    [self setNetWorkPic:self.netPhotoList:self.photoView];
    
    NSString * myContent = [nsmutable objectForKey:@"content"];
    self.weibRecord.text = myContent;
    
    int allHeightTemp = 0;
    for (int i = 0;i< [self.spareList count];i++) {
        allHeightTemp += 50;
    }
    
    self.linearOneUiView.frame = CGRectMake(0, 183, SCREEN_WIDTH, allHeightTemp);
    self.linearOneUiView.backgroundColor = [UIColor whiteColor];
    [self.allView addSubview:self.linearOneUiView];
    
    int myLengththree = 0;
    for (int i = 0;i< [self.spareList count];i++) {
        NSMutableDictionary * linkItem = [self.spareList objectAtIndex:i];
        NSString * spare_name = [linkItem objectForKey:@"spare_name"];
        NSString * spare_count = [linkItem objectForKey:@"spare_count"];
        NSString * unit = [linkItem objectForKey:@"unit"];
        NSString * spare_in_id = [linkItem objectForKey:@"spare_in_id"];
        NSString * content_in_id = [linkItem objectForKey:@"content_in_id"];
        NSString * spare_model = [linkItem objectForKey:@"spare_model"];
        
        NSString * webBj = @"";
        webBj =  [self getPinjieNSString:spare_name:spare_model];
        webBj =  [self getPinjieNSString:webBj:@""];
        webBj =  [self getPinjieNSString:webBj:[self getIntegerValue:spare_count]];
        webBj =  [self getPinjieNSString:webBj:unit];
      
        UIButton *needLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        [needLabel addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
        needLabel.frame = CGRectMake(30, myLengththree, SCREEN_WIDTH - 50, 50);
        needLabel.tag = i;
        [needLabel setTitle:webBj forState:UIControlStateNormal];
        needLabel.titleLabel.font = [UIFont systemFontOfSize:14];
        
        UIImage* icon1 = [UIImage imageNamed:@"wbselectno"];
        [needLabel setImage:icon1 forState:UIControlStateNormal];
        needLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        //                UIImage* icon2 = [UIImage imageNamed:@"wbselect"];
        //                [needLabel setImage:icon2 forState:UIControlStateHighlighted];
        
        [needLabel setTitleColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        [needLabel setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
        
        myLengththree += 50;
        
        //                                              UILabel *needLabel = [[UILabel alloc]init];
        //                                              needLabel.frame = CGRectMake(30, myLengththree, 100, 30);
        //                                              needLabel.tag = i;
        //                                              needLabel.font=[UIFont systemFontOfSize:12];
        //                                              needLabel.text = content_name;
        [self.linearOneUiView addSubview:needLabel];
       
        
    }
    
    int myLength = 0;
    for(int i = 0; i < [self.spareList count] ; i++){
        myLength += 80;
    }
    
    int allHeight = allHeightTemp + 10;
    
    self.weibRecordView.transform=CGAffineTransformMakeTranslation(0, allHeight );
    self.weibPicView.transform=CGAffineTransformMakeTranslation(0, allHeight );
    
}


-(void)btnPress:(UIButton *)myButton{
    NSInteger tempButton = myButton.tag;
    BOOL isbool = [self.selectArray containsObject: @(tempButton)];
    if (isbool) {
        UIImage* icon2 = [UIImage imageNamed:@"wbselectno"];
        [myButton setImage:icon2 forState:UIControlStateNormal];
        [self.selectArray removeObject:@(tempButton)];
    }else{
        UIImage* icon2 = [UIImage imageNamed:@"wbselect"];
        [myButton setImage:icon2 forState:UIControlStateNormal];
        [self.selectArray addObject:@(tempButton)];
    }
    [self setWeibContent];
}
-(void)setWeibContent{
    NSString * weibConetent = @"";
    for (int i = 0;i< [self.spareList count];i++) {
        BOOL isbool = [self.selectArray containsObject: @(i)];
        if (isbool) {
            NSMutableDictionary * linkItem = [self.spareList objectAtIndex:i];
            NSString * spare_name = [linkItem objectForKey:@"spare_name"];
            NSString * spare_count = [linkItem objectForKey:@"spare_count"];
            NSString * unit = [linkItem objectForKey:@"unit"];
            NSString * spare_in_id = [linkItem objectForKey:@"spare_in_id"];
            NSLog(@"%@",spare_in_id);
            NSString * content_in_id = [linkItem objectForKey:@"content_in_id"];
            NSLog(@"%@",content_in_id);
            NSString * spare_model = [linkItem objectForKey:@"spare_model"];
            
             weibConetent =   [self getPinjieNSString:weibConetent:@"使用"];
            weibConetent =   [self getPinjieNSString:weibConetent:[self getIntegerValue:spare_count]];
            weibConetent =   [self getPinjieNSString:weibConetent:unit];
               weibConetent =   [self getPinjieNSString:weibConetent:spare_model];
            weibConetent =   [self getPinjieNSString:weibConetent:spare_name];
            weibConetent =   [self getPinjieNSString:weibConetent:@","];
        }
        
    }
    
    self.weibRecord.text = weibConetent;
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
        NSURL * networkUrl = photoModel.networkPhotoUrl;
        if (nil == networkUrl) {
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
        }else{
            [self.photoList addObject:networkUrl];
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


-(void)setSubmitMainContent{
   NSString * weibStr =   self.weibRecord.text;
    if ([self isBlankString:weibStr]) {
        [self showToast:@"维保记录不能为空！"];
        return;
    }
    
   
    NSMutableDictionary * dicnary = [self queryData];
       NSString *ptoken = [dicnary objectForKey:@"ptoken"];
       
       NSMutableDictionary * diction = [NSMutableDictionary dictionary];
       [diction setValue:ptoken forKey:@"token"];
      [diction setValue:self.content_in_id forKey:@"content_in_id"];
     [diction setValue:@(2) forKey:@"status"];
      [diction setValue:weibStr forKey:@"content"];
    
    int is_image_int = [self.is_image intValue];
    
    for(int i = 0; i < self.photoList.count ; i++){
        NSURL * objectItem = [self.photoList objectAtIndex:i];
        NSString * urlStr = [objectItem absoluteString];
        BOOL result1=[urlStr hasPrefix:@"http"];
        if (!result1) {
            is_image_int = 1;
            break;
        }
        is_image_int = 0;
    }
    
    NSString * upPicTitStr = self.upPicTitBtn.currentTitle;
     if ([upPicTitStr containsString:@"必填"] && self.photoList.count <= 0 && is_image_int == 1) {
         [self showToast:@"维保图片不能为空！"];
         return;
    }
  
      [diction setValue:@(is_image_int) forKey:@"files_flag"];
    
 
    [self updateImge:diction];
}

// 上传图片
-(void)updateImge:(NSMutableDictionary * )dicnary{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSString * fileUrl = [self getPinjieNSString:baseUrl:updataContextStatusFinished];
    
    NSMutableArray * submitPhotoList = [NSMutableArray array];
    for(int i = 0; i < self.photoList.count ; i++){
        NSURL * objectItem = [self.photoList objectAtIndex:i];
        NSString * urlStr = [objectItem absoluteString];
        BOOL result1=[urlStr hasPrefix:@"http"];
        if (!result1) {
            [submitPhotoList addObject:objectItem];
        }
    }
    
    NSLog(@"videocount---r%@",submitPhotoList);
    
    __weak typeof(self) weakSelf = self;
    [self setUploadVideoPic:fileUrl :submitPhotoList :dicnary completionHandler:^( id  _Nullable responseObject, NSError * _Nullable error) {
        __strong typeof(self) strongSelf = weakSelf;
        
        int  myCode  = [[responseObject objectForKey:@"code"] intValue];
          
          if (myCode == 200) {
              MyEventBus * myEvent = [[MyEventBus alloc] init];
                  myEvent.errorId = @"ProcessOrderViewController";
                     [[QTEventBus shared] dispatch:myEvent];
              
                                           [strongSelf performSelector:@selector(setScan) withObject:nil afterDelay:3.0f];
                                                  
                                                   [strongSelf showToast:@"维保内容提交成功！"];
              return;
          }
          NSString * myMessage =  [responseObject objectForKey:@"message"];
          [strongSelf showToast:myMessage];
        
    }];
    
}
// 提交
-(void)setJied{
    
    CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"提示" message:@"确定要完成吗？" ];
    
    CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
    }];
    
    CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
        [self setSubmitMainContent];
        
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    
    [self presentViewController:alertVC animated:NO completion:nil];
}

#pragma mark - Notification
- (void)textDidChangeAction:(NSNotification *)sender {
   
}
 
#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSString *text = textView.text;

    textView.text = text;
    return YES;
}
 
- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
//        textView.text = _defaultText;
    }
   
}
 
- (void)textViewDidChange:(UITextView *)textView {
    NSString *myText = textView.text;
    myText = [self disable_emoji:myText];
    textView.text = myText;
}

@end
