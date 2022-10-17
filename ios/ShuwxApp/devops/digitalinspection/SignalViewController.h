//
//  SignalViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/27.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnValueBlockThree) (UIImage *strValue,NSString * filePath);
@interface SignalViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) IBOutlet UIView *kongjView;
@property(nonatomic, copy) ReturnValueBlockThree returnValueBlock;

@end

