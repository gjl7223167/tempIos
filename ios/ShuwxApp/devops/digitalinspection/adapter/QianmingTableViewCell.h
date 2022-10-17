//
//  QianmingTableViewCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/27.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProImageView.h"


@interface QianmingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleNumber;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UIView *titleOne;

@property (weak, nonatomic) IBOutlet UILabel *isReqest;
@property (nonatomic, strong) NSString * curPosition;
@property (weak, nonatomic) UIViewController * myViewController;

@property (weak, nonatomic) IBOutlet UIView *picViewTwo;
@property (weak, nonatomic) IBOutlet UILabel *qianmName;
@property (strong, nonatomic) IBOutlet ProImageView *imageView;


@end
