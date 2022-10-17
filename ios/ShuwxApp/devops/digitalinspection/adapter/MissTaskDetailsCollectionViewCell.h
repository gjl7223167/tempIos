//
//  MissTaskDetailsCollectionViewCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/21.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MissTaskDetailsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *yuanxView;
@property (weak, nonatomic) IBOutlet UIImageView *triangleView;

@property (weak, nonatomic) IBOutlet UILabel *pointTime;

@property (weak, nonatomic) IBOutlet UILabel *pointValue;

@property (strong, nonatomic) IBOutlet UIView *viewOne;
@property (strong, nonatomic) IBOutlet UIView *viewTwo;


@end

