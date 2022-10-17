//
//  XjEventViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/8/26.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "XjEventViewController.h"
#import "WRNavigationBar.h"


@interface XjEventViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation XjEventViewController

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"XjEventViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"XjEventViewController"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone; //view不需要拓展到整个屏幕
            self.navigationItem.title = @"事件详情";
           
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


-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView{
   
      _personNib = [UINib nibWithNibName:@"PictureItemCollectionViewCell" bundle:nil];

    self.moveScrollview.showsVerticalScrollIndicator = FALSE;
    
    if ([self getNSStringEqual:self.set_name:@"标签丢失"] || [self getNSStringEqual:self.set_name:@"扫描失败"]) {
        [self.remarkView setHidden:YES];
        [self.pieListView setHidden:YES];
    }
    
//    self.talkPerson.numberOfLines = 0;//表示label可以多行显示
//    self.devicePosition.lineBreakMode = UILineBreakModeWordWrap;
//    [self.talkPerson setLineBreakMode:NSLineBreakByWordWrapping];
    
    self.setPosition.numberOfLines = 3;//表示label可以多行显示
    [self.setPosition setLineBreakMode:NSLineBreakByTruncatingTail];
    
    self.taskName.lineBreakMode = NSLineBreakByWordWrapping;
    self.taskName.numberOfLines = 0;
    self.taskName.preferredMaxLayoutWidth = SCREEN_WIDTH;
    
    [self dataSource];
    [self myCollectionView];
    [self cellIdentifierDic];
       [self.collectionView reloadData];
    
    [self getSelectEventInfoByEventId];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
   
}

- (UICollectionView *)collectionView {
    
    return _collectionView;
}

- (NSInteger)tableView:(UICollectionView *)collectionView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
    
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(PictureItemCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
   
}

- (void)tableView:(UICollectionView *)collectionView didEndDisplayingCell:(PictureItemCollectionViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
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
        [self.collectionView registerNib:[UINib nibWithNibName:@"PictureItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    }
    //    static NSString *cellID = @"myCell";
    PictureItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PictureItemCollectionViewCell" owner:self options:nil]lastObject];
    }
    
    long position =  indexPath.row + indexPath.section;
     UIImage * uiimage =  [self.dataSource objectAtIndex:position];
   
    
    NSObject * objectOne  =   [self.dataSource objectAtIndex:position];
    if ([objectOne isKindOfClass:[NSString class]]) {
     NSString * myString =   [self.dataSource objectAtIndex:position];
        UIImage * dicOne  =   [UIImage imageNamed:@"addpicture"];
        if ([self getNSStringEqual:myString :@"添加图片"]) {
             [cell.addPictre sd_setImageWithURL:@"" placeholderImage:dicOne];
        }else{
            UIImage * dicOne  =   [UIImage imageNamed:@"addpicture"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
               NSString * pictureUrl = [defaults objectForKey:@"pictureUrl"];
               NSString * imageUrl =  [self getPinjieNSString:pictureUrl:myString];
             [cell.addPictre sd_setImageWithURL:imageUrl placeholderImage:dicOne];
        }
       
    }else{
         cell.addPictre.image = uiimage;
    }
   
    
//     [cell.addPictre sd_setImageWithURL:imageUrl placeholderImage:dicOne];
  
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
    
    PictureItemCollectionViewCell *cell = (PictureItemCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    long position =  indexPath.row + indexPath.section;
    
    [UIView performWithoutAnimation:^{
      //刷新界面
       [self.collectionView reloadData];
    }];
    
    NSMutableArray *items = @[].mutableCopy;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
               NSString * pictureUrl = [defaults objectForKey:@"pictureUrl"];
        for (int i = 0;i< [self.dataSource count];i++) {
            NSString * objectOne  =   [self.dataSource objectAtIndex:i];
            objectOne = [self getPinjieNSString:pictureUrl:objectOne];
            YSPhotoItem *item3 = [[YSPhotoItem alloc] initWithSourceView:cell.addPictre imageUrl:[NSURL URLWithString:objectOne]];
            [items addObject:item3];
        }
    
    [YSPhotoBrowser showBrowserWithPhotoItems:items selectedIndex:position imageLongPressStyleTitles:@[@"取消"] browserAlertSheetBlock:^(NSInteger imagePageIndex, NSInteger alertSheetType, UIImage * _Nullable image, NSString * _Nullable imageUrl) {
              if (alertSheetType == 0) {
                  NSLog(@"保存图片");
              }else if (alertSheetType == 1){
                  NSLog(@"转发图片");
              }else{
                  NSLog(@"取消");
              }
          }];

}

//取消选中操作
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (UICollectionView *)myCollectionView {
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) collectionViewLayout:layout];
        
        self.collectionView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
    
        self.collectionView.alwaysBounceHorizontal = YES;
           self.collectionView.showsHorizontalScrollIndicator = NO;
        
        [self.addPicView addSubview:_collectionView];
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

-(void)getSelectEventInfoByEventId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
       int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
       [diction setValue:@(app_Version) forKey:@"version_code"];
    [diction setValue:self.event_id forKey:@"event_id"];
    
     [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
    [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
 
    NSString * url = [self getPinjieNSString:baseUrl :selectEventInfoByEventId];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            [self setSelectEventInfoByEventId:myResult];
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
-(void)setSelectEventInfoByEventId:(NSMutableDictionary *) nsmutable{
    NSString * set_name = [nsmutable objectForKey:@"set_name"];
      NSString * content = [nsmutable objectForKey:@"content"];
      NSString * create_time = [nsmutable objectForKey:@"create_time"];
     NSString * target_position_detail = [nsmutable objectForKey:@"target_position_detail"];
     NSString * line_name = [nsmutable objectForKey:@"line_name"];
       NSString * job_name = [nsmutable objectForKey:@"job_name"];
      NSString * job_code = [nsmutable objectForKey:@"job_code"];
     NSString * target_type = [nsmutable objectForKey:@"target_type"];
     NSString * pos_name = [nsmutable objectForKey:@"pos_name"];
       NSString * description = [nsmutable objectForKey:@"description"];
    NSMutableDictionary * workerInfoStr = [nsmutable objectForKey:@"workerInfo"];
    NSString * user_nike_name = [workerInfoStr objectForKey:@"user_nike_name"];
    NSMutableArray * handlerArray = [nsmutable objectForKey:@"handlers"];
    NSMutableArray * pointImgAppVolist = [nsmutable objectForKey:@"pointImgAppVolist"];
    
    NSString * handleNameStr = @"";
    for (NSMutableDictionary * handleDic in handlerArray) {
       NSString * handle_name = [handleDic objectForKey:@"handle_name"];
        
        handleNameStr = [self getPinjieNSString:handleNameStr:handle_name];
         handleNameStr = [self getPinjieNSString:handleNameStr:@","];
    }
    long handleLength = [handleNameStr length];
    if (handleLength > 1) {
        handleNameStr = [handleNameStr substringToIndex:handleLength - 1];
    }
    
    NSString * setWZposition = @"";
    setWZposition = [self getPinjieNSString:setWZposition:pos_name];
     setWZposition = [self getPinjieNSString:setWZposition:target_position_detail];
    
    self.setName.text = set_name;
    self.setDescri.text = description;
    self.setTime.text = create_time;
    self.setPosition.text = setWZposition;
    self.pointName.text = line_name;
    self.taskName.text = job_name;
    self.setPerson.text = user_nike_name;
    self.talkPerson.text = handleNameStr;
    self.setRemark.text = content;
    [self.dataSource removeAllObjects];
    for (int i =0;i<[pointImgAppVolist count];i++) {
        NSDictionary * imgDic = [pointImgAppVolist objectAtIndex:i];
        NSString * image_url = [imgDic objectForKey:@"image_url"];
          [self.dataSource addObject:image_url];
    }
    [self.collectionView reloadData];
}

@end
