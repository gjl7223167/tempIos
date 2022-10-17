//
//  ManageerAppViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/6/28.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "ManageerAppViewController.h"
#import "Cell.h"
#import "CellModel.h"
#import "DragCellCollectionView.h"
#import "DataManager.h"
#import "CollectionReusableHeaderView.h"
#import "CollectionReusableFooterView.h"
#import "WRNavigationBar.h"
#import <UMCommon/MobClick.h>

@interface ManageerAppViewController ()<DragCellCollectionViewDataSource, DragCellCollectionViewDelegate>

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, weak) DragCellCollectionView *mainView;
@property (nonatomic, assign) UIBarButtonItem *editButton;
@property (nonatomic, strong) DataManager *sourceManager;

@end

@implementation ManageerAppViewController

-(NSMutableArray *)appData{
    if (!_appData) {
        _appData = [NSMutableArray array];
    }
    return _appData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:243/255.0 blue:255/255.0 alpha:1.0];
      self.navigationItem.title = @"管理我的应用";
    
         UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];

         float cellWidth = floor((self.view.bounds.size.width - 50)/4.0);
         layout.itemSize = CGSizeMake(cellWidth, cellWidth);
         layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
         DragCellCollectionView *mainView = [[DragCellCollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
         _mainView = mainView;
         mainView.delegate = self;
         mainView.dataSource = self;
         mainView.backgroundColor = [UIColor whiteColor];
         [mainView registerNib:[UINib nibWithNibName:@"Cell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
         [mainView registerClass:[CollectionReusableHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
         [mainView registerClass:[CollectionReusableFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];

         [self.view addSubview:mainView];
    self.sourceManager = [DataManager shareDataManager];
    [self.sourceManager setDataManagerValue:self.appData];
         
         UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(baginEditing:)];
         self.navigationItem.rightBarButtonItem = buttonItem;
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(baginEditing:) name:notification_CellBeganEditing object:nil];
    
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
    [MobClick beginLogPageView:@"ManageerAppViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ManageerAppViewController"];
}

-(void)initView{
    [self appData];
}


-(void)setScan{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)baginEditing:(id)sender {
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        _mainView.beginEditing = !_mainView.beginEditing;
    }
    if (_mainView.beginEditing) {
        self.navigationItem.rightBarButtonItem.title = @"完成";
    }else {
        self.navigationItem.rightBarButtonItem.title = @"管理";
        [self setAppSelectData];
    }
}
-(void)setAppSelectData{
   NSMutableArray * selectArray = self.sourceManager.dataArray;
   NSMutableArray  * selectOneArray = [selectArray objectAtIndex:0];
    NSMutableArray * submitArray = [NSMutableArray array];
    for (int i = 0;i< [selectOneArray count] ;i++) {
      CellModel * cellModel =  [selectOneArray objectAtIndex:i];
        NSString * titleCell = cellModel.title;
        if (![self getNSStringEqual:titleCell:@"全部"]) {
            NSMutableDictionary * cellItem = [NSMutableDictionary dictionary];
                   [cellItem setValue:cellModel.app_id forKey:@"app_id"];
                   [cellItem setValue:@(i) forKey:@"sort"];
                   [submitArray addObject:cellItem];
        }
       
    }
    NSLog(@"ddd");
    
    [self getMoveHomePageByApp:submitArray];
}

-(void)getMoveHomePageByApp:(NSMutableArray *)submitArray{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
    NSString * myString = [self nsmudictionaryToJson:submitArray];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
       int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
       [diction setValue:@(app_Version) forKey:@"version_code"];
     [diction setValue:myString forKey:@"appAndSort"];
 
    NSString * url = [self getPinjieNSString:baseUrl :moveHomePageByApp];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
               [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            [self setMoveHomePageByApp];
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
-(void)setMoveHomePageByApp{
  
    
}


#pragma mark - <DragCellCollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.sourceManager.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *sec = self.sourceManager.dataArray[section];
    return sec.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell resetModel:self.sourceManager.dataArray[indexPath.section][indexPath.item] :indexPath];
    return cell;
}

- (NSArray *)dataSourceArrayOfCollectionView:(DragCellCollectionView *)collectionView{
    return self.sourceManager.dataArray;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size;
    if (section == 0&&[DataManager shareDataManager].isShowHeaderMessage) {
        size= CGSizeMake(self.view.bounds.size.width, 60);
    }else {
        size= CGSizeMake(self.view.bounds.size.width, 25);
    }
    return size;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGSize size= CGSizeMake(self.view.bounds.size.width, 15);
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader){

        CollectionReusableHeaderView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        headView.title = [DataManager shareDataManager].titleArray[indexPath.section];
        if (indexPath.section == 0&&[DataManager shareDataManager].isShowHeaderMessage) {
            headView.isShowMessage = YES;
        }else if(indexPath.section == 0&& ![DataManager shareDataManager].isShowHeaderMessage) {
            headView.isShowMessage = NO;
        }else {
            headView.isShowMessage = NO;
        }

        reusableView = headView;
        
    }else if (kind == UICollectionElementKindSectionFooter){
        CollectionReusableFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            footerView.isShowTopLine = YES;
            footerView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
        }else {
            footerView.backgroundColor = [UIColor whiteColor];
            footerView.isShowTopLine = NO;

        }
        reusableView = footerView;
    }
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(Cell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

    if (cell.data.isNewAdd &&indexPath.section == 0) {
        cell.transform = CGAffineTransformMakeScale(0.001, 0.001);
        [UIView animateWithDuration:0.2 animations:^{
            cell.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            cell.data.isNewAdd = NO;
        }];
    }
}

#pragma mark - <DragCellCollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    

}

- (void)dragCellCollectionView:(DragCellCollectionView *)collectionView newDataArrayAfterMove:(NSArray *)newDataArray{
    self.sourceManager.dataArray = newDataArray.mutableCopy;
}

- (void)dragCellCollectionView:(DragCellCollectionView *)collectionView cellWillBeginMoveAtIndexPath:(NSIndexPath *)indexPath{
    //拖动时候最后禁用掉编辑按钮的点击
    _editButton.enabled = NO;
}

- (void)dragCellCollectionViewCellEndMoving:(DragCellCollectionView *)collectionView{
    _editButton.enabled = YES;
}




@end
