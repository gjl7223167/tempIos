//
//  AssignedDeptViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/20.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//    

#import "AssignedDeptViewController.h"
#import "WRNavigationBar.h"

#import "QTEventBus.h"
#import "MyEventBus.h"
#import "QTEventBus+AppModule.h"



@interface AssignedDeptViewController ()<TreeTableCellThreeDelegate>

@end

@implementation AssignedDeptViewController

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
    
             self.navigationItem.title = @"指派";
            
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
    [MobClick beginLogPageView:@"AssignedDeptViewController"];
    [self getGiveJobWorkByTree];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"AssignedDeptViewController"];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setScan) object:nil];
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
    [diction setValue:_plan_id forKey:@"plan_id"];
 
    NSString * url = [self getPinjieNSString:baseUrl :giveJobWorkByTree];
    
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
            [self showToast:myResult];
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
        if ([linkedList isKindOfClass:[NSArray class]] && linkedList.count > 0){
            [self getMyTreeList:linkedList:projectId:depthInt:proName];
        }
      }
      
    TreeTableViewThree *tableview = [[TreeTableViewThree alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 50) withData:self.dataSource];
      tableview.treeTableCellDelegate = self;
       tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableview];
     
}

-(void)getMyTreeList:(NSMutableArray *)nsArr :(int)proId :(int)depthInt :(NSString *)proName{
    int depthValue = depthInt + 1;
    for (NSMutableDictionary * itemDic in nsArr) {
        int object_id =  [[itemDic objectForKey:@"id"] intValue];
        NSString * object_name = [itemDic objectForKey:@"user_nike_name"];
//        NSString * depart_name = [itemDic objectForKey:@"depart_name"];
        NSString * head_img = [itemDic objectForKey:@"head_img"];
        
        Node *province1 = [[Node alloc] initWithParentId:proId nodeId:object_id name:object_name depth:depthValue expand:YES:2:0:proName:head_img];
        [self.dataSource addObject:province1];
        
        
//        if(![[itemDic objectForKey:@"userInfos"] isEqual:[NSNull null]]){
//            NSMutableArray * twoList =  [itemDic objectForKey:@"userInfos"];
//            if(NULL != twoList && nil != twoList && [twoList count] > 0){
//                [self getMyTreeList:twoList:object_id:depthValue:proName];
//            }
//        }
//        
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

-(void)setToDialog:(NSString *)nameStr :(int)nodeId{
    
    NSString * toName = @"";
    toName = [self getPinjieNSString:toName:@"确定指派给"];
    toName = [self getPinjieNSString:toName:nameStr];
    toName = [self getPinjieNSString:toName:@"？"];
  
    __weak typeof(self) weakSelf = self;
    CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"提示" message:toName];
      
      CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
          NSLog(@"点击了 %@ 按钮",action.title);
      }];
      
      CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
          __strong typeof(self) strongSelf = weakSelf;
          
          [strongSelf getGiveJobLineInfo:nodeId];
          
      }];
      
      [alertVC addAction:cancel];
      [alertVC addAction:sure];
      
      [self presentViewController:alertVC animated:NO completion:nil];
}

-(void)getGiveJobLineInfo:(int)dId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
       int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
       [diction setValue:@(app_Version) forKey:@"version_code"];
    [diction setValue:self.plan_id forKey:@"plan_id"];
     [diction setValue:self.job_id forKey:@"job_id"];
      [diction setValue:@(dId) forKey:@"worker_id"];
 
    NSString * url = [self getPinjieNSString:baseUrl :giveJobLineInfo];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        int myCode = 0;
         if ([responseObject isKindOfClass:[NSDictionary class]]) {
                      myCode  = [[responseObject objectForKey:@"code"] intValue];
                  }
                  if (myCode == 200) {
                      [self setGiveJobLineInfo];
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
-(void)setGiveJobLineInfo{
 MyEventBus * myEvent = [[MyEventBus alloc] init];
   myEvent.errorId = @"UpcomingTaskViewController";
   [[QTEventBus shared] dispatch:myEvent];
   
   [self performSelector:@selector(setScan) withObject:nil afterDelay:3.0f];
   
   [self showToast:@"操作完成"];
     
}


@end
