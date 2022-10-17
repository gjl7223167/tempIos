//
//  LookSubmitTwoTableView.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/3/18.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "LookSubmitTwoTableView.h"

@implementation LookSubmitTwoTableView

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
       
    }
    return _dataSource;
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 1;    // 减掉的值就是分隔线的高度
    [super setFrame:frame];
}

-(NSMutableDictionary *)cellIdentifierDic{
    if (!_cellIdentifierDic) {
        _cellIdentifierDic = [NSMutableDictionary dictionary];
    }
    return _cellIdentifierDic;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initView];
}
-(void)initView{
    self.titleOne.layer.cornerRadius = _titleOne.frame.size.width / 2;
    self.titleOne.clipsToBounds = YES;
    self.titleOne.layer.borderWidth = 1;
    self.titleOne.layer.borderColor = [[UIColor colorWithRed:193.0/255.0 green:195.0/255.0 blue:255.0/225.0 alpha:1] CGColor];
    
    _personNib = [UINib nibWithNibName:@"SubOneCollectionViewCell" bundle:nil];
           [self dataSource];
           [self cellIdentifierDic];
         [self myCollectionView];
         [self.collectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (UICollectionView *)collectionView {
    
    return _collectionView;
}

- (NSInteger)tableView:(UICollectionView *)collectionView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
    
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(SubOneCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
   
}

- (void)tableView:(UICollectionView *)collectionView didEndDisplayingCell:(SubOneCollectionViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}
//配置每个item的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

   return CGSizeMake(150, 40);
    
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
        [self.collectionView registerNib:[UINib nibWithNibName:@"SubOneCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    }
    //    static NSString *cellID = @"myCell";
    SubOneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SubOneCollectionViewCell" owner:self options:nil]lastObject];
    }
    //  int position =  indexPath.row + indexPath.section;


    
    NSMutableDictionary * dicOne  =   [self.dataSource objectAtIndex:indexPath.row];

       NSMutableDictionary * pointOptionDic =   [dicOne objectForKey:@"pointOption"];
      NSString * pointOption = [pointOptionDic objectForKey:@"pointOption"];
       cell.xxName.text = pointOption;
    
       cell.xuanxView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255/225.0 alpha:1];
    
    if ([self isBlankString:_selectStr]) {
           cell.xuanxView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255/225.0 alpha:1];
    }else{
         NSArray *array1 =[_selectStr componentsSeparatedByString:NSLocalizedString(@";", nil)];
         for (NSString * nsStr in array1) {
             if ([self getNSStringEqual:nsStr:pointOption]) {
                  cell.xuanxView.backgroundColor = [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/225.0 alpha:1];
             }
         }
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
    
    SubOneCollectionViewCell *cell = (SubOneCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
      int position =  indexPath.row + indexPath.section;
   
    
}
//取消选中操作
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (UICollectionView *)myCollectionView {
    if (self.collectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
         self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH - 20, 40) collectionViewLayout:layout];
        
        self.collectionView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
    
        self.collectionView.alwaysBounceHorizontal = YES;
           self.collectionView.showsHorizontalScrollIndicator = NO;
        
        [self.contentView addSubview:self.collectionView];
    }
    return self.collectionView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;

}

//配置section数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{

    return 1;
}

// 字符串相等
-(BOOL) getNSStringEqual:(NSString *) fromStr : (NSString *) toStr{
    BOOL isEqual =  [fromStr isEqualToString:toStr];;
    
    return isEqual;
}

//判断不为空
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


@end
