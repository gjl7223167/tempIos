//
//  AnLightTableViewCell.h
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/14.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "anLightView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnLightTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet anLightView *lightViewOne;
@property (weak, nonatomic) IBOutlet anLightView *lightViewTwo;
@property (weak, nonatomic) IBOutlet anLightView *lightViewThree;
@property (weak, nonatomic) IBOutlet anLightView *lightViewFour;


@property(nonatomic ,copy) NSString *workOrderId;


-(void)updateStatus;



@end

NS_ASSUME_NONNULL_END
