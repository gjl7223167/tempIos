//
//  MyCollectionViewCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2019/11/26.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProLabel.h"

@interface MyCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *myLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataValue;
@property (weak, nonatomic) IBOutlet UILabel *dataUnit;
@property (weak, nonatomic) IBOutlet UILabel *guvSum;
@property (weak, nonatomic) IBOutlet UILabel *alarmSum;

@property (weak, nonatomic) IBOutlet UIView *viewOne;
@property (weak, nonatomic) IBOutlet UIView *viewTwo;

@property (weak, nonatomic) IBOutlet UIView *bluePointView;

@end

