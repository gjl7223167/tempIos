//
//  CarLogoItemViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2019/9/10.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import "CarLogoItemCollectionViewCell.h"
 #import "UIImageView+WebCache.h"
typedef void (^ReturnValueBlockTwo) (NSMutableDictionary *strValue);
@interface CarLogoItemViewController : MainViewController{
    UINib *_personNib;
}
@property(nonatomic, copy) ReturnValueBlockTwo returnValueBlock;
@property (weak, nonatomic) IBOutlet UICollectionView *carLogoList;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSString * carType;
@property (nonatomic,strong) NSMutableDictionary *selectSingle;

@property (weak, nonatomic) IBOutlet UIButton *okBtn;


@end
