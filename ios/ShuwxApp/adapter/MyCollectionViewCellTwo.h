//
//  MyCollectionViewCellTwo.h
//  ShuwxApp
//
//  Created by 袁小强 on 2019/12/14.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProLabel.h"

@interface MyCollectionViewCellTwo : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *myLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataValue;
@property (weak, nonatomic) IBOutlet UILabel *dataUnit;


@property (weak, nonatomic) IBOutlet UIView *viewOne;
@property (weak, nonatomic) IBOutlet UIView *viewTwo;

@property (weak, nonatomic) IBOutlet UIView *bluePointView;

@end


