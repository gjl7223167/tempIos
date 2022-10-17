//
//  DeviceStrategyViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/5/7.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "DeviceStrategyViewController.h"
#import "WRNavigationBar.h"



@interface DeviceStrategyViewController ()<TreeTableCellTwoDelegate>

@end

@implementation DeviceStrategyViewController

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone; //view不需要拓展到整个屏幕
               self.navigationItem.title = @"策略配置";
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
    [MobClick beginLogPageView:@"DeviceStrategyViewController"];
    [self getSelectObjectUnderList];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DeviceStrategyViewController"];
}
-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView{
      [self dataSource];
      [self setupRefreshData];
}

- (void)setupRefreshData {
    __weak typeof(self) weakSelf = self;
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf clearData];
            [weakSelf getSelectObjectUnderList];
            
            [weakSelf.tableview.mj_header endRefreshing];
        });
    }];
}

-(void)clearData{
    [self.dataSource removeAllObjects];
   
    
}



-(void)getSelectObjectUnderList{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
       int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
       [diction setValue:@(app_Version) forKey:@"version_code"];
    [diction setValue:self.object_id forKey:@"object_id"];
 
    NSString * url = [self getPinjieNSString:baseUrl :selectObjectUnderList];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            [self setSelectObjectUnderList:myResult];
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
-(void)setSelectObjectUnderList:(NSMutableArray *) nsmutable{
    [self.dataSource removeAllObjects];
    for (int i=0;i< [nsmutable count];i++) {
          NSMutableDictionary * itemDic = [nsmutable objectAtIndex:i];
          int projectId = [[itemDic objectForKey:@"under_id"] intValue];
          NSString * proName = [itemDic objectForKey:@"under_name"];
          NSMutableArray * linkedList =  [itemDic objectForKey:@"rulesList"];
          int depthInt = 0;
        Node *country1 = [[Node alloc] initWithParentId:-1 nodeId:projectId name:proName depth:depthInt expand:YES:0:0 : @""];
          [self.dataSource addObject:country1];
        if ([linkedList isKindOfClass:[NSArray class]] && linkedList.count > 0){
             [self getMyTreeList:linkedList:projectId:depthInt];
        }
      }
      
     self.tableview = [[TreeTableViewTwo alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 60) withData:self.dataSource];
    self.tableview.treeTableCellDelegate = self;
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableview];
     
}

-(void)getMyTreeList:(NSMutableArray *)nsArr:(int)proId:(int)depthInt{
    int depthValue = depthInt + 1;
    for (NSMutableDictionary * itemDic in nsArr) {
        int object_id =  [[itemDic objectForKey:@"rule_id"] intValue];
//        int parent_id =  [[itemDic objectForKey:@"p_depart_id"] intValue];
        NSString * object_name = [itemDic objectForKey:@"rule_name"];
        NSString * rule_description = [itemDic objectForKey:@"rule_description"];
        
        Node *province1 = [[Node alloc] initWithParentId:proId nodeId:object_id name:object_name depth:depthValue expand:YES:1:0 : rule_description];
        [self.dataSource addObject:province1];
        
    }
}

#pragma mark - TreeTableCellDelegate
-(void)cellClick:(Node *)node{
    int parentId = node.parentId;
    int  nodeId =  node.nodeId;
    int type = node.type;
   NSString * name =   node.name;
    NSString * descripe = node.descrip;
    
    NSString *stringInt = [NSString stringWithFormat:@"%d",nodeId];
    
    if (type == 1) {
        StrategyDetailsViewController * oneVC = [[StrategyDetailsViewController alloc] init];
         oneVC.selectId = stringInt;
        oneVC.strateDescri = descripe;
        oneVC.titleName = name;
        [self.navigationController pushViewController:oneVC  animated:YES];
    }else{
        FreeControlViewController * nextVC = [[FreeControlViewController alloc] init];
        nextVC.selectId = stringInt;
              [self.navigationController pushViewController:nextVC  animated:YES];
    }

}



@end
