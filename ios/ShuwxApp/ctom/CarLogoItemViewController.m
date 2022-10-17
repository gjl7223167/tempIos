//
//  CarLogoItemViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2019/9/10.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "CarLogoItemViewController.h"

@interface CarLogoItemViewController ()

@end

@implementation CarLogoItemViewController

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(NSMutableDictionary *)selectSingle{
    if (!_selectSingle) {
        _selectSingle = [NSMutableDictionary dictionary];
    }
    return _selectSingle;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self dataSource];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
    fl.minimumInteritemSpacing = 0;
    fl.minimumLineSpacing = 3;
    
//      _personNib = [UINib nibWithNibName:@"CarLogoItemCollectionViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    
    [_carLogoList registerNib:[UINib nibWithNibName:@"CarLogoItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JXCell"];
    
    [self selectSingle];
    
      [_okBtn addTarget:self action:@selector(setOkBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self getSelectProducLogotByList];
    
}
-(void)setOkBtn{
    
    __weak typeof(self) weakself = self;
    if (weakself.returnValueBlock) {
        //将自己的值传出去，完成传值
        weakself.returnValueBlock(_selectSingle);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 获取 车标列表
-(void)getSelectProducLogotByList{
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    
    [diction setValue:_carType forKey:@"type"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
    [diction setValue:@(app_Version) forKey:@"version_code"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    
    [PPNetworkHelper openLog];
    NSString * url = [self getPinjieNSString:baseUrl :selectProducLogotByList];

    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            [self setSelectProducLogotByList:myResult];
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
-(void)setSelectProducLogotByList:(NSMutableArray *)nsArr{
    self.dataSource = nsArr;
    
    [self.carLogoList reloadData];
}

#pragma mark -- dataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
     return CGSizeMake(80, 120);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.dataSource count];

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {

          CarLogoItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JXCell" forIndexPath:indexPath];
        
        NSDictionary * dicOne  =   [_dataSource objectAtIndex:indexPath.row];
         NSString * logo_name =  [dicOne objectForKey:@"logo_name"];
          int logoId =  [[dicOne objectForKey:@"logo_id"] intValue];
        
        cell.carName.text = logo_name;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString * pictureUrl = [defaults objectForKey:@"pictureUrl"];
        
        NSString * img_addr =  [dicOne objectForKey:@"img_addr"];
        NSString * imageUrl = [self getPinjieNSString:pictureUrl:img_addr];
        
         NSString * defaultImage = @"defaultpic";
         [cell.carPictuure sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:defaultImage]];
        
        if ([self.selectSingle count]) {
            int selectLogoId =  [[_selectSingle objectForKey:@"logo_id"] intValue];
            if (logoId == selectLogoId) {
                //设置layer
                CALayer *layer=[cell.carPictuure layer];
                //是否设置边框以及是否可见
                [layer setMasksToBounds:YES];
                //设置边框圆角的弧度
                [layer setCornerRadius:0];
                //设置边框线的宽
                //
                [layer setBorderWidth:1];
                //设置边框线的颜色
                [layer setBorderColor:[[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1] CGColor]];

            }else{
                //设置layer
                CALayer *layer=[cell.carPictuure layer];
                //是否设置边框以及是否可见
                [layer setMasksToBounds:YES];
                //设置边框圆角的弧度
                [layer setCornerRadius:0];
                //设置边框线的宽
                //
                [layer setBorderWidth:0];
                //设置边框线的颜色
                [layer setBorderColor:[[UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1] CGColor]];
            }
            
        }
        
        return cell;
    }
    
    
    return nil;
    
    
}




//调节item边距

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(5, 5, 0, 5);
    
}

#pragma mark -- item点击跳转

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
      NSDictionary * dicOne  =   [_dataSource objectAtIndex:indexPath.row];
    _selectSingle = dicOne;
    
     [self.carLogoList reloadData];
}

@end
