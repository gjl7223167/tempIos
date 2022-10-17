//
//  RepairPositionViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/3/24.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "RepairPositionViewController.h"
#import "WRNavigationBar.h"
#import "UIButton+ImageTitleSpacing.h"

#import "QTEventBus.h"
#import "MyEventBus.h"
#import "QTEventBus+AppModule.h"



@interface RepairPositionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation RepairPositionViewController

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(NSMutableArray *)selectData{
    if (!_selectData) {
        _selectData = [NSMutableArray array];
    }
    return _selectData;
}

-(UIButton *)subBtm{
    if (!_subBtm) {
        _subBtm = [UIButton buttonWithType:UIButtonTypeCustom];
        _subBtm.backgroundColor = [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
        _subBtm.frame = CGRectMake(0, SCREEN_HEIGHT - NAV_HEIGHT - 44 - 50, SCREEN_WIDTH, 50);
        
         [_subBtm setTitle:@"确定" forState:UIControlStateNormal];
          [_subBtm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
          _subBtm.titleLabel.font = [UIFont systemFontOfSize: 14.0];
          [_subBtm addTarget:self action:@selector(setSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_subBtm];
    }
    return _subBtm;
}
-(void)setSubmitBtn{
    if ([self.selectData count] <= 0) {
           [self showToast:@"请选择一个位置"];
           return;
       }
   
    NSUInteger dataAll = self.selectData.count;
   NSMutableDictionary * diction =  [self.selectData objectAtIndex:dataAll - 1];
    
    MyEventBus * myEvent = [[MyEventBus alloc] init];
         myEvent.errorId = @"ShowRepairViewController";
     myEvent.diction = diction;
            [[QTEventBus shared] dispatch:myEvent];
    
    [self setScan];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone; //view不需要拓展到整个屏幕
    //  self.navigationItem.title = @"巡检线路详情";
    
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
    [MobClick beginLogPageView:@"RepairPositionViewController"];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"RepairPositionViewController"];
}


-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView{
    _personNib = [UINib nibWithNibName:@"RepairDeviceTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    _emptyNib = [UINib nibWithNibName:@"EmptyViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    _nodataNib = [UINib nibWithNibName:@"NoDateTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    
     tmpPosition = -1;
    [self.uitableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self dataSource];
    [self selectData];
       [self subBtm];
    [self setupRefreshData];
    [self getSelectAllPosition:0:-1:nil];
    [self setPositionViewString:-1];
}

- (void)setupRefreshData {
    __weak typeof(self) weakSelf = self;
    self.uitableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf clearData];
            [weakSelf getSelectAllPosition:0:-1:nil];
            [weakSelf.uitableView.mj_header endRefreshing];
        });
    }];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
      self.uitableView.frame = CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 50 - 50 - 50 - 50);
//       if (NAV_HEIGHT == 88) {
//                self.uitableView.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 80 - 50);
//        }else{
//                 self.uitableView.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 80 - 50);
//        }
}





- (UITableView *)tabelview {
    
    return _uitableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
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
        return 60;
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
        static NSString *  RepairDeviceCellView = @"CellId";
        //自定义cell类
        RepairDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RepairDeviceCellView];
        if (!cell) {
            cell = [_personNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
        }
        
        NSDictionary * dicOne  =   [self.dataSource objectAtIndex:indexPath.row];
        NSString * object_name = [dicOne objectForKey:@"pos_name"];
        cell.deviceName.text = object_name;
        
        if (mposition == indexPath.row) {
            cell.repairView.backgroundColor = [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
            cell.deviceName.textColor = [UIColor whiteColor];
        }else{
            cell.repairView.backgroundColor = [UIColor whiteColor];
            cell.deviceName.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
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
    loadCell.loadLabel.text = @"--没有更多数据了--";
    return loadCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSInteger myInt =  indexPath.section;
    if (myInt != 0) {
        return;
    }
    
    if ([self.dataSource count] <= 0) {
        return;
    }
    
    NSDictionary * dicOne  =   [self.dataSource objectAtIndex:indexPath.row];
    NSString * object_name = [dicOne objectForKey:@"pos_name"];
    NSLog(@"%@",object_name);
    NSString * pos_idStr = [self getIntegerValue:[dicOne objectForKey:@"pos_id"]];
    NSLog(@"%@",pos_idStr);
    int pos_id = [[dicOne objectForKey:@"pos_id"] intValue];
    int p_pos_id = [[dicOne objectForKey:@"p_pos_id"] intValue];
    
    if (p_pos_id == 0) {
        [self.selectData removeAllObjects];
        
        NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:@"0" forKey:@"pos_id"];
        [dictionary setValue:@"请选择" forKey:@"pos_name"];
        [self.selectData addObject:dictionary];
    }
    long selectPosition =  indexPath.row;
    [self  getSelectAllPosition:pos_id:selectPosition:dicOne];
    
}

#pragma mark - UITableView Delegate methods

-(void)clearData{
    [self.dataSource removeAllObjects];
    
}

-(void)getSelectAllPosition:(int)p_pos_id :(long)position :(NSDictionary *) dicOne{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    [diction setValue:@(p_pos_id) forKey:@"p_pos_id"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    
    
    NSString * url = [self getPinjieNSString:baseUrl :selectAllPosition];
     [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            [self setSelectAllPosition:myResult:position:dicOne];
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
-(void)setSelectAllPosition:(NSMutableArray *) nsmutable :(long)position :(NSDictionary *) dicOne{
    
    if (nil != dicOne) {
        NSString *   object_name = [dicOne objectForKey:@"pos_name"];
        NSString *    pos_idStr = [self getIntegerValue:[dicOne objectForKey:@"pos_id"]];
        int   pos_id = [[dicOne objectForKey:@"pos_id"] intValue];
        NSString *   longitude = [dicOne objectForKey:@"lon"];
        NSString *   latitude = [dicOne objectForKey:@"lat"];
        
        NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:pos_idStr forKey:@"pos_id"];
        [dictionary setValue:object_name forKey:@"pos_name"];
        [dictionary setValue:longitude forKey:@"longitude"];
        [dictionary setValue:latitude forKey:@"latitude"];
          [dictionary setValue:@"3" forKey:@"ordertype"];
        [self.selectData addObject:dictionary];
    }
   
    if (nsmutable.count > 0) {
     
        mposition = -1;
        [self setPositionViewString:position];
        [self clearData];
        for (NSMutableDictionary * nsmuTab in nsmutable) {
            [self.dataSource addObject:nsmuTab];
        }
        [self.uitableView reloadData];
    }else{
        mposition = position;
        [self.uitableView reloadData];
    }
}

-(void)setClearView{
    for(UIView * view in [self.positionView subviews]){
        [view removeFromSuperview];
    }
}

-(void)setPositionViewString:(long)positionStr{
    
    if ([self.selectData count] <= 0) {
        NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:@"0" forKey:@"pos_id"];
        [dictionary setValue:@"请选择" forKey:@"pos_name"];
        [self.selectData addObject:dictionary];
    }
    
    [self setClearView];
    
    int myLength = 0;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 414, 50)];
    scrollView.backgroundColor = [UIColor whiteColor]; // ScrollView 背景色，即 View 间的填充色
    [self.positionView addSubview:scrollView];
    for (NSMutableDictionary * hotdic in self.selectData) {
        NSString * hotString = [hotdic objectForKey:@"pos_name"];
        UIFont * font = [UIFont systemFontOfSize: 14.0];
        CGSize titleSize = [hotString sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, 50)];
        int width = titleSize.width + 10;
        
        myLength += width;
    }
    
    //向 ScrollView 中加入第一个 View，View 的宽度 200 加上两边的空隙 5 等于 ScrollView 的宽度
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(10,0,myLength,50)];
    view1.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:view1];
    scrollView.contentSize = CGSizeMake(myLength, 50);
    NSString *positionString = [NSString stringWithFormat:@"%ld", positionStr];
    int myLengthtwo = 0;
    for (NSMutableDictionary * hotdic in self.selectData) {
        NSString * hotString = [hotdic objectForKey:@"pos_name"];
        NSString * pos_id = [hotdic objectForKey:@"pos_id"];
        ProBtn *button = [[ProBtn alloc] init];
        button.userId = hotString;
        button.createUserId = pos_id;
        button.myposition = positionString;
        UIFont * font = [UIFont systemFontOfSize: 14.0];
        CGSize titleSize = [hotString sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, 50)];
        int width = titleSize.width + 10;
        
//        if (width < 100) {
//            width = 100;
//        }
        
        button.frame = CGRectMake(myLengthtwo,0, width, 50);
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [button setTitle:hotString forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        
        UIImage * myImage = [UIImage imageNamed:@"posjx"];
        [button setImage:myImage forState:UIControlStateNormal];
        
        [view1 addSubview:button];
        
        CGFloat space = 20.0;
        
        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleBottom
                                imageTitleSpace:space];
        
        [button addTarget:self action:@selector(setPositionList:) forControlEvents:UIControlEventTouchUpInside];
        
        myLengthtwo += width;
    }
    
}
-(void)setPositionList:(ProBtn *)proBtn{
    ProBtn * myProBtn = proBtn;
    NSString * pos_name =  myProBtn.userId;
    NSString * posInt = myProBtn.createUserId;
    long positionInt = [myProBtn.myposition longLongValue];
    
    int myInt = 0;
    for (int i = 0;i< [self.selectData count];i++) {
        NSMutableDictionary * hotdic = [self.selectData objectAtIndex:i];
        NSString * hotString = [hotdic objectForKey:@"pos_name"];
        if ([self getNSStringEqual:pos_name:hotString]) {
            myInt = i;
            
        }
    }
    
    NSMutableArray * curSelect = [NSMutableArray array];
    for (int i = 0;i< [self.selectData count];i++) {
        NSMutableDictionary * hotdic = [self.selectData objectAtIndex:i];
        NSString * hotString = [hotdic objectForKey:@"pos_name"];
        NSLog(@"%@",hotString);
        if (i <= myInt) {
            [curSelect addObject:hotdic];
        }
        
    }
    self.selectData = curSelect;
    
    [self setPositionViewString:positionInt];
    
    int pos_id = [posInt intValue];
    [self  getSelectAllPosition:pos_id:positionInt:nil];
}


@end
