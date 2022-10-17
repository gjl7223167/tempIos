//
//  CarTypeViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2019/9/10.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "CarTypeViewController.h"
#import "YSPhotoBrowser.h"
#import "AppDelegate.h"

@interface CarTypeViewController ()<SDCycleScrollViewDelegate>

@end

@implementation CarTypeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"CarTypeViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"CarTypeViewController"];
}

-(NSMutableArray *)colorBtnList{
    if (!_colorBtnList) {
        _colorBtnList = [NSMutableArray array];
    }
    return _colorBtnList;
}
-(NSMutableArray *)colorList{
    if (!_colorList) {
        _colorList = [NSMutableArray array];
    }
    return _colorList;
}
-(NSMutableArray *)imageList{
    if (!_imageList) {
        _imageList = [NSMutableArray array];
    }
    return _imageList;
}
-(NSMutableArray *)titles{
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
      self.view.backgroundColor = [UIColor whiteColor];
    
    [self colorBtnList];
    [self colorList];
     [self imageList];
    [self titles];
   
     self.myscrollview.keyboardDismissMode =UIScrollViewKeyboardDismissModeOnDrag;
      self.carBtn.userInteractionEnabled=YES;
    UITapGestureRecognizer *ggggg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGesture2)];
    [self.carBtn addGestureRecognizer:ggggg];
     
       [_submitBtn addTarget:self action:@selector(setSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
    
    _qianName.placeholder = @"请输入签名内容";
    _qianName.canPerformAction = YES;
      _qianName.delegate = self;
    _qianName.layer.masksToBounds = YES;
    _qianName.layer.cornerRadius = 5;
    
    [self getSelectProductColourById];
   
}

-(void)setSubmitBtn{
    if (nil == _carDiction || ![_carDiction objectForKey:@"img_addr"]) {
        [self showToast:@"请选择一个车标！"];
        return;
    }
   NSString * logo_id = [self getIntegerValue:[_carDiction objectForKey:@"logo_id"]];
    NSString * logo_name = [_carDiction objectForKey:@"logo_name"];
   NSString * qName =  _qianName.text;
    if ([self isBlankString:qName]) {
          [self showToast:@"请输入签名！"];
        return;
    }
    
    NSString * carLogo = [self getPinjieNSString:[self getPinjieNSString:logo_id:@"-"]:logo_name];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    NSString *useName = [dicnary objectForKey:@"user_name"];
    
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:_product_name forKey:@"product_type"];
    [diction setValue:_colorSelect forKey:@"version"];
    [diction setValue:ptoken forKey:@"token"];
      [diction setValue:carLogo forKey:@"car_logo"];
       [diction setValue:useName forKey:@"cum_account"];
     [diction setValue:qName forKey:@"sign"];
     [diction setValue:_companyName forKey:@"com_name"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
   
    [PPNetworkHelper openLog];
    NSString * url = [self getPinjieNSString:_carIp :baseProductSaveCart];

    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
          
        }
        if ([myResult isKindOfClass:[NSString class]]) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
             int   myCode  = [[responseObject objectForKey:@"code"] intValue];
                if (myCode == 200) {
                    [self setToNext];
                }
            }
//            [self showToastTwo:myResult];
        }
    } failure:^(NSError *error) {
        //请求失败
        NSString * errorStr =  [self getError:error];
        [self showToastTwo:errorStr];
    }];
}
-(void)setToNext{
    CtmResultViewController *proViewVC = [CtmResultViewController new];
   
    [self.navigationController pushViewController:proViewVC animated:YES];
}

-(void)tagGesture2{
    CarLogoViewController *proViewVC = [CarLogoViewController new];
    //赋值Block，并将捕获的值赋值给UILabel
    proViewVC.returnValueBlock = ^(NSMutableDictionary *passedValue){
        _carDiction = passedValue;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString * pictureUrl = [defaults objectForKey:@"pictureUrl"];
        
        NSString * img_addr =  [passedValue objectForKey:@"img_addr"];
        NSString * imageUrl = [self getPinjieNSString:pictureUrl:img_addr];
        
        NSString * defaultImage = @"defaultpic";
        [_carBtn sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:defaultImage]];
        
    };
    [self.navigationController pushViewController:proViewVC animated:YES];
}
// 获取 颜色列表
-(void)getSelectProductImgById{
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    
    [diction setValue:_product_id forKey:@"product_id"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    
    [PPNetworkHelper openLog];
    NSString * url = [self getPinjieNSString:baseUrl :selectProductImgById];

    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            [self setSelectProductImgById:myResult];
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            
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
-(void)setSelectProductImgById:(NSMutableArray *)nsArr{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * pictureUrl = [defaults objectForKey:@"pictureUrl"];
    
    [_imageList removeAllObjects];
      [_titles removeAllObjects];
    
    for (int i = 0;i<[nsArr count];i++) {
        NSMutableDictionary * productDic = nsArr[i];
        NSString * img_addr =  [productDic objectForKey:@"img_addr"];
        NSString * imageUrl = [self getPinjieNSString:pictureUrl:img_addr];
        
        [_imageList addObject:imageUrl];
         [_titles addObject:@""];
    }
    
   
    
    self.bannerView.imageURLStringsGroup =_imageList;
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.bannerView.delegate = self;
    self.bannerView.titlesGroup = _titles;
    self.bannerView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    //    self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    self.bannerView.placeholderImage = [UIImage imageNamed:@"holder"];
}

// 获取 颜色列表
-(void)getSelectProductColourById{
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    
    [diction setValue:_product_id forKey:@"product_id"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    
    [PPNetworkHelper openLog];
    NSString * url = [self getPinjieNSString:baseUrl :selectProductColourById];

    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            [self setSelectProductColourById:myResult];
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            
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
-(void)setSelectProductColourById:(NSMutableArray *)nsArr{
    _colorList = nsArr;
    
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * pictureUrl = [defaults objectForKey:@"pictureUrl"];
   
    
    for (int i = 0;i<[nsArr count];i++) {
        NSMutableDictionary * productDic = nsArr[i];
        NSString * colour_name =  [productDic objectForKey:@"colour_name"];
        NSString * img_addr =  [productDic objectForKey:@"img_addr"];
         NSString * imageUrl = [self getPinjieNSString:pictureUrl:img_addr];
        
        [self setRedColor:colour_name:i:imageUrl];

    }
     [self getSelectProductImgById];
}
-(void)setRedColor:(NSString *)myColor:(int)position:(NSString *)myUrl{
    int i = 90 * position + 10 + 20 * position;
    UIButton * redButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    redButton.frame = CGRectMake(i, 40, 90, 40);
    redButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [redButton setTitle:myColor  forState:(UIControlStateNormal)];
    [redButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    [redButton setTitleColor:[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateSelected];
    
    UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:myUrl]]];
    
    CGSize size={25,15};
    
  image =  [self scaleToSize:image size:size];
    
      [redButton setImage:image forState:UIControlStateNormal];
    [redButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -20, 0.0, 0.0)];
    redButton.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [redButton.layer setMasksToBounds:YES];
    [redButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [redButton.layer setBorderWidth:1.0];
    redButton.layer.borderColor= [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0].CGColor;
    [redButton addTarget:self action:@selector(redAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_colorBtnList addObject:redButton];
    [self.colorView addSubview:redButton];
    
    if (position == 0) {
        redButton.layer.borderColor= [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0].CGColor;
        redButton.selected = YES;
        _colorSelect = myColor;
    }
    
}

- (void)redAction:(UIButton *)button
{
    if (button.selected) {
        
    }
    else if (!button.selected)
    {
      
     NSString * curColor =   button.currentTitle;
        for (int i = 0;i<[_colorList count];i++) {
            NSMutableDictionary * productDic = _colorList[i];
            NSString * colour_name =  [productDic objectForKey:@"colour_name"];
            if ([self getNSStringEqual:colour_name:curColor]) {
               _colorSelect = curColor;
                  button.layer.borderColor= [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0].CGColor;
                  button.selected = YES;
            }else{
              UIButton * myButton =  [_colorBtnList objectAtIndex:i];
              
                   myButton.layer.borderColor= [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0].CGColor;
                   myButton.selected = NO;
            }
        }
    }
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{

    //在视图出现的时候，将allowRotate改为1，
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotation = 0;
    
    NSMutableArray *items = @[].mutableCopy;
      
    for (NSString * myString in self.imageList) {
        YSPhotoItem *item3 = [[YSPhotoItem alloc] initWithSourceView:self.imageBg imageUrl:[NSURL URLWithString:myString]];
                   [items addObject:item3];
    }
   
    [YSPhotoBrowser showBrowserWithPhotoItems:items selectedIndex:index imageLongPressStyleTitles:@[@"取消"] browserAlertSheetBlock:^(NSInteger imagePageIndex, NSInteger alertSheetType, UIImage * _Nullable image, NSString * _Nullable imageUrl) {
              if (alertSheetType == 0) {
                  NSLog(@"保存图片");
              }else if (alertSheetType == 1){
                  NSLog(@"转发图片");
              }else{
                  NSLog(@"取消");
              }
          }];
   
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
        if ([text rangeOfString:@"\n"].length > 0) {
                [textView resignFirstResponder];
                return NO;
            }
    
        int maxTextCount = 50;
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
    int myInt = string.length;
   NSString *curString = [NSString stringWithFormat:@"%d",myInt];
    _curLabel.text = [self getPinjieNSString:curString:@"/50个字"];
        return YES;
}

@end
