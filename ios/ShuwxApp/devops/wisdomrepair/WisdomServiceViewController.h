//
//  WisdomServiceViewController.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/4/15.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "MainViewController.h"
#import "WisdomServiceTableViewCell.h"
#import "WisdomServiceTableViewTwoCell.h"
#import "WisdomServiceTopView.h"
#import "AllWorkOrderViewController.h"
#import "ShowRepairViewController.h"
#import "WaitOrdersViewController.h"
#import "MyRepairViewController.h"
#import "MyOrdersViewController.h"
#import "MyReinforceViewController.h"
#import "MyCollaborationViewController.h"
#import "BusnessStatisViewController.h"

@interface WisdomServiceViewController : MainViewController{
      UINib *_personNib;
      UINib *_persontwoNib;
}
@property (nonatomic,strong) NSMutableDictionary *misseDataDictionary;
@end

