//
//  LookRepairViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/11/25.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "LookRepairViewController.h"
#import "WRNavigationBar.h"


@interface LookRepairViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation LookRepairViewController

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        [_dataSource addObject:@"添加图片"];
     
    }
    return _dataSource;
}

-(NSMutableArray *)photoList{
    if (!_photoList) {
        _photoList = [NSMutableArray array];
    }
    return _photoList;
}
-(NSMutableArray *)fileNameList{
    if (!_fileNameList) {
        _fileNameList = [NSMutableArray array];
    }
    return _fileNameList;
}

-(NSMutableDictionary *)cellIdentifierDic{
    if (!_cellIdentifierDic) {
        _cellIdentifierDic = [NSMutableDictionary dictionary];
    }
    return _cellIdentifierDic;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"LookRepairViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LookRepairViewController"];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.allScrollView.frame = CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"报修";
   
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
    [self.orderTypeBtn.layer setMasksToBounds:YES];
    [self.orderTypeBtn.layer setBorderWidth:1.0];
     [self.orderTypeBtn.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
    self.orderTypeBtn.layer.borderColor=[UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1.0].CGColor;
    
    [self.bxmbBtn.layer setMasksToBounds:YES];
       [self.bxmbBtn.layer setBorderWidth:1.0];
        [self.bxmbBtn.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
       self.bxmbBtn.layer.borderColor=[UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1.0].CGColor;
    
    [self.mbTextView setCornerRadius:3];
      [self.mbTextView setBorderColor:[UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1.0]];
     [self.mbTextView setBorderWidth:1];
      [self.mbTextView setPlaceholderColor:[UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1.0]];
    
    [self.mbTextView setPlaceholder:@"请选择"];
    
    __weak typeof(self) weakSelf = self;
    // 限制输入最大字符数.
    self.mbTextView.maxLength = 200;
    // 添加输入改变Block回调.
    [self.mbTextView addTextDidChangeHandler:^(FSTextView *textView) {
        __strong typeof(self) strongSelf = weakSelf;
      int srkValue =  textView.text.length;
        NSString *srkString = [NSString stringWithFormat:@"%d", srkValue];
        strongSelf.zdTextValue.text =  [strongSelf getPinjieNSString:srkString:@"/200"];
    }];
    // 添加到达最大限制Block回调.
    [self.mbTextView addTextLengthDidMaxHandler:^(FSTextView *textView) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf showToast:@"字数已到达上限！"];
    }];
    
    
    [self.alarmTypeBtn.layer setMasksToBounds:YES];
       [self.alarmTypeBtn.layer setBorderWidth:1.0];
        [self.alarmTypeBtn.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
       self.alarmTypeBtn.layer.borderColor=[UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1.0].CGColor;

    
    _personNib = [UINib nibWithNibName:@"PictureItemCollectionViewCell" bundle:nil];
    [self dataSource];
    [self photoList];
        [self fileNameList];
    [self cellIdentifierDic];
    [self myCollectionView];
     [self.collectionView reloadData];
   
     myType = 2;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
             //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
             tapGestureRecognizer.cancelsTouchesInView = NO;
             //将触摸事件添加到view上
             [self.view addGestureRecognizer:tapGestureRecognizer];
    
    
    [self getSelectOrderInfoByOrderId];
    
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.mbTextView resignFirstResponder];
  
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
    
      int position =  indexPath.row + indexPath.section;
     UIImage * uiimage =  [self.dataSource objectAtIndex:position];
   
    
    NSObject * objectOne  =   [self.dataSource objectAtIndex:position];
    if ([objectOne isKindOfClass:[NSString class]]) {
     NSString * myString =   [self.dataSource objectAtIndex:position];
         UIImage * dicOne  =   [UIImage imageNamed:@"addpicture"];
         cell.addPictre.image = dicOne;
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
    
      int position =  indexPath.row + indexPath.section;
    __weak typeof(self) weakSelf = self;
    [UIView performWithoutAnimation:^{
        __strong typeof(self) strongSelf = weakSelf;
       [strongSelf.collectionView reloadData];
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


//- (HXPhotoManager *)manager
//{
//    if (!_manager) {
//        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
//        _manager.configuration.photoMaxNum = 3;
//        _manager.configuration.videoMaxNum = 0;
//        _manager.configuration.maxNum = 18;
//    }
//    return _manager;
//}


- (void)albumListViewController:(NSArray<HXPhotoModel *> *)photos {
  //  self.photoList = photos;
    
    for (int i =0;i<[photos count];i++) {
        [self.fileNameList addObject:@"file"];
     HXPhotoModel * hxPhotoModel =   [photos objectAtIndex:i];

         UIImage * picurl = hxPhotoModel.thumbPhoto;
        [self.photoList addObject:picurl];
          [self.dataSource addObject:picurl];
    }
    [self.collectionView reloadData];
   
}
- (void)photoViewControllerDidCancel
{
    NSSLog(@"取消");
}


// 工单详情
-(void)getSelectOrderInfoByOrderId{
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
    
    
    NSString * url = [self getPinjieNSString:baseUrl :selectOrderInfoByOrderId];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
    [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            [self setSelectOrderInfoByOrderId:myResult];
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
-(void)setSelectOrderInfoByOrderId:(NSMutableDictionary *) nsmutable{
    
}

@end
