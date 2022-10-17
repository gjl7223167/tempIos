//
//  MyTaskDetailsNoViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/28.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MyTaskDetailsNoViewController.h"
#import "WRNavigationBar.h"
#import "MyTaskDetailsTableViewCell.h"
#import "QTEventBus.h"
#import "MyEventBus.h"
#import "QTEventBus+AppModule.h"

// offsetY > -64 的时候导航栏开始偏移
#define NAVBAR_TRANSLATION_POINT 0


#define NavBarHeight 44

@interface MyTaskDetailsNoViewController ()

@end

@implementation MyTaskDetailsNoViewController

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    self.edgesForExtendedLayout = UIRectEdgeNone; //view不需要拓展到整个屏幕
    self.navigationItem.title = @"任务详情";
    
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
    [MobClick beginLogPageView:@"MyTaskDetailsNoViewController"];
    [self getSelectMyJobPointInfoByPage];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MyTaskDetailsNoViewController"];
    [self setNavigationBarTransformProgress:0];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_TRANSLATION_POINT)
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self setNavigationBarTransformProgress:1];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self setNavigationBarTransformProgress:0];
        }];
    }
}
- (void)setNavigationBarTransformProgress:(CGFloat)progress
{
    [self.navigationController.navigationBar wr_setTranslationY:(-NavBarHeight * progress)];
    // 有系统的返回按钮，所以 hasSystemBackIndicator = YES
    [self.navigationController.navigationBar wr_setBarButtonItemsAlpha:(1 - progress) hasSystemBackIndicator:YES];
}

-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView{
    _personNib = [UINib nibWithNibName:@"MyTaskDetailsTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    [self.cancelBtn addTarget:self action:@selector(setScan) forControlEvents:UIControlEventTouchUpInside];
    [self.submitBtn addTarget:self action:@selector(setSubmit) forControlEvents:UIControlEventTouchUpInside];
    
    [self dataSource];
    [self.uitableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.uitableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
      self.uitableView.showsVerticalScrollIndicator = NO;
    
    UINib *nib = [UINib nibWithNibName:@"MyTaskTableHeaderView" bundle:nil];
    MyTaskTableHeaderView *header = [nib instantiateWithOwner:nil options:nil][0];
    //     header.autoresizingMask = UIViewAutoresizingNone;
    self.uitableView.tableHeaderView = header;
    
    [self setHeaderView:header];
    
    if (![self isBlankString:self.loseContent]) {
        self.submitBtn.userInteractionEnabled=NO;//交互关闭
        self.submitBtn.alpha=0.4;//透明度
    }
    
    [self.uitableView reloadData];
}

-(void)setHeaderView:(MyTaskTableHeaderView *)header{
    
    self.taskTime = header.taskTime;
    self.wuxuJx = header.wuxuJx;
    self.taskNumber = header.taskNumber;
    self.taskName = header.taskName;
    self.yDdBtn = header.yDdBtn;
    self.yDdEvent = header.yDdEvent;
    self.jxxBtn = header.jxxBtn;
    self.ljBtn = header.ljBtn;
    self.wKsBtn = header.wKsBtn;
    self.ljsmText = header.ljsmText;
    
    NSString * create_time = [self.diction objectForKey:@"create_time"];
    create_time = [self getDeviceDateSixTwo:create_time];
    NSString * is_sort = [self.diction objectForKey:@"is_sort"];
    int is_sort_int = [is_sort intValue];
    NSString * plan_name = [self.diction objectForKey:@"plan_name"];
    NSString * pointCount = [self.diction objectForKey:@"pointCount"];
    
    NSString * plan_end_time = [self.diction objectForKey:@"plan_end_time"];
    plan_end_time = [self getDeviceDateSixTwo:plan_end_time];
    
    NSString * curTime = [self getPinjieNSString:create_time:@"-"];
    curTime = [self getPinjieNSString:curTime:plan_end_time];
    self.taskTime.text = curTime;
    
    
    NSString * isXj = @"";
    if (is_sort_int == 0) {
        isXj = @"无序巡检";
        [self.wuxuJx setTitle:isXj forState:UIControlStateNormal];
        [self.wuxuJx setImage:[UIImage imageNamed:@"wuxuxj"] forState:UIControlStateNormal];
    }else{
        isXj = @"有序巡检";
        [self.wuxuJx setTitle:isXj forState:UIControlStateNormal];
        [self.wuxuJx setImage:[UIImage imageNamed:@"youxuxj"] forState:UIControlStateNormal];
    }
    self.taskName.text = plan_name;
    self.taskNumber.text = [self getIntegerValue:pointCount];
    
    self.ljsmText.layer.masksToBounds = YES;
    self.ljsmText.layer.cornerRadius = 8;
    self.ljsmText.layer.borderWidth = 1;
    self.ljsmText.layer.borderColor = [[UIColor colorWithRed:193.0/255.0 green:195.0/255.0 blue:255.0/225.0 alpha:1] CGColor];
    
    
}

-(void)setSubmit{
    [self setSubmitDialog];
}




- (UITableView *)tabelview {
    
    return _uitableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dicOne  =   [self.dataSource objectAtIndex:indexPath.row];
 NSString * target_type =  [dicOne objectForKey:@"target_type"];
  int target_type_int = [target_type intValue];
 if (target_type_int == 1) {
     return 140;
 }
 return 180;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *  MyTaskTableNoCellView = @"CellId";
          //自定义cell类
          MyTaskDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyTaskTableNoCellView];
          if (!cell) {
              cell = [_personNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
          }
    cell.statuView.layer.cornerRadius = cell.statuView.frame.size.width / 2;
    cell.statuView.clipsToBounds = YES;
    
    cell.allView.layer.masksToBounds = YES;
         cell.allView.layer.cornerRadius = 8;
         cell.allView.layer.borderWidth = 0.5;
         cell.allView.layer.borderColor = [[UIColor colorWithRed:193.0/255.0 green:195.0/255.0 blue:225.0/255.0 alpha:1] CGColor];
    
    NSDictionary * dicOne  =   [self.dataSource objectAtIndex:indexPath.row];
    NSString * create_time =  [dicOne objectForKey:@"create_time"];
    NSString * point_target =  [dicOne objectForKey:@"point_target"];
      NSString * point_name =  [dicOne objectForKey:@"point_name"];
       NSString * check_type =  [dicOne objectForKey:@"check_type"];
      int check_type_int = [check_type intValue];
    NSString * status =  [dicOne objectForKey:@"status"];
      NSString * target_type =  [dicOne objectForKey:@"target_type"];
    int target_type_int = [target_type intValue];
    NSString * target_device_id =  [dicOne objectForKey:@"target_device_id"];
    NSString * target_position_detail = [dicOne objectForKey:@"target_position_detail"];
     NSString * pos_name = [dicOne objectForKey:@"pos_name"];
      NSString * target_device_name = [dicOne objectForKey:@"target_device_name"];
  
       NSString * sort =  [dicOne objectForKey:@"sort"];
    int sortInt = [sort intValue];
    
    if (sortInt < 100) {
        cell.positionValue.text = [self getPinjieNSString:@"0":[self getIntegerValue:sort]];
    }else{
        cell.positionValue.text = sort;
    }
    
    cell.jiancmb.numberOfLines = 3;//表示label可以多行显示
    [cell.jiancmb setLineBreakMode:NSLineBreakByTruncatingTail];
    
    cell.dianwmingc.numberOfLines = 3;//表示label可以多行显示
    [cell.dianwmingc setLineBreakMode:NSLineBreakByTruncatingTail];
    
    cell.weizxx.numberOfLines = 3;//表示label可以多行显示
    [cell.weizxx setLineBreakMode:NSLineBreakByTruncatingTail];
    
    NSString * jjmbStr = @"";
 
    if (target_type_int == 1) {
        jjmbStr =   [self getPinjieNSString:jjmbStr:@""];
           jjmbStr =   [self getPinjieNSString:jjmbStr:pos_name];
          jjmbStr =   [self getPinjieNSString:jjmbStr:target_position_detail];
        cell.jiancmb.text = jjmbStr;
        
        [cell.wzxxView setHidden:YES];
    }else{
        cell.jiancmb.text = target_device_name;
        jjmbStr =   [self getPinjieNSString:jjmbStr:@""];
        jjmbStr =   [self getPinjieNSString:jjmbStr:pos_name];
        jjmbStr =   [self getPinjieNSString:jjmbStr:target_position_detail];
      
        cell.weizxx.text = jjmbStr;
         [cell.wzxxView setHidden:NO];
    }
    cell.dianwmingc.text = point_name;
   
    cell.taskTime.text = create_time;
    
    int status_int = [status intValue];
    if (status_int == 3) {
        cell.statuView.backgroundColor = [UIColor colorWithRed:239/255.0 green:123/255.0 blue:125/225.0 alpha:1];
    }else  if (status_int == 0 || status_int == 1){
         cell.statuView.backgroundColor = [UIColor colorWithRed:248/255.0 green:213/255.0 blue:73/225.0 alpha:1];
    }else{
          cell.statuView.backgroundColor = [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/225.0 alpha:1];
    }
    
    cell.ddtype.textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255/225.0 alpha:1];
    cell.ddtype.backgroundColor = [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/225.0 alpha:1];
     cell.ddtype.layer.masksToBounds = YES;
    cell.ddtype.layer.cornerRadius = 10;
    
    if (check_type_int == 2) {
        cell.ddtype.text = @"二维码";
    }else{
           cell.ddtype.text = @"手动";
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self setNavigationBarTransformProgress:0];
    }];
    
    long myInt =  indexPath.row;
     NSString *string = [NSString stringWithFormat:@"%ld",myInt];
    
    
    HitPointViewController * alartDetail = [[HitPointViewController alloc] init];
      alartDetail.line_id = self.line_id;
      alartDetail.job_id = self.job_id;
      alartDetail.curposition = string;
      alartDetail.total = self.total;
      alartDetail.dataSourceTwo = self.dataSource;
          [self.navigationController pushViewController:alartDetail  animated:YES];
}

-(void)getSelectMyJobPointInfoByPage{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    [diction setValue:@(20) forKey:@"pageSize"];
    [diction setValue:@(1) forKey:@"pageNum"];
    [diction setValue:self.job_id forKey:@"job_id"];
    
    NSString * url = [self getPinjieNSString:baseUrl :selectMyJobPointInfoByPage];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
          [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        _total = [responseObject objectForKey:@"total"];
        if ([myResult isKindOfClass:[NSArray class]]) {
            
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            [self setSelectMyJobPointInfoByPage:myResult];
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
-(void)setSelectMyJobPointInfoByPage:(NSMutableDictionary *) nsmudic{
    
    NSString * evenNum =  [nsmudic objectForKey:@"evenNum"];
    NSString * isCheckNum =  [nsmudic objectForKey:@"isCheckNum"];
    NSString * noCheckNum =  [nsmudic objectForKey:@"noCheckNum"];
    NSString * nowCheckNum =  [nsmudic objectForKey:@"nowCheckNum"];
    
        NSString * oneStr =  [self getPinjieNSString:@"已打点":[self getIntegerValue:evenNum]];
        [self.yDdBtn setTitle:oneStr forState:UIControlStateNormal];
    
        NSString * twoStr =  [self getPinjieNSString:@"进行中":[self getIntegerValue:isCheckNum]];
           [self.jxxBtn setTitle:twoStr forState:UIControlStateNormal];
    
        NSString * threeStr =  [self getPinjieNSString:@" 漏检":[self getIntegerValue:noCheckNum]];
             [self.ljBtn setTitle:threeStr forState:UIControlStateNormal];
    
        NSString * fourStr =  [self getPinjieNSString:@"未开始":[self getIntegerValue:nowCheckNum]];
                [self.wKsBtn setTitle:fourStr forState:UIControlStateNormal];
    
    NSMutableArray * listArr =  [nsmudic objectForKey:@"list"];
    
    [self clearData];
    for (NSMutableDictionary * nsmuTab in listArr) {
        [self.dataSource addObject:nsmuTab];
    }
    [self.uitableView reloadData];
    
}

-(void)clearData{
    [self.dataSource removeAllObjects];
    
}

-(void)setSubmitDialog{
    
    CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"提示" message:@"是否提交漏检说明" ];
    
    CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
    }];
    
    CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确认" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
        
        [self getInsertMyJobLineLoseInfoByJobId];
        
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    
    [self presentViewController:alertVC animated:NO completion:nil];
}

-(void)getInsertMyJobLineLoseInfoByJobId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
        NSString * ljsmTextStr = self.ljsmText.text;
//    NSString * ljsmTextStr = @"";
    if ([self isBlankString:ljsmTextStr]) {
        [self showToast:@"请输入漏检说明！"];
        return;
    }
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    [diction setValue:ljsmTextStr forKey:@"lose_content"];
    [diction setValue:self.job_id forKey:@"job_id"];
    
    NSString * url = [self getPinjieNSString:baseUrl :insertMyJobLineLoseInfoByJobId];

    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
//        id myResult =  [ self getMyResult:responseObject];
        
        int  myCode  = [[responseObject objectForKey:@"code"] intValue];
        
       NSString * message = [Utils getSuccess:myCode];
        [self showToastTwo:message];
        
                 if (myCode == 200) {
                     
                     MyEventBus * myEvent = [[MyEventBus alloc] init];
                          myEvent.errorId = @"MyTaskNoViewController";
                             [[QTEventBus shared] dispatch:myEvent];
                        [self.navigationController popViewControllerAnimated:YES];
//                     [self showToastTwo:@"已提交审核"];
                 }
        
    } failure:^(NSError *error) {
        //请求失败
        NSString * errorStr =  [self getError:error];
        [self showToastTwo:errorStr];
        
    }];
}
-(void)setInsertMyJobLineLoseInfoByJobId:(NSMutableDictionary *) nsmudic{
    
}

@end
