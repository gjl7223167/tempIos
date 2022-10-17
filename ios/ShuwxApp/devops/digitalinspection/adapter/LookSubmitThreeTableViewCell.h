//
//  LookSubmitThreeTableViewCell.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/3/18.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LookSubmitThreeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *titleOne;
@property (weak, nonatomic) IBOutlet UILabel *titleNumber;

@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *isReqest;
@property (nonatomic,strong) NSString * selectStr;

@end

