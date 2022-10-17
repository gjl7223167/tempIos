//
//  CallReinforceViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/5/13.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "CallReinforceViewController.h"
#import "WRNavigationBar.h"

#import "QTEventBus.h"
#import "MyEventBus.h"
#import "QTEventBus+AppModule.h"

#import <UMCommon/MobClick.h>

@interface CallReinforceViewController ()<TreeTableCellThreeDelegate>

@end

@implementation CallReinforceViewController

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(NSMutableArray *)selectList{
    if (!_selectList) {
        _selectList = [NSMutableArray array];
    }
    return _selectList;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

    self.selectSum.frame = CGRectMake(10,NAV_HEIGHT + 10,SCREEN_WIDTH,30);
    self.callSearchBar.frame = CGRectMake(0,NAV_HEIGHT + 50,SCREEN_WIDTH,44);

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"人员列表";
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
    [MobClick beginLogPageView:@"CallReinforceViewController"];
    [self getCallReinforce];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"CallReinforceViewController"];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setScan) object:nil];
}
-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initView{
    [self dataSource];
    [self selectList];
    
    [self.callSearchBar setPlaceholder:@"搜索"];// 搜索框的占位符
    self.callSearchBar.delegate = self; // 设置代理
    
    [self.callSubmit addTarget:self action:@selector(setHujzy) forControlEvents:UIControlEventTouchUpInside];
    
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            NSLog(@"subview==%@",subView);
            return;
        }
    }
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, NAV_HEIGHT + 100, 414 - 20, 80)];
    self.scrollView.showsHorizontalScrollIndicator = FALSE;//水平滚动条
    
    [self.view addSubview:self.scrollView];
    
    int myLength = 500;
    
    self.viewlist = [[UIView alloc] initWithFrame:CGRectMake(0,0,myLength,80)];
    self.viewlist.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.viewlist];
    self.scrollView.contentSize = CGSizeMake(myLength, 80);
    
//    [self setPersonList];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString * searchText =   searchBar.text;
    NSLog(@"dd");
    
    [self setSearchData:searchText];
    
}
-(void)setSearchData:(NSString *)searchString{
    
    
    if ([self isBlankString:searchString]) {
        [self setCallUpdateView:self.dataSource:110];
        return;
    }
    NSMutableArray * nodeArray = [NSMutableArray array];
    for (Node * nodeItem in self.dataSource) {
        int typeItem = nodeItem.type;
        NSString * nameItem = nodeItem.name;
        if ([nameItem containsString:searchString]) {
            [nodeArray addObject:nodeItem];
        }
    }
    [self setCallUpdateView:nodeArray:180];
}
-(void)getCallReinforce{
    
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
    
    NSString * url = [self getPinjieNSString:baseUrl :selectHelpManByOrderId];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
    [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        
        if ([myResult isKindOfClass:[NSArray class]]) {
            [self setCallReinforce:myResult];
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
-(void)setCallReinforce:(NSMutableArray *) nsmutable{
   
    for (NSMutableDictionary * nsmuTab in nsmutable) {
        
        if ([self isNullDictionary:nsmuTab]) {
            return;
        }
        int nodeId = [[nsmuTab objectForKey:@"id"] intValue];
        NSString * name = [nsmuTab objectForKey:@"user_nike_name"];
         NSString * head_img = [nsmuTab objectForKey:@"head_img"];
        NSMutableDictionary * perDic = [NSMutableDictionary dictionary];
        [perDic setValue:name forKey:@"name"];
        [perDic setValue:@(nodeId) forKey:@"nodeId"];
            [perDic setValue:head_img forKey:@"head_img"];
        
        [self.selectList addObject:perDic];
    }
        [self setPersonList];
    
    [self getSelectDepartAndUserByCompanyId];
}



-(void)setRemoveView{
    for (UIView *subView in self.viewlist.subviews) {
        [subView removeFromSuperview];
    }
}
-(void)setPersonList{
    [self setRemoveView];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * pictureUrl = [defaults objectForKey:@"pictureUrl"];
    NSString  * defaultImage = @"tempimage";
    
    int myLengthtwo = 10;
    for(int i = 0; i < [self.selectList count]; i++){
        //                 CallReinforeToux *  callReinfore = [[CallReinforeToux alloc] init];
        CallReinforeToux *callReinfore = [[[NSBundle mainBundle] loadNibNamed:@"CallReinforeToux" owner:self options:nil] lastObject];
        callReinfore.frame = CGRectMake(myLengthtwo, 0, 60, 80);
       
        callReinfore.callReinfore = self;
        
        NSMutableDictionary * dictionItem = [self.selectList objectAtIndex:i];
        NSString * myName =   [dictionItem objectForKey:@"name"];
           NSString * head_img =   [dictionItem objectForKey:@"head_img"];
        callReinfore.callTitlee.text = myName;
        
        
        NSString * imageUrlStr =  [self getPinjieNSString:pictureUrl:head_img];
               [callReinfore setUpdateView:imageUrlStr];
        
        ProBtn *touxBtn = callReinfore.touxBtn;
        touxBtn.userInteractionEnabled = YES;
        [touxBtn addTarget:self action:@selector(setUpdateDataList:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *callToux = callReinfore.callToux;
        [callToux sd_setImageWithURL:imageUrlStr placeholderImage:[UIImage imageNamed:defaultImage]];
        
        NSString *nsnStr = [NSString stringWithFormat:@"%d",i];
        callReinfore.touxBtn.userId = nsnStr;
        callReinfore.tag = i;
        [self.viewlist addSubview:callReinfore];
        myLengthtwo += 70;
        
    }
    
    NSString *selectStr = [NSString stringWithFormat:@"%d",[self.selectList count]];
    selectStr = [self getPinjieNSString:@"已选中：":selectStr];
    selectStr = [self getPinjieNSString:selectStr:@"人"];
    
    if ([self.selectList count] == 0){
        
        self.tableview.transform=CGAffineTransformTranslate(self.tableview.transform, 0, -80);
        [self setCallUpdateView:self.dataSource:NAV_HEIGHT + 110];
    }else{
        self.tableview.transform=CGAffineTransformTranslate(self.tableview.transform, 0, 80);
        [self setCallUpdateView:self.dataSource:NAV_HEIGHT + 180];
    }
    self.selectSum.text = selectStr;
}

-(void)setCallUpdateView:(NSMutableArray *)callArray:(int)updateTop{
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[TreeTableViewThree class]]) {
            [subView removeFromSuperview];
        }
    }
    self.tableview = [[TreeTableViewThree alloc] initWithFrame:CGRectMake(0, updateTop, SCREEN_WIDTH, SCREEN_HEIGHT - updateTop - 50) withData:callArray];
    self.tableview.treeTableCellDelegate = self;
    self.tableview.uiViewController = self;
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.tableview];
}

-(void)setUpdateDataList:(ProBtn *) mybtn{
    int position =   [mybtn.userId intValue];
    for (int i = 0;i<[self.selectList count] ;i++) {
        if (i == position) {
            [self.selectList removeObjectAtIndex:position];
        }
    }
    
    [self setPersonList];
}



-(void)getSelectDepartAndUserByCompanyId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    //    [diction setValue:_order_id forKey:@"order_id"];
    
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
//        NSMutableDictionary * itemDic = [nsmutable objectAtIndex:i];
//        int projectId = [[itemDic objectForKey:@"depart_id"] intValue];
//        NSString * proName = [itemDic objectForKey:@"depart_name"];
//        NSMutableArray * linkedList =  [itemDic objectForKey:@"userInfos"];
//        int depthInt = 0;
//        Node *country1 = [[Node alloc] initWithParentId:-1 nodeId:projectId name:proName depth:depthInt expand:YES:1:0:@"":@""];
//        [self.dataSource addObject:country1];
//        if ([linkedList isKindOfClass:[NSArray class]] && linkedList.count > 0){
//            [self getMyTreeList:linkedList:projectId:depthInt];
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
      if ([linkedList isKindOfClass:[NSArray class]] && linkedList.count > 0){
          [self getMyTreeList:linkedList:projectId:depthInt:proName];
      }
    }
    
      if ([self.selectList count] == 0){
          
          self.tableview.transform=CGAffineTransformTranslate(self.tableview.transform, 0, -80);
          [self setCallUpdateView:self.dataSource:NAV_HEIGHT + 110];
      }else{
          self.tableview.transform=CGAffineTransformTranslate(self.tableview.transform, 0, 80);
          [self setCallUpdateView:self.dataSource:NAV_HEIGHT + 180];
      }
  
    
}

-(void)getMyTreeList:(NSMutableArray *)nsArr:(int)proId:(int)depthInt:(NSString *)proName{
    int depthValue = depthInt + 1;
    for (NSMutableDictionary * itemDic in nsArr) {
//        int object_id =  [[itemDic objectForKey:@"id"] intValue];
//        int parent_id =  [[itemDic objectForKey:@"p_depart_id"] intValue];
//        NSString * object_name = [itemDic objectForKey:@"user_nike_name"];
//         NSString * head_img = [itemDic objectForKey:@"head_img"];
//
//        Node *province1 = [[Node alloc] initWithParentId:proId nodeId:object_id name:object_name depth:depthValue expand:NO:2:0:@"":head_img];
//        [self.dataSource addObject:province1];
//
//
//        if(![[itemDic objectForKey:@"userInfos"] isEqual:[NSNull null]]){
//            NSMutableArray * twoList =  [itemDic objectForKey:@"userInfos"];
//            if(NULL != twoList && nil != twoList && [twoList count] > 0){
//                [self getMyTreeList:twoList:object_id:depthValue];
//            }
//        }
        int object_id =  [[itemDic objectForKey:@"id"] intValue];
        NSString * object_name = [itemDic objectForKey:@"user_nike_name"];
//        NSString * depart_name = [itemDic objectForKey:@"depart_name"];
        NSString * head_img = [itemDic objectForKey:@"head_img"];
        
        Node *province1 = [[Node alloc] initWithParentId:proId nodeId:object_id name:object_name depth:depthValue expand:YES:2:0:proName:head_img];
        [self.dataSource addObject:province1];
        
    }
}

#pragma mark - TreeTableCellDelegate
-(void)cellClick:(Node *)node{
    int parentId = node.parentId;
    int  nodeId =  node.nodeId;
    NSString * name =   node.name;
     NSString * head_img =   node.head_img;
    
    if (parentId == -1) {
        return;
    }
    
    NSMutableDictionary * dicnary = [self queryData];
    int user_id = [[dicnary objectForKey:@"user_id"] intValue];
    
    if (user_id == nodeId) {
        [self showToast:@"不能选择自己"];
        return;
    }
    for (NSMutableDictionary * diction in self.selectList) {
        int curNodeId = [[diction objectForKey:@"nodeId"] intValue];
        if (curNodeId == nodeId) {
            NSString * isXz = [self getPinjieNSString:@"已选中":name];
            [self showToast:isXz];
            return;
        }
    }
    
    NSMutableDictionary * perDic = [NSMutableDictionary dictionary];
    [perDic setValue:name forKey:@"name"];
    [perDic setValue:@(nodeId) forKey:@"nodeId"];
      [perDic setValue:head_img forKey:@"head_img"];
    
    [self.selectList addObject:perDic];
    
    [self setPersonList];
    
}

// 呼叫增援
-(void)setHujzy{
    
    CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"提示" message:@"确定呼叫增援？" ];
    
    CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
    }];
    
    CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
        [self getHelpOrderInfo];
        
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    
    [self presentViewController:alertVC animated:NO completion:nil];
}

//  呼叫增援
-(void)getHelpOrderInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
    if ([self.selectList count] == 0){
        [self showToast:@"请添加增援人员"];
        return;
    }
    NSString * helpMan = @"";
    for (NSMutableDictionary * diction in self.selectList) {
        int nodeId = [[diction objectForKey:@"nodeId"] intValue];
        NSString *nodeIdString = [NSString stringWithFormat:@"%d",nodeId];
        NSString * flagStr  =   [self getPinjieNSString:nodeIdString:@","];
        helpMan =  [self getPinjieNSString:helpMan:flagStr];
        
    }
    int subSum = helpMan.length ;
    NSString * subString1 = [helpMan substringToIndex:subSum - 1];
    
    NSString * orderId = [self getIntegerValue:_order_id];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    [diction setValue:orderId forKey:@"order_id"];
    [diction setValue:subString1 forKey:@"help_man"];
    
    
    NSString * url = [self getPinjieNSString:baseUrl :helpOrderInfo];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
    [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            
        }
        if ([myResult isKindOfClass:[NSString class]]) {
            int myCode = -1;
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                myCode  = [[responseObject objectForKey:@"code"] intValue];
            }
            if (myCode == 200) {
                [self setHelpOrderInfo];
                return;
            }
            NSString * myMessage =  [responseObject objectForKey:@"message"];
            [self showToastTwo:myMessage];
        }
        
    } failure:^(NSError *error) {
        //请求失败
        NSString * errorStr =  [self getError:error];
        [self showToastTwo:errorStr];
        
    }];
}
-(void)setHelpOrderInfo{
    MyEventBus * myEvent = [[MyEventBus alloc] init];
    myEvent.errorId = @"WorkDetailsViewController";
    [[QTEventBus shared] dispatch:myEvent];
    
    [self performSelector:@selector(setScan) withObject:nil afterDelay:3.0f];
    
    [self showToast:@"操作完成"];
}


@end
