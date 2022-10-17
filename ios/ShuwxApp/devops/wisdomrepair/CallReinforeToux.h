//
//  CallReinforeToux.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/6/22.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "ProBtn.h"
#import "CallReinforceViewController.h"

@interface CallReinforeToux : UIView

@property (strong, nonatomic) IBOutlet UIImageView *callToux;
@property (strong, nonatomic) NSString * pictureUrl;
@property (strong, nonatomic) NSString * defaultImage;
-(void)setUpdateView:(NSString * )imageUrlStr;

@property (strong, nonatomic) IBOutlet ProBtn *touxBtn;

@property (weak, nonatomic) UIViewController * callReinfore;

@property (strong, nonatomic) IBOutlet UILabel *callTitlee;

@end

