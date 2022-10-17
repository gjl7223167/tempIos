//
//  TreeTableViewThree.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/5/19.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThreeeDeptTableViewCell.h"
#import "ThreeeContentTableViewCell.h"
#import "ProBtn.h"
 #import "UIImageView+WebCache.h"
#import "Utils.h"

@class Node;

@protocol TreeTableCellThreeDelegate <NSObject>

-(void)cellClick : (Node *)node;

@end

@interface TreeTableViewThree : UITableView{
    UINib *_oneNib;
    UINib *_twoNib;
}

@property (nonatomic , weak) id<TreeTableCellThreeDelegate> treeTableCellDelegate;

-(instancetype)initWithFrame:(CGRect)frame withData : (NSArray *)data;

@property (nonatomic,weak) UIViewController * uiViewController;
@end

