//
//  MainAssignMoreViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/12/9.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainAssignMoreViewController.h"
#import "WRNavigationBar.h"

#import "QTEventBus.h"
#import "MyEventBus.h"
#import "QTEventBus+AppModule.h"

@interface MainAssignMoreViewController ()<TreeTableCellThreeDelegate>

@end

@implementation MainAssignMoreViewController

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(NSMutableArray *)allDataSource{
    if (!_allDataSource) {
        _allDataSource = [NSMutableArray array];
    }
    return _allDataSource;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.transferSearchBar.frame = CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH, 50);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"指派任务";
   
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
    [MobClick beginLogPageView:@"MainAssignMoreViewController"];
    [self getSelectTurnManTree];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MainAssignMoreViewController"];
}


-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView{
    [self dataSource];
      [self allDataSource];
    
    [self.transferSearchBar setPlaceholder:@"搜索"];// 搜索框的占位符
      self.transferSearchBar.delegate = self; // 设置代理
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
NSString * searchText =   searchBar.text;
    if ([self isBlankString:searchText]) {
     self.dataSource =  self.allDataSource;
        [self setUpdateTreeTableView];
        return;
    }
    [self.dataSource removeAllObjects];
    for (Node * nodeItem in self.allDataSource) {
          int typeItem = nodeItem.type;
          NSString * nameItem = nodeItem.name;
          if ([nameItem containsString:searchText]) {
              [self.dataSource addObject:nodeItem];
          }
      }
       [self setUpdateTreeTableView];
}
-(void)setUpdateTreeTableView{
    for (UIView *subView in self.view.subviews) {
           if ([subView isKindOfClass:[TreeTableViewThree class]]) {
               [subView removeFromSuperview];
           }
       }
    TreeTableViewThree *tableview = [[TreeTableViewThree alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT + 50, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 100) withData:self.dataSource];
         tableview.treeTableCellDelegate = self;
          tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
       [self.view addSubview:tableview];
}



-(void)getSelectTurnManTree{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
       int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
       [diction setValue:@(app_Version) forKey:@"version_code"];
//    [diction setValue:self.order_id forKey:@"order_id"];
 
    NSString * url = [self getPinjieNSString:baseUrl :selectDepartAndUserByCompanyId];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            [self setSelectDepartAndUserByCompanyId:myResult];
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
-(void)setSelectDepartAndUserByCompanyId:(NSMutableArray *) nsmutable{
    [self.dataSource removeAllObjects];
    for (int i=0;i< [nsmutable count];i++) {
        NSMutableDictionary * itemDic = [nsmutable objectAtIndex:i];
        if ([self isNullDictionary:itemDic]) {
            return;
        }
//        int projectId = [[itemDic objectForKey:@"depart_id"] intValue];
//        NSString * proName = [itemDic objectForKey:@"depart_name"];
//        int depthInt = 0;
//        Node *country1 = [[Node alloc] initWithParentId:-1 nodeId:projectId name:proName depth:depthInt expand:YES:1:0:@"":@""];
//        [self.dataSource addObject:country1];
//
//        NSMutableArray * children =  [itemDic objectForKey:@"children"];
//        if ([children isKindOfClass:[NSArray class]] && children.count > 0){
//            [self getMyTreeList:children:projectId:depthInt:0:proName];
//        }
//        NSMutableArray * linkedList =  [itemDic objectForKey:@"userInfos"];
//
//        if ([linkedList isKindOfClass:[NSArray class]] && linkedList.count > 0){
//            [self getMyTreeList:linkedList:projectId:depthInt:1:proName];
//        }
        int object_id =  [[itemDic objectForKey:@"role_id"] intValue];
        NSString * proName = [itemDic objectForKey:@"name"];
        NSMutableArray * linkedList =  [itemDic objectForKey:@"userInfoList"];
        int depthInt = 0;
      Node *country1 = [[Node alloc] initWithParentId:-1 nodeId:object_id name:proName depth:depthInt expand:YES:1:0:@"":@""];
        [self.dataSource addObject:country1];
      if ([linkedList isKindOfClass:[NSArray class]] && linkedList.count > 0){
          [self getMyTreeList:linkedList:object_id:depthInt:0:proName];
      }
        
    }
    
    TreeTableViewThree *tableview = [[TreeTableViewThree alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) withData:self.dataSource];
    tableview.treeTableCellDelegate = self;
    tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableview];
    
}

-(void)getMyTreeList:(NSMutableArray *)nsArr:(int)proId:(int)depthInt:(int)isPerson:(NSString *)deptName{
    int depthValue = depthInt + 1;
    for (NSMutableDictionary * itemDic in nsArr) {
//        int object_id =  [[itemDic objectForKey:@"id"] intValue];
////        int parent_id =  [[itemDic objectForKey:@"p_depart_id"] intValue];
//        if (isPerson == 1) {
//            object_id =  [[itemDic objectForKey:@"id"] intValue];
//            NSString * object_name = [itemDic objectForKey:@"user_nike_name"];
//             NSString * head_img = [itemDic objectForKey:@"head_img"];
//
//            Node *province1 = [[Node alloc] initWithParentId:proId nodeId:object_id name:object_name depth:depthValue expand:NO:2:0:deptName:head_img];
//            [self.dataSource addObject:province1];
//        }else{
//             object_id =  [[itemDic objectForKey:@"depart_id"] intValue];
//            NSString * object_name = [itemDic objectForKey:@"depart_name"];
//
//            Node *country1 = [[Node alloc] initWithParentId:proId nodeId:object_id name:object_name depth:depthValue expand:NO:1:0:@"":@""];
//            [self.dataSource addObject:country1];
//        }
//
//        if(![[itemDic objectForKey:@"children"] isEqual:[NSNull null]]){
//            NSMutableArray * twoList =  [itemDic objectForKey:@"children"];
//            if(NULL != twoList && nil != twoList && [twoList count] > 0){
//                [self getMyTreeList:twoList:object_id:depthValue:0:deptName];
//            }
//        }
//
//        if(![[itemDic objectForKey:@"userInfos"] isEqual:[NSNull null]]){
//            NSMutableArray * twoList =  [itemDic objectForKey:@"userInfos"];
//            if(NULL != twoList && nil != twoList && [twoList count] > 0){
//                [self getMyTreeList:twoList:object_id:depthValue:1:deptName];
//            }
//        }
        
        int object_id =  [[itemDic objectForKey:@"id"] intValue];
        NSString * object_name = [itemDic objectForKey:@"user_nike_name"];
//        NSString * depart_name = [itemDic objectForKey:@"depart_name"];
        NSString * head_img = [itemDic objectForKey:@"head_img"];
        
        Node *province1 = [[Node alloc] initWithParentId:proId nodeId:object_id name:object_name depth:depthValue expand:YES:2:0:deptName:head_img];
        [self.dataSource addObject:province1];
        
    }
}

#pragma mark - TreeTableCellDelegate
-(void)cellClick:(Node *)node{
    int parentId = node.type;
    int  nodeId =  node.nodeId;
   NSString * name =   node.name;
    
    if (parentId == 1) {
        return;
    }
    
    [self setZhipZd:name:nodeId];
    
}

// 指派转单
-(void)setZhipZd:(NSString *)zdStr:(int)selectId{
    
    NSString * zdString =  [self getPinjieNSString: @"确定指派给":zdStr];
    zdString =  [self getPinjieNSString: zdString:@"?"];
    
    CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"提示" message:zdString];
    
    CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
    }];
    
    CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
        
        NSMutableDictionary * diction = [NSMutableDictionary dictionary];
       [diction setValue:zdStr forKey:@"zdStr"];
        
        NSString *seleStr = [NSString stringWithFormat:@"%d",selectId];
        [diction setValue:seleStr forKey:@"selectId"];
        
//        MyEventBus * myEvent = [[MyEventBus alloc] init];
//              myEvent.errorId = @"TransferOrderViewController";
//             myEvent.diction = diction;
//                 [[QTEventBus shared] dispatch:myEvent];
//
//           [self performSelector:@selector(setScan) withObject:nil afterDelay:3.0f];
//
//            [self showToast:@"操作完成"];
        
        [self getSendOrderInfo:selectId];
        
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    
    [self presentViewController:alertVC animated:NO completion:nil];
}

-(void)getSendOrderInfo:(int)dId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    [diction setValue:self.order_id forKey:@"order_id"];
    [diction setValue:@(dId) forKey:@"receive_man"];
    
    
    NSString * url = [self getPinjieNSString:baseUrl :sendOrder];
    
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
            [self setSendOrderInfo];
            return;
        }
        NSString * myMessage =  [responseObject objectForKey:@"message"];
        [self showToast:myMessage];
        
    } failure:^(NSError *error) {
        //请求失败
        NSString * errorStr =  [self getError:error];
        [self showToastTwo:errorStr];
        
    }];
}
-(void)setSendOrderInfo{
    
    MyEventBus * myEvent = [[MyEventBus alloc] init];
         myEvent.errorId = @"OrderDetailsViewController";
            [[QTEventBus shared] dispatch:myEvent];
    
    
    MyEventBus * myEvent1 = [[MyEventBus alloc] init];
           myEvent1.errorId = @"MainAllOrderViewController";
              [[QTEventBus shared] dispatch:myEvent1];
                                   
      [self performSelector:@selector(setScan) withObject:nil afterDelay:3.0f];
      
       [self showToast:@"操作完成"];
    
}

@end
