//
//  MainWorkJournalViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/7/25.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainWorkJournalViewController.h"
#import "WRNavigationBar.h"

#import <UMCommon/MobClick.h>

@interface MainWorkJournalViewController ()

@end

@implementation MainWorkJournalViewController

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    _tableView.frame = CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:243/255.0 blue:255/255.0 alpha:1.0];
    
    self.navigationItem.title = @"工单日志";
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
    [MobClick beginLogPageView:@"MainWorkJournalViewController"];
    // [self getSelectObjectUnderList];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MainWorkJournalViewController"];
}
-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView{
    _personNib = [UINib nibWithNibName:@"WorkJournalViewTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    _emptyNib = [UINib nibWithNibName:@"EmptyViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    _nodataNib = [UINib nibWithNibName:@"NoDateTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    
    _hasMore = true;
    startRow = 1;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self dataSource];
    
//    [self setupRefreshData];
    
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    //    [self.dataSource removeAllObjects];
    //    for (NSMutableDictionary * dicStr in self.fixOrderFlowList) {
    //        [self.dataSource addObject:dicStr];
    //    }
    //      [self.tableView reloadData];
    
    [self getSelectFixOrderFlowByOrderId];
}





//- (void)setupRefreshData {
//    __weak typeof(self) weakSelf = self;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [weakSelf clearData];
//            //  [self getSelectObjectUnderByUnderId];
//            [weakSelf.tableView.mj_header endRefreshing];
//        });
//    }];
//}


- (UITableView *)tabelview {
    
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataSource.count && _hasMore)
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
    if ( [_dataSource count] <= 0) {
        return SCREEN_HEIGHT - NAV_HEIGHT;
    }
    if (indexPath.section == 0){
        return 100;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( [_dataSource count] <= 0) {
        
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
        static NSString *  JournalTableCellView = @"CellId";
        //自定义cell类
        WorkJournalViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JournalTableCellView];
        if (!cell) {
            cell = [_personNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
        }
        
        NSDictionary * dicOne  =   [_dataSource objectAtIndex:indexPath.row];
        NSString * operate_man_name = [dicOne objectForKey:@"operate_man_name"];
        NSString * create_time = [dicOne objectForKey:@"create_time"];
        int operate_type = [[dicOne objectForKey:@"operate_type"] intValue];
        int operate_man = [[dicOne objectForKey:@"operate_man"] intValue];
        NSString * content = [dicOne objectForKey:@"content"];
        NSString * next_man_name = [dicOne objectForKey:@"next_man_name"];
        NSString * help_man_name = [dicOne objectForKey:@"help_man_name"];
        int next_man = [[dicOne objectForKey:@"next_man"] intValue];
        
        if ([self isBlankString:help_man_name]) {
            help_man_name = @"";
        }
        if ([self isBlankString:next_man_name]) {
            next_man_name = @"";
        }
        if ([self isBlankString:content]) {
            content = @"";
        }
        if ([self isBlankString:operate_man_name]) {
            operate_man_name = @"";
        }
        
        if (operate_man == 0){
            operate_man_name = @"系统";
        }
        
        NSMutableArray * statusList = [self getAuthority:operate_type];
        NSString * statusName = [statusList objectAtIndex:0];
        
        NSMutableArray * authOperatee = [self getAuthorityOprate:operate_type];
        NSString * operateContent = [authOperatee objectAtIndex:0];
        
        cell.logName.text = statusName;
        cell.logTime.text = create_time;
        
        if (operate_type == 1) {
            cell.logContent.text = operateContent;
        }else if(operate_type == 2){
            cell.logContent.text = [self getPinjieNSString:operate_man_name:next_man_name];
        }else{
            cell.logContent.text = [self getPinjieNSString:operate_man_name:operateContent];
        }
        
        if (next_man == -1) {
            cell.logContent.text = [self getPinjieNSString:@"智能派单给":operate_man_name];
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
        //        [self getSelectObjectUnderByUnderId];
        
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

-(void)getSelectFixOrderFlowByOrderId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    [diction setValue:_order_id forKey:@"order_id"];
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    [diction setValue:@(1) forKey:@"app_flag"];
    
    
    NSString * url = [self getPinjieNSString:baseUrl :selectMyMasOrderFlowList];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
           
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
             [self setSelectFixOrderFlowByOrderId:myResult];
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
-(void)setSelectFixOrderFlowByOrderId:(NSMutableDictionary *) nsmutable{
    [self.dataSource removeAllObjects];
    
    NSMutableArray * flowList =  [nsmutable objectForKey:@"flowList"];
    
    for (NSMutableDictionary * dicStr in flowList) {
        [self.dataSource addObject:dicStr];
    }
    [self.tableView reloadData];
}

@end
