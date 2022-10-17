//
//  SubmitTwoTableViewCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/26.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubOneCollectionViewCell.h"
#import "HitPointViewController.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface SubmitTwoTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    UINib *_personNib;
}

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableDictionary * cellIdentifierDic;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *titleOne;
@property (weak, nonatomic) IBOutlet UILabel *titleNumber;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *isReqest;
@property (nonatomic, strong) NSString * curPosition;
@property (weak, nonatomic) UIViewController * myViewController;

@end

