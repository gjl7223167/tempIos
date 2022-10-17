//
//  AllWorkOrderTableViewCell.h
//
//  Created by 袁小强 on 2020/6/2.
//  Copyright © 2020  天拓四方 All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AllWorkOrderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *orderCode;

@property (weak, nonatomic) IBOutlet UIButton *turnXj;
@property (weak, nonatomic) IBOutlet UILabel *myTaskName;
@property (strong, nonatomic) IBOutlet UILabel *myTaskTime;

@property (strong, nonatomic) IBOutlet UILabel *myTaskDes;

@property (strong, nonatomic) IBOutlet UIImageView *overTime;
@property (strong, nonatomic) IBOutlet UIImageView *oneSelf;


@end

