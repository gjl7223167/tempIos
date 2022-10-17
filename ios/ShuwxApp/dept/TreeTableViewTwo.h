//
//  TreeTableViewTwo.h
//  ShuwxApp
//
//  Created by 袁小强 on 2020/5/7.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneDeptTableViewCell.h"
#import "TwoTableViewCell.h"
#import "ProBtn.h"
#import "FreeControlViewController.h"
#import "EmptyViewCell.h"
#import "NoDateTableViewCell.h"

@class Node;

@protocol TreeTableCellTwoDelegate <NSObject>

-(void)cellClick : (Node *)node;

@end

@interface TreeTableViewTwo : UITableView{
     UINib *_oneNib;
    UINib *_twoNib;
    UINib * _emptyNib;
    UINib * _nodataNib;
    BOOL _hasMore;
@public int startRow;
@public int total;
}

@property (nonatomic , weak) id<TreeTableCellTwoDelegate> treeTableCellDelegate;

-(instancetype)initWithFrame:(CGRect)frame withData : (NSArray *)data;

@end


