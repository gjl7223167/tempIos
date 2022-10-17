//
//  QianmingTableViewTwoCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/3/19.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProImageView.h"


@interface QianmingTableViewTwoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleNumber;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UIView *titleOne;

@property (weak, nonatomic) IBOutlet UILabel *isReqest;
@property (nonatomic, strong) NSString * curPosition;
@property (strong, nonatomic) UIViewController * myViewController;

@property (weak, nonatomic) IBOutlet UIView *picViewTwo;
@property (weak, nonatomic) IBOutlet ProImageView *imageView;


@end

