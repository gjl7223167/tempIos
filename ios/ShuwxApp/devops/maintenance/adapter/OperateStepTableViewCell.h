//
//  OperateStepTableViewCell.h
//
//  Created by 袁小强 on 2020/7/30.
//  Copyright © 2020 天拓四方. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OperateStepTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *operateTitle;
@property (strong, nonatomic) IBOutlet UILabel *operateContent;
@property (strong, nonatomic) IBOutlet UIScrollView *operateScrollView;
@property (strong, nonatomic) IBOutlet UIView *operatePicList;


@end

