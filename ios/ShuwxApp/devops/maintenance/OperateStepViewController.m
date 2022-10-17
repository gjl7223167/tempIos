//
//  OperateStepViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/7/29.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "OperateStepViewController.h"
#import "WRNavigationBar.h"
#import "YSPhotoBrowser.h"


@interface OperateStepViewController ()

@end

@implementation OperateStepViewController

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.uitableView.frame = CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    self.navigationItem.title = @"操作步骤";
    
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
    
    _personNib = [UINib nibWithNibName:@"OperateStepTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    _emptyNib = [UINib nibWithNibName:@"EmptyViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    _nodataNib = [UINib nibWithNibName:@"NoDateTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    
    _hasMore = true;
    startRow = 1;
    
    [self.uitableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self getSelectDesignContentStepByContentId];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"OperateStepViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"OperateStepViewController"];
}



- (UITableView *)tabelview {
    
    return _uitableView;
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
        NSDictionary * dicOne  =   [self.dataSource objectAtIndex:indexPath.row];
        if ([dicOne objectForKey:@"commonImgs"]) {
            return 200;
        }else{
            return 100;
        }
        
        
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
        static NSString *  OperateStepTableViewCellView = @"CellId";
        //自定义cell类
        OperateStepTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OperateStepTableViewCellView];
        if (!cell) {
            cell = [_personNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
        }
        
        NSDictionary * dicOne  =   [self.dataSource objectAtIndex:indexPath.row];
        
        NSString * step_title = [dicOne objectForKey:@"step_title"];
        NSString * description = [dicOne objectForKey:@"description"];
        
        cell.operateTitle.text = step_title;
        cell.operateContent.text = description;
        
        NSMutableArray * commonImgs = [dicOne objectForKey:@"commonImgs"];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString * pictureUrl = [defaults objectForKey:@"pictureUrl"];
        NSString  * defaultImage = @"uppicture";
        
        int myLength = 10;
        for(int i = 0; i < [commonImgs count] ; i++){
            NSMutableDictionary * objectItem = [commonImgs objectAtIndex:i];
            NSString * imageUrlStr =  [objectItem  objectForKey:@"image_url"];
            UIImageView *sinaNme = [[UIImageView alloc]init];
            sinaNme.frame = CGRectMake(myLength, 10, 80, 80);
            NSString * imageUrl =  [self getPinjieNSString:pictureUrl:imageUrlStr];
            [sinaNme sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:defaultImage]];
            [sinaNme setUserInteractionEnabled:YES];
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGesture2:)];
            [sinaNme addGestureRecognizer:gesture];
            sinaNme.tag = i;
            [cell.operatePicList addSubview:sinaNme];
            
            myLength += 90;
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
        loadCell.loadLabel.text = @"";
    }else{
        loadCell.loadLabel.text = @"";
    }
    return loadCell;
}
-(void)tagGesture2:(UITapGestureRecognizer *)myTopTwo{
    UIImageView *sinaNme = myTopTwo.view;
    NSInteger tempImg =  sinaNme.tag;
    
    NSMutableArray *items = @[].mutableCopy;
    YSPhotoItem *item1 = [[YSPhotoItem alloc] initWithSourceView:sinaNme image:sinaNme.image];
    [items addObject:item1];
    
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
    
    int myInt =  indexPath.section;
    if (myInt != 0) {
        return;
    }
    
    if ([self.dataSource count] <= 0) {
        return;
    }

//    OperateStepTableViewCell *cell;
//        if (cell == nil) {
//            cell = [tableView cellForRowAtIndexPath:indexPath];
//        }
//    NSMutableArray *items = @[].mutableCopy;
//    for (int i = 0;i<cell.operatePicList.subviews.count;i++) {
//        id obj = cell.operatePicList.subviews;
//    　　if ([obj isKindOfClass:[UIImageView class]])
//    　　　　{
//        UIImageView* theButton = (UIImageView*)obj;
//           theButton.tag = i;
//        YSPhotoItem *item1 = [[YSPhotoItem alloc] initWithSourceView:theButton image:theButton.image];
//                        [items addObject:item1];
//    　　}
//    }
//       
//       [YSPhotoBrowser showBrowserWithPhotoItems:items selectedIndex:myInt imageLongPressStyleTitles:@[@"取消"] browserAlertSheetBlock:^(NSInteger imagePageIndex, NSInteger alertSheetType, UIImage * _Nullable image, NSString * _Nullable imageUrl) {
//                 if (alertSheetType == 0) {
//                     NSLog(@"保存图片");
//                 }else if (alertSheetType == 1){
//                     NSLog(@"转发图片");
//                 }else{
//                     NSLog(@"取消");
//                 }
//             }];
    
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
    
    if ([self.dataSource count] >= total) {
        _hasMore = false;
        return;
    }
    startRow ++;
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

// 操作步骤
-(void)getSelectDesignContentStepByContentId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    [diction setValue:_content_id forKey:@"content_id"];
    
    
    NSString * url = [self getPinjieNSString:baseUrl :selectDesignContentStepByContentId];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
    [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            [self setSelectDesignContentStepByContentId:myResult];
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
-(void)setSelectDesignContentStepByContentId:(NSMutableArray *) nsmutable{
    [self clearData];
    for (NSMutableDictionary * nsmuTab in nsmutable) {
        [self.dataSource addObject:nsmuTab];
    }
    [self.uitableView reloadData];
    //你的操作
    [self loadNextPage];
}

@end
