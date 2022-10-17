//
//  LineDetailsTableViewCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/3/23.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface LineDetailsTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
      UINib *_personNib;
     @public int temPosition;
}

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableDictionary * cellIdentifierDic;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UIView *allView;

@property (strong, nonatomic) IBOutlet UILabel *orderNumber;
@property (strong, nonatomic) IBOutlet UILabel *taskTime;
@property (strong, nonatomic) IBOutlet UILabel *taskName;



@end

