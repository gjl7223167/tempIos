//
//  ShowTaskDetailsViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/3/23.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "ShowTaskDetailsViewController.h"
#import "WRNavigationBar.h"
#import "MissTaskDetailsCollectionViewCell.h"


@interface ShowTaskDetailsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ShowTaskDetailsViewController

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(NSMutableDictionary *)cellIdentifierDic{
    if (!_cellIdentifierDic) {
        _cellIdentifierDic = [NSMutableDictionary dictionary];
    }
    return _cellIdentifierDic;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.mainScrollView.frame = CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
                self.navigationItem.title = @"点位详情";
               
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
    [MobClick beginLogPageView:@"ShowTaskDetailsViewController"];
  
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ShowTaskDetailsViewController"];
}

-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView{
    _personNib = [UINib nibWithNibName:@"MissTaskDetailsCollectionViewCell" bundle:nil];
    [self dataSource];
    [self cellIdentifierDic];
    temPosition = -1;
    [self myCollectionView];
    
    self.missLegend.layer.cornerRadius = 5.0;
    self.missLegend.layer.masksToBounds = YES;
    self.missLegend.layer.borderWidth = 1.0;
    self.missLegend.layer.borderColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:247.0/255.0 alpha:1].CGColor;
    
    [self.missLegend setEditable:NO];
    
    self.missLegend.text = self.lose_content;
    temPosition = 0;
    [self getSelectMyJobLineLoseInfoByJobId];
}


- (UICollectionView *)collectionView {
    
    return _collectionView;
}

- (NSInteger)tableView:(UICollectionView *)collectionView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
    
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(MissTaskDetailsCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
   
}

- (void)tableView:(UICollectionView *)collectionView didEndDisplayingCell:(MissTaskDetailsCollectionViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}
//配置每个item的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake(120, 120);
    
}

//配置item的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


//当前ite是否可以点击
- (BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __FUNCTION__);
    return YES;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = [self.cellIdentifierDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    if(identifier == nil){
        identifier = [NSString stringWithFormat:@"selectedBtn%@", [NSString stringWithFormat:@"%@", indexPath]];
        [self.collectionView registerNib:[UINib nibWithNibName:@"MissTaskDetailsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    }
    //    static NSString *cellID = @"myCell";
    MissTaskDetailsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MissTaskDetailsCollectionViewCell" owner:self options:nil]lastObject];
    }
    
    cell.yuanxView.layer.cornerRadius = cell.yuanxView.frame.size.width / 2;
      cell.yuanxView.clipsToBounds = YES;
    
    int position =  indexPath.row + indexPath.section;
    if (temPosition == position) {
    //    cell.yuanxView.backgroundColor = [UIColor redColor];
        [cell.triangleView setHidden:NO];
    }else{
       // cell.yuanxView.backgroundColor = [UIColor redColor];
          [cell.triangleView setHidden:YES];
    }
    
   NSDictionary * dicOne  =   [self.dataSource objectAtIndex:position];
   NSString * create_time =  [dicOne objectForKey:@"create_time"];
    NSString * sort =  [dicOne objectForKey:@"sort"];
    
    cell.pointTime.numberOfLines = 0;//表示label可以多行显示
    cell.pointTime.lineBreakMode = NSLineBreakByCharWrapping;//换行模式，与上面的计算保持一致。
     cell.pointTime.text = create_time;
    
    cell.pointValue.text = [self getIntegerValue:sort];
    
    NSString * status =  [dicOne objectForKey:@"status"];
       int status_int = [status intValue];
          if (status_int == 3) {
              cell.yuanxView.backgroundColor = [UIColor colorWithRed:239/255.0 green:123/255.0 blue:125/225.0 alpha:1];
          }else  if (status_int == 0 || status_int == 1){
               cell.yuanxView.backgroundColor = [UIColor colorWithRed:248/255.0 green:213/255.0 blue:73/225.0 alpha:1];
          }else{
                cell.yuanxView.backgroundColor = [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/225.0 alpha:1];
          }
    
    if (status_int == 2) {
        [cell.pointTime setHidden:NO];
    }else{
        [cell.pointTime setHidden:YES];
    }
     
    return cell;
}


//设置点击高亮和非高亮效果！
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//   高亮
-  (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
//  取消高亮
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
//   点击cell事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MissTaskDetailsCollectionViewCell *cell = (MissTaskDetailsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
      int position =  indexPath.row + indexPath.section;
    temPosition = position;
    
    [UIView performWithoutAnimation:^{
      //刷新界面
       [self.collectionView reloadData];
    }];
    
    NSDictionary * dicOne  =   [self.dataSource objectAtIndex:position];
    [self setPointInfoValue:dicOne];
    
}

-(void)setPointInfoValue:(NSMutableDictionary *)dicOne{
    NSString * create_time =  [dicOne objectForKey:@"create_time"];
      NSString * sort =  [dicOne objectForKey:@"sort"];
    NSString * point_name = [dicOne objectForKey:@"point_name"];
    NSString * target_type =  [dicOne objectForKey:@"target_type"];
      int target_type_int = [target_type intValue];
    NSString * check_type =  [dicOne objectForKey:@"check_type"];
        int check_type_int = [check_type intValue];
    NSString * target_device_id =  [dicOne objectForKey:@"target_device_id"];
       NSString * target_position_detail = [dicOne objectForKey:@"target_position_detail"];
       NSString * pos_name = [dicOne objectForKey:@"pos_name"];
              NSString * target_device_name = [dicOne objectForKey:@"target_device_name"];
    
    self.taskNumber.text = [self getIntegerValue:sort];
    self.pointName.text = point_name;
   
      NSString * posPosition = @"";
    
       if (target_type_int == 1) {
           posPosition =   [self getPinjieNSString:posPosition:@""];
              posPosition =   [self getPinjieNSString:posPosition:pos_name];
             posPosition =   [self getPinjieNSString:posPosition:target_position_detail];
           self.jianCmb.text = posPosition;
           
           [self.wzxxView setHidden:YES];
       }else{
           posPosition =   [self getPinjieNSString:posPosition:@""];
                    posPosition =   [self getPinjieNSString:posPosition:target_device_name];
             self.jianCmb.text = posPosition;
       
            [self.wzxxView setHidden:NO];
       }
    
    self.positionXx.text = target_position_detail;
    
     self.taskType.textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255/225.0 alpha:1];
    self.taskType.backgroundColor = [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/225.0 alpha:1];
      self.taskType.layer.masksToBounds = YES;
     self.taskType.layer.cornerRadius = 10;
    
     
     if (check_type_int == 2) {
         self.taskType.text = @"二维码";
     }else{
           self.taskType.text = @"手动";
     }
    
}

//取消选中操作
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (UICollectionView *)myCollectionView {
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 280, SCREEN_WIDTH, 120) collectionViewLayout:layout];
        
        self.collectionView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
    
        self.collectionView.alwaysBounceHorizontal = YES;
           self.collectionView.showsHorizontalScrollIndicator = NO;
        
        [self.allView addSubview:_collectionView];
    }
    return _collectionView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;

}

//配置section数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{

    return 1;
}

-(void)getSelectMyJobLineLoseInfoByJobId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
       int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
       [diction setValue:@(app_Version) forKey:@"version_code"];
    [diction setValue:self.job_id forKey:@"job_id"];
      [diction setValue:self.line_id forKey:@"line_id"];

 
    NSString * url = [self getPinjieNSString:baseUrl :selectMyJobLineLoseInfoByJobId];

              [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
     [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            [self setSelectMyJobLineLoseInfoByJobId:myResult];
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
-(void)setSelectMyJobLineLoseInfoByJobId:(NSMutableDictionary *) nsmutable{
  
    NSString * plan_name = [nsmutable objectForKey:@"plan_name"];
     NSString * user_name = [nsmutable objectForKey:@"user_name"];
     NSString * start_time = [nsmutable objectForKey:@"start_time"];
     NSString * end_time = [nsmutable objectForKey:@"end_time"];
    
    NSString * myDate = @"";
          start_time = [self getDeviceDateSixTwo:start_time];
          end_time = [self getDeviceDateSixTwo:end_time];
          
          myDate = [self getPinjieNSString:start_time:@"-"];
          myDate = [self getPinjieNSString:myDate:end_time];
    
    self.taskTime.text = myDate;
    
    NSMutableArray * array = [nsmutable objectForKey:@"lose_point_list"];
    self.dataSource = array;
    
    [self.collectionView reloadData];
    
    self.taskName.text = plan_name;
    self.taskPerson.text = user_name;
    
    NSDictionary * dicOne  =   [array objectAtIndex:0];
       [self setPointInfoValue:dicOne];
}

@end
