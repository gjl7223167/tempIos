//
//  OrderTypeViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/3/24.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "OrderTypeViewController.h"
#import "WRNavigationBar.h"

#import "QTEventBus.h"
#import "MyEventBus.h"
#import "QTEventBus+AppModule.h"




@interface OrderTypeViewController ()<TreeTableCellDelegate>

@end

@implementation OrderTypeViewController

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.allView.frame = CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
              self.navigationItem.title = @"工单类型";
             
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
    [MobClick beginLogPageView:@"OrderTypeViewController"];
    [self getGiveJobWorkByTree];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"OrderTypeViewController"];
}

-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView{
      [self dataSource];
}



-(void)getGiveJobWorkByTree{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
       int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
       [diction setValue:@(app_Version) forKey:@"version_code"];
 
    NSString * url = [self getPinjieNSString:baseUrl :selectAllOrderType];
      [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
           [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            [self setGiveJobWorkByTree:myResult];
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
-(void)setGiveJobWorkByTree:(NSMutableArray *) nsmutable{
    [self.dataSource removeAllObjects];
    for (int i=0;i< [nsmutable count];i++) {
          NSMutableDictionary * itemDic = [nsmutable objectAtIndex:i];
          int projectId = [[itemDic objectForKey:@"folder_id"] intValue];
          NSString * proName = [itemDic objectForKey:@"folder_name"];
          NSMutableArray * linkedList =  [itemDic objectForKey:@"orderType"];
          int depthInt = 0;
          Node *country1 = [[Node alloc] initWithParentId:-1 nodeId:projectId name:proName depth:depthInt expand:YES];
          [self.dataSource addObject:country1];
        if ([linkedList isKindOfClass:[NSArray class]] && linkedList.count > 0){
            [self getMyTreeList:linkedList:projectId:depthInt:i];
        }
      }
      
      TreeTableView *tableview = [[TreeTableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT + 44, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 44) withData:self.dataSource];
      tableview.treeTableCellDelegate = self;
       tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableview];
     
}

-(void)getMyTreeList:(NSMutableArray *)nsArr:(int)proId:(int)depthInt:(int)position{
    int depthValue = depthInt + 1;
    for (NSMutableDictionary * itemDic in nsArr) {
        int object_id =  [[itemDic objectForKey:@"order_type_id"] intValue];
        int parent_id =  [[itemDic objectForKey:@"folder_id"] intValue];
        NSString * object_name = [itemDic objectForKey:@"type_name"];
        
        if (position == 0) {
            Node *province1 = [[Node alloc] initWithParentId:proId nodeId:object_id name:object_name depth:depthValue expand:YES];
                  [self.dataSource addObject:province1];
        }else{
            Node *province1 = [[Node alloc] initWithParentId:proId nodeId:object_id name:object_name depth:depthValue expand:NO];
                  [self.dataSource addObject:province1];
        }
      
        
        
        if(![[itemDic objectForKey:@"orderType"] isEqual:[NSNull null]]){
            NSMutableArray * twoList =  [itemDic objectForKey:@"orderType"];
            if(NULL != twoList && nil != twoList && [twoList count] > 0){
                [self getMyTreeList:twoList:object_id:depthValue:position];
            }
        }
        
    }
}

#pragma mark - TreeTableCellDelegate
-(void)cellClick:(Node *)node{
    int parentId = node.parentId;
    int  nodeId =  node.nodeId;
   NSString * name =   node.name;
    
    if (parentId == -1) {
        return;
    }
   
    [self setToDialog:name:nodeId];
}

-(void)setToDialog:(NSString *) nameStr:(int)nodeId{
    
    NSString * zpName = [self getPinjieNSString:@"确定选择":nameStr];
    zpName = [self getPinjieNSString:zpName:@"?"];
    
    CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"提示" message:zpName];
      
      CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
          NSLog(@"点击了 %@ 按钮",action.title);
      }];
      
      CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
          NSLog(@"点击了 %@ 按钮",action.title);
          
          NSMutableDictionary * diction = [NSMutableDictionary dictionary];
                [diction setValue:nameStr forKey:@"object_name"];
                 
                 NSString *seleStr = [NSString stringWithFormat:@"%d",nodeId];
                 [diction setValue:seleStr forKey:@"pos_name"];
             [diction setValue:@"1" forKey:@"ordertype"];
          
          MyEventBus * myEvent = [[MyEventBus alloc] init];
             myEvent.errorId = @"ShowRepairViewController";
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
