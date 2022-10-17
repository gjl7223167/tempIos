//
//  WisdomServiceTopView.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/4/15.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WisdomServiceTopView : UIView

@property (strong, nonatomic) IBOutlet UILabel *orderTotal;
@property (strong, nonatomic) IBOutlet UILabel *orderTime;
@property (strong, nonatomic) IBOutlet UILabel *todayAddSum;
@property (strong, nonatomic) IBOutlet UILabel *todayPercentage;
@property (strong, nonatomic) IBOutlet UILabel *monthAddSum;
@property (strong, nonatomic) IBOutlet UILabel *monthPercentage;

@property (strong, nonatomic) IBOutlet UIImageView *myImageView;

-(void)setWisdomTopData:(NSMutableDictionary *)dictionary;

@property (strong, nonatomic) IBOutlet UIImageView *zengUpPic;
@property (strong, nonatomic) IBOutlet UIImageView *zengDownPic;



@end
