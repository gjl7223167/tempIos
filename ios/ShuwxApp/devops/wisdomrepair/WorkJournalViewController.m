//
//  WorkJournalViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/5/18.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "WorkJournalViewController.h"
#import "WRNavigationBar.h"

#import <UMCommon/MobClick.h>

@interface WorkJournalViewController ()

@end

@implementation WorkJournalViewController

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    [MobClick beginLogPageView:@"WorkJournalViewController"];
    // [self getSelectObjectUnderList];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"WorkJournalViewController"];
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
    
    [self setupRefreshData];
    
    
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





- (void)setupRefreshData {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf clearData];
            //  [self getSelectObjectUnderByUnderId];
            [strongSelf.tableView.mj_header endRefreshing];
        });
    }];
}


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
    if ( [self.dataSource count] <= 0) {
        return SCREEN_HEIGHT - NAV_HEIGHT;
    }
    if (indexPath.section == 0){
        
        NSDictionary * dicOne  =   [self.dataSource objectAtIndex:indexPath.row];
        NSString * content = [dicOne objectForKey:@"content"];
        int operate_type = [[dicOne objectForKey:@"operate_type"] intValue];
        
        if ([self isBlankString:content] || operate_type == 14) {
            return 100;
        }
        
        UIFont *font = [UIFont systemFontOfSize:14];
        CGRect rect = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];
      int itemHeight =  rect.size.height + 100;
        
        return itemHeight;
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
        static NSString *  JournalTableCellView = @"CellId";
        //自定义cell类
        WorkJournalViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JournalTableCellView];
        if (!cell) {
            cell = [_personNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
        }
        
        NSDictionary * dicOne  =   [self.dataSource objectAtIndex:indexPath.row];
        NSString * operate_man_name = [dicOne objectForKey:@"operate_man_name"];
        NSString * create_time = [dicOne objectForKey:@"create_time"];
        int operate_type = [[dicOne objectForKey:@"operate_type"] intValue];
        int operate_man = [[dicOne objectForKey:@"operate_man"] intValue];
        NSString * content = [dicOne objectForKey:@"content"];
        NSString * next_man_name = [dicOne objectForKey:@"next_man_name"];
        NSString * help_man_name = [dicOne objectForKey:@"help_man_name"];
        
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
        
        cell.logContent.numberOfLines = 0;//表示label可以多行显示
    //    self.jiedJilu.lineBreakMode = UILineBreakModeWordWrap;
        [cell.logContent setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSMutableArray * statusList = [self getStatusNameLog:operate_type];
        NSString * statusName = [statusList objectAtIndex:0];
        NSString * statusColor = [statusList objectAtIndex:1];
        NSString * operateName = [statusList objectAtIndex:2];
        
        cell.logName.text = operateName;
        cell.logTime.text = create_time;
        
        if (operate_type == 5){
            
            NSString * optrateTypeContent = @"";
            optrateTypeContent = [self getPinjieNSString:optrateTypeContent:operate_man_name];
            optrateTypeContent = [self getPinjieNSString:optrateTypeContent:@"呼叫"];
            optrateTypeContent = [self getPinjieNSString:optrateTypeContent:help_man_name];
            optrateTypeContent = [self getPinjieNSString:optrateTypeContent:@"进行增援"];

            cell.logContent.text = optrateTypeContent;
            return cell;
        }
        if (operate_type == 6){
            NSString * resultOut = @"";
            int is_success = [[dicOne objectForKey:@"is_success"] intValue];
            if (is_success == 0){
                resultOut = [self getPinjieNSString:@"工单未解决,未解决原因：":content];
            }else{
                resultOut = [self getPinjieNSString:operate_man_name:@"完成工单处理，处理记录："];
                resultOut = [self getPinjieNSString:resultOut:content];
              
            }
            cell.logContent.text = resultOut;
            return cell;
        }
        if (operate_type == 10){
            NSString * resultOut = @"";
            resultOut = [self getPinjieNSString:operate_man_name:@"申请挂单，挂单原因："];
            resultOut = [self getPinjieNSString:resultOut:content];
            cell.logContent.text = resultOut;
            return cell;
        }
        if (operate_type == 12){
            NSString * resultOut = @"";
            resultOut = [self getPinjieNSString:operate_man_name:@"驳回挂单，原因："];
            resultOut = [self getPinjieNSString:resultOut:content];
            cell.logContent.text = resultOut;
            return cell;
        }
        if (operate_type == 11){
            NSString * resultOut = @"";
            resultOut = [self getPinjieNSString:operate_man_name:@"同意挂单"];
            cell.logContent.text = resultOut;
            return cell;
        }
        if (operate_type == 17){
            NSString * resultOut = @"";
            resultOut = [self getPinjieNSString:operate_man_name:@"驳回转单，原因："];
            resultOut = [self getPinjieNSString:resultOut:content];
            cell.logContent.text = resultOut;
            return cell;
        }
        if (operate_type == 16){
            NSString * resultOut = @"";
            resultOut = [self getPinjieNSString:operate_man_name:@"同意转单"];
            cell.logContent.text = resultOut;
            return cell;
        }
        if (operate_type == 2){
            NSString * resultOut = @"";
            resultOut = [self getPinjieNSString:operate_man_name:@"指派"];
            resultOut = [self getPinjieNSString:resultOut:next_man_name];
            resultOut = [self getPinjieNSString:resultOut:@"进行工单处理"];
            cell.logContent.text = resultOut;
            return cell;
        }
        if (operate_type == 15){
            NSString * resultOut = @"";
            resultOut = [self getPinjieNSString:operate_man_name:@"转单给"];
            resultOut = [self getPinjieNSString:resultOut:next_man_name];
            resultOut = [self getPinjieNSString:resultOut:@"，转单原因："];
            resultOut = [self getPinjieNSString:resultOut:content];
            cell.logContent.text = resultOut;
            return cell;
        }
        if (operate_type == 14){
            NSString * resultOut = @"";
            resultOut = [self getPinjieNSString:operate_man_name:@"取消了工单，取消原因："];
            resultOut = [self getPinjieNSString:resultOut:content];
            cell.logContent.text = resultOut;
            return cell;
        }
        if (operate_type == 8){
            NSString * resultOut = @"";
            resultOut = [self getPinjieNSString:operate_man_name:@"对工单进行了评价"];
            cell.logContent.text = resultOut;
            return cell;
        }
        if (operate_type == 13){
            NSString * resultOut = @"";
            if ([self getNSStringEqual:operate_man_name:next_man_name] || [self isBlankString:next_man_name]) {
                resultOut = [self getPinjieNSString:operate_man_name:@"重启工单给原执行人,理由："];
                resultOut = [self getPinjieNSString:resultOut:content];
            }else{
                resultOut = [self getPinjieNSString:operate_man_name:@"重启工单，转交给"];
                resultOut = [self getPinjieNSString:resultOut:next_man_name];
                resultOut = [self getPinjieNSString:resultOut:@",理由："];
                resultOut = [self getPinjieNSString:resultOut:content];
            }
            cell.logContent.text = resultOut;
            return cell;
        }
        
        cell.logContent.text = [self getPinjieNSString:operate_man_name:statusName];
        
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
    
    
    NSString * url = [self getPinjieNSString:baseUrl :selectFixOrderFlowByOrderId];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            [self setSelectFixOrderFlowByOrderId:myResult];
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
-(void)setSelectFixOrderFlowByOrderId:(NSMutableArray *) nsmutable{
    [self.dataSource removeAllObjects];
    for (NSMutableDictionary * dicStr in nsmutable) {
        [self.dataSource addObject:dicStr];
    }
    [self.tableView reloadData];
}


@end
