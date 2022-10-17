//
//  FreeControlViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/5/8.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "FreeControlViewController.h"
#import "WRNavigationBar.h"

#import "UIView+FindFirstResponder.h"
#import "UIView+FindAttachedCell.h"

#import <UMCommon/MobClick.h>

@interface FreeControlViewController ()

@end

@implementation FreeControlViewController

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(NSMutableDictionary *)myValue{
    if (!_myValue) {
        _myValue = [NSMutableDictionary dictionary];
        
    }
    return _myValue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone; //view不需要拓展到整个屏幕
    self.navigationItem.title = @"自由下控";
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
    [MobClick beginLogPageView:@"FreeControlViewController"];
    // [self getSelectObjectUnderList];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"FreeControlViewController"];
}
-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView{
    _personNib = [UINib nibWithNibName:@"StrategyTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    _emptyNib = [UINib nibWithNibName:@"EmptyViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    _nodataNib = [UINib nibWithNibName:@"NoDateTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    
    _hasMore = true;
    startRow = 1;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self dataSource];
    [self myValue];
    [self setupRefreshData];
    
    [self.pzButton addTarget:self action:@selector(setPeizhiBtn) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加键盘弹出事件监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // 添加键盘隐藏事件监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.showsVerticalScrollIndicator = NO;
}
-(void)setPeizhiBtn{
    NSMutableDictionary * curDictionary = self.myValue;
    NSMutableArray * newArray = [NSMutableArray array];
    
    //遍历字典，遍历key值
    NSArray *keyArr = [curDictionary allKeys];
    for(NSString *key in keyArr) {
        int keyInt = [key intValue];
        NSDictionary * dicOne  =   [self.dataSource objectAtIndex:keyInt];
        NSString * data_id =  [dicOne objectForKey:@"data_id"];
        
        NSString * data_type = [dicOne objectForKey:@"data_type"];
        int data_type_int = [data_type intValue];
        
        NSString * dataValue =  [curDictionary objectForKey:key];
        
        NSMutableDictionary * subDic = [NSMutableDictionary dictionary];
        [subDic setObject:data_id forKey:@"data_id"];
        
        if (data_type_int == 0) {
            
            NSRange range = [dataValue rangeOfString:@"."];//匹配得到的下标
            int location = range.location;
            int allSize = [dataValue length];
            int result = allSize - location;
            
             NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:result raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
                                     
                                     NSDecimalNumber *a = [NSDecimalNumber decimalNumberWithString:dataValue];
                                     
                                     NSDecimalNumber *roundingNum = [a decimalNumberByRoundingAccordingToBehavior:roundUp];
                           [subDic setObject:roundingNum forKey:@"value"];
           
        }
        else   if (data_type_int == 1) {
            int bnumber = [dataValue intValue];
            [subDic setObject:@(bnumber) forKey:@"value"];
        }
        else   if (data_type_int == 2) {
            int bnumber = [dataValue intValue];
            [subDic setObject:@(bnumber) forKey:@"value"];
        }else{
            [subDic setObject:dataValue forKey:@"value"];
        }
        
        [newArray addObject:subDic];
    }
    
    if ([newArray count] <= 0) {
        [self showToast:@"请配置设定值!"];
        return;
    }
    
    NSString * jsonStr =  [self nsmudictionaryToJson:newArray];
    NSString * timeStr = [self getTimestampFromTime];
    
    [self getUnderControlByFree:jsonStr:timeStr];
}




- (void)setupRefreshData {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf clearData];
            [weakSelf getSelectObjectUnderByUnderId];
            [weakSelf.tableView.mj_header endRefreshing];
        });
    }];
}


- (UITableView *)tabelview {
    
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataSource.count && _hasMore)
    {
        return 2; // 增加一个加载更多
    }
    
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
    {
        return self.dataSource.count;
    }
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [self.dataSource count] <= 0) {
        return SCREEN_HEIGHT - NAV_HEIGHT;
    }
    if (indexPath.section == 0){
        return 150;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( [self.dataSource count] <= 0) {
        
        // 加载更多
        static NSString * noDataLoadMore = @"EmptyCall";
        
        EmptyViewCell *loadCell = [tableView dequeueReusableCellWithIdentifier:noDataLoadMore];
        if (!loadCell)
        {
            loadCell = [_emptyNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
        }
        loadCell.selectionStyle = UITableViewCellSelectionStyleNone;  //无法点击
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return loadCell;
    }
    if (indexPath.section == 0) {
        static NSString *  StrategyTableCellView = @"CellId";
        //自定义cell类
        StrategyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:StrategyTableCellView];
        if (!cell) {
            cell = [_personNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
        }
        
        NSDictionary * dicOne  =   [self.dataSource objectAtIndex:indexPath.row];
        NSString * data_name = [dicOne objectForKey:@"data_name"];
        NSString * data_type = [dicOne objectForKey:@"data_type"];
        NSObject * current_value = [dicOne objectForKey:@"current_value"];
        NSString * unit = [dicOne objectForKey:@"unit"];
        NSObject * value = [dicOne objectForKey:@"value"];
        
        // 1.给textField增加事件
              　    cell.sdValue.tag = indexPath.row;
              [cell.sdValue addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        
        if ([self isBlankString:unit]) {
            unit = @"";
        }
        
        NSString *string = [NSString stringWithFormat:@"%d",indexPath.row];
        
        NSString * myValue = @"";
        if ([value isKindOfClass:[NSString class]]) {
            myValue = [self getPinjieNSString:@"":value];
        }else{
            BOOL myBool =  [Utils dx_isNullOrNilWithObject:value];
            if (!myBool) {
                NSNumber * valueNumber = value;
                NSString *s = [valueNumber stringValue];
                myValue = s;
            }
            
        }
        cell.sdValue.text = myValue;
        
        
        cell.strateName.text = data_name;
        cell.strateDescrip.text = [self getPinjieNSString:@"描述：":data_name] ;
        
        if ([current_value isKindOfClass:[NSString class]]) {
            cell.curValue.text = [self getPinjieNSString:@"当前值：":current_value];
        }else{
            BOOL myBool =  [Utils dx_isNullOrNilWithObject:current_value];
            if (!myBool) {
                NSNumber * valueNumber = current_value;
                NSString *s = [valueNumber stringValue];
                cell.curValue.text = [self getPinjieNSString:@"当前值：":s];
            }
            
        }
        
        cell.unitValue.text = unit;
        
        cell.useCurBtn.userId = myValue;
        cell.useCurBtn.curValue = cell.sdValue;
        
        [cell.useCurBtn addTarget:self action:@selector(setUseCurValue:) forControlEvents:UIControlEventTouchUpInside];
        
        int data_type_int = [data_type intValue];
      
        if (data_type_int == 0) {
            cell.sdValue.keyboardType = UIKeyboardTypeDecimalPad;
            
        }
        if (data_type_int == 1) {
            cell.sdValue.keyboardType = UIKeyboardTypeNumberPad;
            
        }
        if (data_type_int == 2) {
            cell.sdValue.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (data_type_int == 3) {
            cell.sdValue.keyboardType = UIKeyboardTypeDefault;
        }
        if (data_type_int == 4) {
            cell.sdValue.keyboardType = UIKeyboardTypeDefault;
        }
        if (data_type_int == 5) {
            cell.sdValue.keyboardType = UIKeyboardTypeDefault;
        }
        
        
        
        return cell;
    }
    
    // 加载更多
    static NSString * noDataLoadMore = @"CellIdentifierLoadMore";
    
    NoDateTableViewCell *loadCell = [tableView dequeueReusableCellWithIdentifier:noDataLoadMore];
    if (!loadCell)
    {
        loadCell = [_nodataNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
    }
    if (!_hasMore) {
        loadCell.loadLabel.text = @"--没有更多数据了--";
    }else{
        loadCell.loadLabel.text = @"自动加载更多";
    }
    return loadCell;
}

-(void)setUseCurValue:(ProBtn *)proBtn{
    NSString * curString = proBtn.userId;
    UITextField * curValue = proBtn.curValue;
    curValue.text = curString;
    
    int myTag =  curValue.tag;
    
    NSString *text = curValue.text;
    NSLog(@"inputString: %@", text);
    
    NSString *string = [NSString stringWithFormat:@"%d",myTag];
    [self.myValue setObject:text forKey:string];
    
}


//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//
//    // 方式一
//    NSCharacterSet *charSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
//
//    // 方式二
//    // NSCharacterSet *charSet = [[NSCharacterSet  decimalDigitCharacterSet] invertedSet]];
//
//    NSString *filteredStr = [[string componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
//    if ([string isEqualToString:filteredStr]) {
//        return YES;
//    }
//    return NO;
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    int myInt =  indexPath.section;
    if (myInt != 0) {
        return;
    }
    
    if ([self.dataSource count] <= 0) {
        return;
    }
    NSMutableDictionary * dictionary  =  [self.dataSource objectAtIndex:indexPath.row];
    //    NSString * order_id = [dictionary objectForKey:@"order_id"];
    
    
}

// 2.回调
- (void)textFieldChanged:(UITextView *)textField
{
    
    int myTag =  textField.tag;
    
       NSDictionary * dicOne  =   [self.dataSource objectAtIndex:myTag];
      NSString * data_type = [dicOne objectForKey:@"data_type"];
    int data_type_int = [data_type intValue];
   
    NSString *text = textField.text;
       NSLog(@"inputString: %@", text);
    
    if (data_type_int == 0) {
           NSArray *array=[text componentsSeparatedByString:@"."];
            NSMutableArray * myArray = [NSMutableArray array];
            for (NSString * myItem in array) {
                if (![self isBlankString:myItem]) {
                    [myArray addObject:myItem];
                }
            }
            if ([array count] > 2) {
                int length = [text length] - 1;
                NSString * subString1 = [text substringToIndex:length];
                textField.text = subString1;
            }
       }
    
     text = textField.text;
    NSString *string = [NSString stringWithFormat:@"%d",myTag];
    [self.myValue setObject:text forKey:string];
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return;
    }
    if (indexPath.section == 1){
        
        if (!_hasMore) {
            return;
        }
        [self getSelectObjectUnderByUnderId];
        
    }
    
    // 加载更多
    //    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
    //    [indicator startAnimating];
    
    // 加载下一页
    //    [self loadNextPage];
}

-(void)clearData{
    [self.dataSource removeAllObjects];
    startRow = 1;
    _hasMore = true;
    
}

-(void)loadNextPage{
    
    _hasMore = false;
    
    //    if ([self.dataSource count] >= total) {
    //        _hasMore = false;
    //        return;
    //    }
    //    startRow ++;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return;
    }
    
    // 加载更多
    //    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
    //    [indicator stopAnimating];
}

-(void)getSelectObjectUnderByUnderId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    [diction setValue:self.selectId forKey:@"under_id"];
    
    NSString * url = [self getPinjieNSString:baseUrl :selectObjectUnderByUnderId];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
    [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            [self setSelectObjectUnderByUnderId:myResult];
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
-(void)setSelectObjectUnderByUnderId:(NSMutableArray *) nsmutable{
    
    for (NSMutableDictionary * nsmuTab in nsmutable) {
        [self.dataSource addObject:nsmuTab];
    }
    [self.tableView reloadData];
    //你的操作
    [self loadNextPage];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)keyboardWillShow:(NSNotification *)notification
{
    // 取出当前第一响应者
    UIView *firstResponderView = [self.tableView findFirstResponder];
    // 取出第一响应者所在的 cell
    UITableViewCell *cell = [firstResponderView findAttachedCell];
    if (!cell) {
        return;
    }
    
    // 取出 userInfo，其中包含一些与键盘相关的信息，如
    // UIKeyboardFrameEndUserInfoKey 键盘在屏幕坐标系中最终展示的矩形 frame 尺寸
    // UIKeyboardAnimationDurationUserInfoKey 键盘弹出动画时长
    // UIKeyboardAnimationCurveUserInfoKey 键盘弹出动画曲线
    NSDictionary *keyboardInfo = [notification userInfo];
    // 将键盘 frame 转换到 tableView 上
    CGRect keyboardFrame = [self.tableView.window convertRect:[keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] toView:self.tableView.superview];
    // 计算出 tableview 底部被键盘遮挡的区域
    CGFloat newBottomInset = self.tableView.frame.origin.y + self.tableView.frame.size.height - keyboardFrame.origin.y;
    UIEdgeInsets tableContentInset = self.tableView.contentInset;
    NSNumber *currentBottomTableContentInset = @(tableContentInset.bottom);
    if (newBottomInset > [currentBottomTableContentInset floatValue]) { // 的确遮挡了 tableview
        tableContentInset.bottom = newBottomInset;
        // 启动动画
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:[keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        [UIView setAnimationCurve:[keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];
        // 改变 tableView 的 contentInset
        self.tableView.contentInset = tableContentInset;
        // 滚动到第一响应者所在的 cell，UITableViewScrollPositionNone 保证以最小的滚动完全展示 cell
        NSIndexPath *selectedRow = [self.tableView indexPathForCell:cell];
        [self.tableView scrollToRowAtIndexPath:selectedRow atScrollPosition:UITableViewScrollPositionNone animated:NO];
        [UIView commitAnimations];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)changeTableViewInset
{
    UIEdgeInsets tableContentInset = self.tableView.contentInset;
    if (self.tableView.contentInset.bottom == 100) {
        tableContentInset.bottom = 0;
    } else {
        tableContentInset.bottom = 100;
    }
    self.tableView.contentInset = tableContentInset;
}

- (void)hiddenKeyboard
{
    [self resignFirstResponder];
}

-(void)getUnderControlByFree:(NSString *)oneStr:(NSString *)twoStr{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    [diction setValue:oneStr forKey:@"points_values"];
    [diction setValue:twoStr forKey:@"wid"];
    [diction setValue:@"1" forKey:@"control_type"];
    
    NSString * url = [self getPinjieNSString:baseUrl :controlApp];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
    [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
       
        int myCode = -1;
                                 if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                     myCode  = [[responseObject objectForKey:@"code"] intValue];
                                 }
                                 if (myCode == 200) {
                                     [self setUnderControlByFree:myCode];
                                     return;
                                 }
                                 NSString * myMessage =  [responseObject objectForKey:@"message"];
                                 [self showToastTwo:myMessage];
        
    } failure:^(NSError *error) {
        //请求失败
        NSString * errorStr =  [self getError:error];
        [self showToastTwo:errorStr];
        
    }];
}
-(void)setUnderControlByFree:(int)myInt{
    [self.myValue removeAllObjects];
    [self.tableView reloadData];
    
   NSString * str =  [Utils getSuccess:myInt];
    [self showToast:str];
}


@end
