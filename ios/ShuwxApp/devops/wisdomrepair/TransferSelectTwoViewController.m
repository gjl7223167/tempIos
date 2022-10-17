//
//  TransferSelectTwoViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/5/13.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "TransferSelectTwoViewController.h"
#import "WRNavigationBar.h"

#import "QTEventBus.h"
#import "MyEventBus.h"
#import "QTEventBus+AppModule.h"

#import <UMCommon/MobClick.h>


@interface TransferSelectTwoViewController ()<TreeTableCellThreeDelegate>

@end

@implementation TransferSelectTwoViewController

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
      self.navigationItem.title = @"选择转交人";
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
    [MobClick beginLogPageView:@"TransferSelectTwoViewController"];
   [self getSelectTurnManTree];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"TransferSelectTwoViewController"];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setScan) object:nil];
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
    [diction setValue:self.order_id forKey:@"order_id"];
 
    NSString * url = [self getPinjieNSString:baseUrl :selectTurnManTree];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            [self setSelectTurnManTree:myResult];
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
-(void)setSelectTurnManTree:(NSMutableArray *) nsmutable{
    [self.dataSource removeAllObjects];
    [self.allDataSource removeAllObjects];
    for (int i=0;i< [nsmutable count];i++) {
//          NSMutableDictionary * itemDic = [nsmutable objectAtIndex:i];
//          int depthInt = 0;
//          int select_type = [[itemDic objectForKey:@"select_type"] intValue];
//        if (select_type == 1) {
//            int select_id = [[itemDic objectForKey:@"select_id"] intValue];
//                    NSString * proName = [itemDic objectForKey:@"user_name"];
//            Node *country1 = [[Node alloc] initWithParentId:-1 nodeId:select_id name:proName depth:depthInt expand:YES:1:0:@"":@""];
//                     [self.dataSource addObject:country1];
//            [self.allDataSource addObject:country1];
//                    NSMutableArray * linkedList =  [itemDic objectForKey:@"userList"];
//            if ([linkedList isKindOfClass:[NSArray class]] && linkedList.count > 0){
//                      [self getMyTreeList:linkedList:select_id:depthInt];
//                 }
//        }else{
//            int select_id = [[itemDic objectForKey:@"select_id"] intValue];
//                              NSString * proName = [itemDic objectForKey:@"user_name"];
//            NSString * user_head_img = [itemDic objectForKey:@"user_head_img"];
//             Node *province1 = [[Node alloc] initWithParentId:-1 nodeId:select_id name:proName depth:depthInt expand:YES:2:0:@"":user_head_img];
//              [self.dataSource addObject:province1];
//             [self.allDataSource addObject:province1];
//        }
        
        NSMutableDictionary * itemDic = [nsmutable objectAtIndex:i];
        if ([self isNullDictionary:itemDic]) {
            return;
        }
        int projectId = [[itemDic objectForKey:@"role_id"] intValue];
//          int parent_id = [[itemDic objectForKey:@"p_depart_id"] intValue];
      
        NSString * proName = [itemDic objectForKey:@"name"];
        NSMutableArray * linkedList =  [itemDic objectForKey:@"userInfoList"];
        int depthInt = 0;
      Node *country1 = [[Node alloc] initWithParentId:-1 nodeId:projectId name:proName depth:depthInt expand:YES:1:0:@"":@""];
        [self.dataSource addObject:country1];
        [self.allDataSource addObject:country1];
      if ([linkedList isKindOfClass:[NSArray class]] && linkedList.count > 0){
          [self getMyTreeList:linkedList:projectId:depthInt:proName];
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
    TreeTableViewThree *tableview = [[TreeTableViewThree alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT + 44, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 44) withData:self.dataSource];
         tableview.treeTableCellDelegate = self;
          tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
       [self.view addSubview:tableview];
}

-(void)getMyTreeList:(NSMutableArray *)nsArr:(int)proId:(int)depthInt:(NSString *)proName{
    int depthValue = depthInt + 1;
    for (NSMutableDictionary * itemDic in nsArr) {
//        int object_id =  [[itemDic objectForKey:@"id"] intValue];
////        int parent_id =  [[itemDic objectForKey:@"p_depart_id"] intValue];
//        NSString * object_name = [itemDic objectForKey:@"user_nike_name"];
//         NSString * depart_name = [itemDic objectForKey:@"depart_name"];
//         NSString * head_img = [itemDic objectForKey:@"head_img"];
//
//        Node *province1 = [[Node alloc] initWithParentId:proId nodeId:object_id name:object_name depth:depthValue expand:NO:2:0:depart_name:head_img];
//        [self.dataSource addObject:province1];
//          [self.allDataSource addObject:province1];
        
        int object_id =  [[itemDic objectForKey:@"id"] intValue];
        NSString * object_name = [itemDic objectForKey:@"user_nike_name"];
//        NSString * depart_name = [itemDic objectForKey:@"depart_name"];
        NSString * head_img = [itemDic objectForKey:@"head_img"];
        
        Node *province1 = [[Node alloc] initWithParentId:proId nodeId:object_id name:object_name depth:depthValue expand:YES:2:0:proName:head_img];
        [self.dataSource addObject:province1];
        [self.allDataSource addObject:province1];
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
    
    NSString * zdString =  [self getPinjieNSString: @"确定转单给":zdStr];
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
        
        MyEventBus * myEvent = [[MyEventBus alloc] init];
              myEvent.errorId = @"TransferOrderViewController";
             myEvent.diction = diction;
                 [[QTEventBus shared] dispatch:myEvent];
                                        
           [self performSelector:@selector(setScan) withObject:nil afterDelay:3.0f];
           
            [self showToast:@"操作完成"];
        
     
        
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    
    [self presentViewController:alertVC animated:NO completion:nil];
}


@end
