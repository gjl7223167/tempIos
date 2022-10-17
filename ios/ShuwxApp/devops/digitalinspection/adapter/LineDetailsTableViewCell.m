//
//  LineDetailsTableViewCell.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/3/23.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "LineDetailsTableViewCell.h"
#import "MissTaskDetailsCollectionViewCell.h"

@implementation LineDetailsTableViewCell

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    
    }
    return _dataSource;
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 5;    // 减掉的值就是分隔线的高度
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initView{
    _personNib = [UINib nibWithNibName:@"MissTaskDetailsCollectionViewCell" bundle:nil];
      [self dataSource];
          [self cellIdentifierDic];
        [self myCollectionView];
      
        [self.collectionView reloadData];
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
    cell.yuanxView.layer.borderWidth = 2;
    cell.yuanxView.layer.borderColor = [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1] CGColor];
       cell.yuanxView.clipsToBounds = YES;
     
     int position =  indexPath.row + indexPath.section;
   
     [cell.triangleView setHidden:YES];
    if (position == 0) {
        [cell.viewOne setHidden:NO];
        [cell.viewTwo setHidden:YES];
    }else if(position ==  [self.dataSource count] - 1){
        [cell.viewOne setHidden:YES];
               [cell.viewTwo setHidden:NO];
    }else{
        [cell.viewOne setHidden:YES];
                    [cell.viewTwo setHidden:YES];
    }
    
    if ([_dataSource count] == 1) {
        [cell.viewOne setHidden:YES];
        [cell.viewTwo setHidden:YES];
    }
     
    NSDictionary * dicOne  =   [self.dataSource objectAtIndex:position];
    NSString * create_time =  [dicOne objectForKey:@"create_time"];
     NSString * sort =  [dicOne objectForKey:@"sort"];
    
    create_time = [Utils getDeviceDateSixFour:create_time];
     
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

// int类型的 nsstring
-(NSString *)getIntegerValue:(NSString *)normalNum{
    NSString * normalNumTwo =  [NSString stringWithFormat:@"%@", normalNum];
    NSDecimalNumber *normalNumThree = [NSDecimalNumber decimalNumberWithString:normalNumTwo];
    return [normalNumThree stringValue];
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
    
  
  
        
}


//取消选中操作
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (UICollectionView *)myCollectionView {
    if (_collectionView == nil) {
        
         UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
              layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        //最小行间距(默认为10)
             layout.minimumLineSpacing = 0;
             //最小item间距（默认为10）
             layout.minimumInteritemSpacing = 0;
        
                 self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 120) collectionViewLayout:layout];
       
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

@end
