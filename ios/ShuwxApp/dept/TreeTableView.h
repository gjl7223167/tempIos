//
//  TreeTableView.h
//  TreeTableView
//

#import <UIKit/UIKit.h>
#import "ThreeeDeptTableViewCell.h"

@class Node;

@protocol TreeTableCellDelegate <NSObject>

-(void)cellClick : (Node *)node;

@end

@interface TreeTableView : UITableView{
    UINib *_oneNib;
}

@property (nonatomic , weak) id<TreeTableCellDelegate> treeTableCellDelegate;

-(instancetype)initWithFrame:(CGRect)frame withData : (NSArray *)data;

@end
