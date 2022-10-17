//
//  LookPointView.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/3/18.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#import "LookPointView.h"

#import "EmptyViewCell.h"
#import "NoDateTableViewCell.h"
#import "LookSubmitOneTableViewCell.h"
#import "LookSubmitTwoTableView.h"
#import "LookSubmitThreeTableViewCell.h"
#import "LookSubmitFourTableViewCell.h"
#import "ShowPictureListTableViewCell.h"
#import "QianmingTableViewTwoCell.h"

@implementation LookPointView{
    UINib *_personNib;
    UINib *_personNibTwo;
    UINib *_personNibThree;
    UINib *_personNibFour;
    UINib *_personNibFive;
    UINib *_personNibSix;
}

-(NSMutableArray *)dataSource{
    if (!_dataSourceTwo) {
        _dataSourceTwo = [NSMutableArray array];
        
    }
    return _dataSourceTwo;
}

-(NSMutableDictionary *)pointDic{
    if (!_pointDic) {
        _pointDic = [NSMutableDictionary dictionary];
    }
    return _pointDic;
}

-(void)setAboveBtn{
    HitPointViewController * hitPoint = (HitPointViewController *)_myViewController;
    [hitPoint setAboveValue];
}
-(void)setNextBtn{
    HitPointViewController * hitPoint = (HitPointViewController *)_myViewController;
    [hitPoint setNextValue];
}

-(UITableView *)uitableView{
    if (!_uitableView) {
        _uitableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 220, SCREEN_WIDTH, SCREEN_HEIGHT - 220 - NAV_HEIGHT - 50) style:UITableViewStylePlain];
        _uitableView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:247/255.0 alpha:1.0];
        
        // 声明 tableView 的代理和数据源
        _uitableView.delegate = self;
        _uitableView.dataSource = self;
        
    }
    return _uitableView;
}


-(void)setLookPoint{
    NSString * pointXhStr =  [self.pointDic objectForKey:@"pointXh"];
          NSString * pointNmStr =  [self.pointDic objectForKey:@"pointNm"];
           NSString * pointJcmbStr =  [self.pointDic objectForKey:@"pointJcmb"];
            NSString * pointWzxxStr =  [self.pointDic objectForKey:@"pointWzxx"];
    NSString * target_type =  [self.pointDic objectForKey:@"target_type"];
    NSString * target_position_detail =  [self.pointDic objectForKey:@"target_position_detail"];
    NSString * target_device_name =  [self.pointDic objectForKey:@"target_device_name"];
    NSString * point_name =  [self.pointDic objectForKey:@"point_name"];
    NSString * pos_name =  [self.pointDic objectForKey:@"pos_name"];
    NSString * target_device_code = [self.pointDic objectForKey:@"target_device_code"];
    
    if ([self isBlankString:target_device_code]) {
        target_device_code = @"";
    }
    
    self.pointNm.text = pointNmStr;
    self.deviceName.text = target_device_name;
    self.deviceCode.text = target_device_code;
    
    self.isShoud.frame = CGRectMake(SCREEN_WIDTH - 80, 0, 50, 20);
    
//    self.pointJcmb.frame = CGRectMake( 80, 0, 200, 50);
    self.pointJcmb.lineBreakMode = NSLineBreakByWordWrapping;
    self.pointJcmb.numberOfLines = 0;
    self.pointJcmb.preferredMaxLayoutWidth = SCREEN_WIDTH;
    
    self.pointWzxx.lineBreakMode = NSLineBreakByWordWrapping;
    self.pointWzxx.numberOfLines = 0;
    self.pointWzxx.preferredMaxLayoutWidth = SCREEN_WIDTH;
    
    self.pointNm.lineBreakMode = NSLineBreakByWordWrapping;
    self.pointNm.numberOfLines = 0;
    self.pointNm.preferredMaxLayoutWidth = SCREEN_WIDTH;
   
    int target_type_int = [target_type intValue];
 
    if (target_type_int == 1) {
        self.pointJcmb.text =  [self getPinjieNSString:pos_name:target_position_detail];
//        self.pointJcmb.text = @"你好你好你好你好你好你好你好你好你好你好你好/n你好";
        [self.jxmbView setHidden:YES];
        [self.deviceView setHidden:YES];
        
        [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(150);
        }];
        [self.deviceView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
//        [self.uitableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(180);
//        }];
        CGRect newRect = CGRectMake(0, 200,SCREEN_WIDTH, SCREEN_HEIGHT - 200 - NAV_HEIGHT - 50);
                          self.uitableView.frame = newRect;
        
//        CGRect bottomRect = CGRectMake(0, 0 ,SCREEN_WIDTH, SCREEN_HEIGHT);
//        self.allView.frame = bottomRect;
        
    }else{
        self.pointJcmb.text = target_device_name;
        self.pointWzxx.text = [self getPinjieNSString:pos_name:target_position_detail];
        [self.jxmbView setHidden:NO];
        [self.deviceView setHidden:NO];
        
        [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(170);
        }];
        [self.deviceView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(150);
        }];
     
        CGRect newRect = CGRectMake(0, 350,SCREEN_WIDTH, SCREEN_HEIGHT - 350 - NAV_HEIGHT - 50);
                          self.uitableView.frame = newRect;
        
//        CGRect bottomRect = CGRectMake(0, 0 ,SCREEN_WIDTH, SCREEN_HEIGHT);
//        self.allView.frame = bottomRect;
       
    }
    
}

-(void)setList:(NSMutableArray *)dataSour{

//    dispatch_async(dispatch_get_main_queue(), ^{

       // UI更新代码
        self.dataSourceTwo = dataSour;
        [self setLookPoint];
        [self.uitableView reloadData];

//    });
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self addSubview:[self uitableView]];
    
    [self initView];
}

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
       
        LookPointView *aaView = [[[NSBundle mainBundle] loadNibNamed:@"LookPointView" owner:self options:nil] lastObject];
        
        _pointNm = aaView.pointNm;
        _pointJcmb = aaView.pointJcmb;
        _pointWzxx = aaView.pointWzxx;
        _isShoud = aaView.isShoud;
        _jxmbView = aaView.jxmbView;
        _xjView = aaView.xjView;
        _topView = aaView.topView;
        _allView = aaView.allView;
        _deviceName = aaView.deviceName;
        _deviceView = aaView.deviceView;
        _deviceCode = aaView.deviceCode;
        _nextBtn = aaView.nextBtn;
        _bottomView = aaView.bottomView;
        _aboveBtn = aaView.aboveBtn;
        [aaView addSubview:[self uitableView]];
    
        [self addSubview:aaView];
        
         
        
        [self initView];
    }
    return self;
}
-(void)initView{
    [self dataSource];
    
    _personNib = [UINib nibWithNibName:@"LookSubmitOneTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    _personNibTwo = [UINib nibWithNibName:@"LookSubmitTwoTableView" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    _personNibThree = [UINib nibWithNibName:@"LookSubmitThreeTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    _personNibFour = [UINib nibWithNibName:@"LookSubmitFourTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    _personNibFive = [UINib nibWithNibName:@"ShowPictureListTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    _personNibSix = [UINib nibWithNibName:@"QianmingTableViewTwoCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    
    [self.uitableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.uitableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.uitableView.showsVerticalScrollIndicator = NO;
    
    
    [self.aboveBtn addTarget:self action:@selector(setAboveBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.nextBtn addTarget:self action:@selector(setNextBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self pointDic];
    
//    self.topOneView.frame = CGRectMake(70, 0, SCREEN_WIDTH - 120, 30);
//    self.pointNm.frame = CGRectMake(70, 0,  120, 30);
        
    
    self.isShoud.textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255/225.0 alpha:1];
    self.isShoud.backgroundColor = [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/225.0 alpha:1];
    self.isShoud.layer.masksToBounds = YES;
    self.isShoud.layer.cornerRadius = 10;

    
    int check_type_int = [self.check_type intValue];
    if (check_type_int == 1) {
        self.isShoud.text = @"手动";
    }else{
        self.isShoud.text = @"二维码";
    }
    
}

// uitableView

- (UITableView *)tabelview {
    
    return _uitableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSourceTwo count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger position = indexPath.row;
    
    NSDictionary * diction  =   [self.dataSourceTwo objectAtIndex:indexPath.row];
    int item_type =  [[diction objectForKey:@"item_type"] intValue];
    
    if (item_type == 4) {
        return 120;
    }
    if (item_type == 5) {
        return 170;
    }
    if (item_type == 6) {
        return 150;
    }
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *  SubmitOneCellView = @"CellId";
    NSInteger position = indexPath.row;
    
    NSDictionary * diction  =   [self.dataSourceTwo objectAtIndex:indexPath.row];
    int item_type =  [[diction objectForKey:@"item_type"] intValue];
    NSString * sortStr =  [diction objectForKey:@"sort"];
    NSString * item_name =  [diction objectForKey:@"item_name"];
    int is_reauired =  [[diction objectForKey:@"is_reauired"] intValue];
    
    
    if (item_type == 1) {
        //自定义cell类
        LookSubmitOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SubmitOneCellView];
        if (!cell) {
            cell = [_personNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
        }
        NSString * item_content_json_string = [diction objectForKey:@"item_content_json"];
        NSMutableDictionary * item_content_json =  [self jsonToDictionary:item_content_json_string];
        NSMutableArray * pointOptionArr = [item_content_json objectForKey:@"pointOptionArr"];
        
        if (is_reauired == 1) {
            [cell.isReqest setHidden:NO];
        }else{
            [cell.isReqest setHidden:YES];
        }
        
        NSString *string = [NSString stringWithFormat:@"%d",position + 1];
        
        NSString * selectString = [diction objectForKey:@"content"];
        
        cell.dataSource = pointOptionArr;
        cell.titleNumber.text = string;
        cell.titleName.text = item_name;
        cell.selectStr = selectString;
        [cell.collectionView reloadData];
        
        return cell;
    }
    if (item_type == 2) {
        //自定义cell类
        LookSubmitTwoTableView *cell = [tableView dequeueReusableCellWithIdentifier:SubmitOneCellView];
        if (!cell) {
            cell = [_personNibTwo instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
        }
        if (is_reauired == 1) {
            [cell.isReqest setHidden:NO];
        }else{
            [cell.isReqest setHidden:YES];
        }
        
        NSString * item_content_json_string = [diction objectForKey:@"item_content_json"];
        NSMutableDictionary * item_content_json =  [self jsonToDictionary:item_content_json_string];
        NSMutableArray * pointOptionArr = [item_content_json objectForKey:@"pointOptionArr"];
        
        NSMutableArray * curArr = [NSMutableArray array];
        for (NSMutableDictionary * tempDic in pointOptionArr) {
            NSMutableDictionary * myTem = [NSMutableDictionary dictionary];
            [myTem setValue:@(0) forKey:@"temp"];
            NSArray *arr = [tempDic allKeys];
            for (NSString * string in arr) {
                [myTem setValue:tempDic forKey:string];
            }
            [curArr addObject:myTem];
        }
        
        NSString *string = [NSString stringWithFormat:@"%d",position + 1];
        
          NSString * selectString = [diction objectForKey:@"content"];
        
        cell.dataSource = curArr;
        cell.titleNumber.text = string;
        cell.titleName.text = item_name;
         cell.selectStr = selectString;
        [cell.collectionView reloadData];
        
        return cell;
    }
    if (item_type == 3) {
        //自定义cell类
        LookSubmitFourTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SubmitOneCellView];
        if (!cell) {
            cell = [_personNibFour instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
        }
        if (is_reauired == 1) {
            [cell.isReqest setHidden:NO];
        }else{
            [cell.isReqest setHidden:YES];
        }
        
        
        NSString * item_name =  [diction objectForKey:@"item_name"];
          NSString * selectString = [diction objectForKey:@"content"];
        
        NSString * item_content_json_string = [diction objectForKey:@"item_content_json"];
        NSMutableDictionary * item_content_json =  [self jsonToDictionary:item_content_json_string];
        NSMutableArray * pointOptionArr = [item_content_json objectForKey:@"pointOptionArr"];
        
        NSString *string = [NSString stringWithFormat:@"%d",position + 1];
        
        cell.titleNumber.text = string;
        cell.titleName.text = item_name;
        NSString * unit = [item_content_json objectForKey:@"unit"];
        cell.shurkUnit.text = unit;
          cell.selectStr = selectString;
        cell.shurkValue.text = selectString;
        
        return cell;
    }
    if (item_type == 4) {
        //自定义cell类
        LookSubmitThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SubmitOneCellView];
        if (!cell) {
            cell = [_personNibThree instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
        }
        if (is_reauired == 1) {
            [cell.isReqest setHidden:NO];
        }else{
            [cell.isReqest setHidden:YES];
        }
        
        
        NSString * item_name =  [diction objectForKey:@"item_name"];
          NSString * selectString = [diction objectForKey:@"content"];
        
        NSString *string = [NSString stringWithFormat:@"%d",position + 1];
        
        cell.titleNumber.text = string;
        cell.titleName.text = item_name;
          cell.selectStr = selectString;
        cell.textView.text = selectString;
        
        return cell;
    }
    if (item_type == 5) {
        //自定义cell类
        ShowPictureListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SubmitOneCellView];
        if (!cell) {
            cell = [_personNibFive instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
        }
        cell.curViewController = self.myViewController;
        if (is_reauired == 1) {
            [cell.isReqest setHidden:NO];
        }else{
            [cell.isReqest setHidden:YES];
        }
        
        NSString * item_name =  [diction objectForKey:@"item_name"];
        
        NSString *string = [NSString stringWithFormat:@"%d",position + 1];
        
        NSMutableArray * pointImgVoList = [diction objectForKey:@"pointImgVoList"];
        
        cell.titleNumber.text = string;
        cell.titleName.text = item_name;
        [cell setUpdatePicList:pointImgVoList];
        return cell;
    }
    if (item_type == 6) {
        //自定义cell类
        QianmingTableViewTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:SubmitOneCellView];
        if (!cell) {
            cell = [_personNibSix instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
        }
        
        NSString * item_name =  [diction objectForKey:@"item_name"];
        NSString *string = [NSString stringWithFormat:@"%d",position + 1];
        
        
        cell.titleNumber.text = string;
        cell.titleName.text = item_name;
        cell.myViewController = self;
        cell.curPosition = string;
        
       NSMutableArray * pointImgVoList = [diction objectForKey:@"pointImgVoList"];
        NSMutableDictionary * mutableDic =  [pointImgVoList objectAtIndex:0];
            NSString * image_url =  [mutableDic objectForKey:@"image_url"];
              
              NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 NSString * pictureUrl = [defaults objectForKey:@"pictureUrl"];
                 NSString * imageUrl =  [self getPinjieNSString:pictureUrl:image_url];

        UIImage * dicOne  =   [UIImage imageNamed:@"addpicture"];
        [cell.imageView sd_setImageWithURL:imageUrl placeholderImage:dicOne];
     
        cell.imageView.imageurl = imageUrl;
        cell.imageView.userInteractionEnabled = YES;//打开用户交互
        //初始化一个手势
        UIGestureRecognizer *singleTap = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        //为图片添加手势
        [cell.imageView addGestureRecognizer:singleTap];
        
        return cell;
    }
    
    //自定义cell类
    SubmitdOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SubmitOneCellView];
    if (!cell) {
        cell = [_personNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
    }
    
    return cell;
}

//点击事件
-(void)singleTapAction:(UIGestureRecognizer *) recognizer
{
//具体的实现
    ProImageView *  proImageView =  [recognizer view];
    NSString * imageUrl = proImageView.imageurl;

          
//     KSPhotoItem *item = [KSPhotoItem itemWithSourceView:proImageView imageUrl:[NSURL URLWithString:imageUrl]];
//                  [items addObject:item];
//
          
    NSMutableArray *items = @[].mutableCopy;
          NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             NSString * pictureUrl = [defaults objectForKey:@"pictureUrl"];

    YSPhotoItem *item3 = [[YSPhotoItem alloc] initWithSourceView:proImageView imageUrl:[NSURL URLWithString:imageUrl]];
    [items addObject:item3];

  [YSPhotoBrowser showBrowserWithPhotoItems:items selectedIndex:0 imageLongPressStyleTitles:@[@"取消"] browserAlertSheetBlock:^(NSInteger imagePageIndex, NSInteger alertSheetType, UIImage * _Nullable image, NSString * _Nullable imageUrl) {
            if (alertSheetType == 0) {
                NSLog(@"保存图片");
            }else if (alertSheetType == 1){
                NSLog(@"转发图片");
            }else{
                NSLog(@"取消");
            }
        }];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSInteger position = indexPath.row;
    
    //    NSDictionary * diction  =   [_dataSourceTwo objectAtIndex:indexPath.row];
    //    int item_type =  [[diction objectForKey:@"item_type"] intValue];
    //    if (item_type == 6) {
    //        QianmingTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //
    //        SignalViewController * alartDetail = [[SignalViewController alloc] init];
    //        //赋值Block，并将捕获的值赋值给UILabel
    //        alartDetail.returnValueBlock = ^(UIImage *passedValue){
    //            [cell.imageView sd_setImageWithURL:@"" placeholderImage:passedValue];
    //            NSMutableArray * curArr = [NSMutableArray array];
    //            [curArr addObject:passedValue];
    //            [self.myValue setObject:curArr forKey:cell.curPosition];
    //        };
    //        [self.navigationController pushViewController:alartDetail  animated:YES];
    //    }
}

// json 转 字典
- (NSDictionary *)jsonToDictionary:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSMutableString *responseString = jsonString;

                 NSString *character = nil;

                for (int i = 0; i < responseString.length; i ++) {

                         character = [responseString substringWithRange:NSMakeRange(i, 1)];

                         if ([character isEqualToString:@"\\"])

                                 [responseString deleteCharactersInRange:NSMakeRange(i, 1)];

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

//拼接字符串
-(NSString *) getPinjieNSString:(NSString *) fromStr:(NSString *) toStr{
    if ([self isBlankString:fromStr]){
        fromStr = @"";
    }
    if ([self isBlankString:toStr]){
        toStr = @"";
    }
    NSString * pinjieStr = @"";
    pinjieStr = [fromStr stringByAppendingString:toStr];
    return pinjieStr;
}
//判断不为空
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
