//
//  TreeTableViewThree.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/5/19.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "TreeTableViewThree.h"
#import "Node.h"

@interface TreeTableViewThree ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong) NSArray *data;//传递过来已经组织好的数据（全量数据）
@property (nonatomic , strong) NSMutableArray *tempData;//用于存储数据源（部分数据）

@end

@implementation TreeTableViewThree

-(instancetype)initWithFrame:(CGRect)frame withData : (NSArray *)data{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.data = data;
        self.tempData = [self createTempData:data];
        
        _oneNib = [UINib nibWithNibName:@"ThreeeDeptTableViewCell" bundle:nil];
          _twoNib = [UINib nibWithNibName:@"ThreeeContentTableViewCell" bundle:nil];
        
        [self  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return self;
}

/**
 * 初始化数据源
 */
-(NSMutableArray *)createTempData : (NSArray *)data{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i=0; i<data.count; i++) {
        Node *node = [_data objectAtIndex:i];
        if (node.expand) {
            [tempArray addObject:node];
        }
    }
    return tempArray;
}

#pragma mark - UITableViewDataSource
#pragma mark - Required
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tempData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
     Node *node = [self.tempData objectAtIndex:indexPath.row];
    int typeInt = node.type;
    
    if (typeInt == 1) {
        static NSString *  ThreeDeptCellView = @"CellId";
              //自定义cell类
              ThreeeDeptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ThreeDeptCellView];
              if (!cell) {
                  cell = [_oneNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
              }
        
        NSString * name = node.name;
        cell.deptName.text = name;
        
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *  ThreeConCellView = @"CellId";
                     //自定义cell类
                     ThreeeContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ThreeConCellView];
                     if (!cell) {
                         cell = [_twoNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
                     }
        
        NSString * name = node.name;
        NSString * depart_name = node.depart_name;
        NSString * imageUrlStr = node.head_img;
        
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             NSString * pictureUrl = [defaults objectForKey:@"pictureUrl"];
        
        NSString * curImageUrl = [Utils getPinjieNSString:pictureUrl:imageUrlStr];
        
          NSString  * defaultImage = @"tempimage";
          [cell.touxPic sd_setImageWithURL:[NSURL URLWithString:curImageUrl] placeholderImage:[UIImage imageNamed:defaultImage]];
        
        cell.touxPic.layer.masksToBounds=YES;
        cell.touxPic.layer.cornerRadius=50/2.0;

        cell.userName.text = name;
        cell.deptName.text = depart_name;
        
               return cell;
    }
    
}
-(void)setXkBtn:(ProBtn *)proBtn{
    NSIndexPath * indexPath = proBtn.indexPath;
     Node *node = [self.tempData objectAtIndex:indexPath.row];
    
    [self.treeTableCellDelegate cellClick:node];
}

#pragma mark - Optional
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   Node *node = [self.tempData objectAtIndex:indexPath.row];
    int typeInt = node.type;
    
    if (typeInt == 1) {
        return 50;
    }
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark - UITableViewDelegate
#pragma mark - Optional
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //先修改数据源
    Node *parentNode = [self.tempData objectAtIndex:indexPath.row];
    int typeInt = parentNode.type;
   
    if (self.treeTableCellDelegate && [self.treeTableCellDelegate respondsToSelector:@selector(cellClick:)]) {
        [self.treeTableCellDelegate cellClick:parentNode];
    }
   
    if(typeInt == 1){
        NSUInteger startPosition = indexPath.row+1;
        NSUInteger endPosition = startPosition;
        BOOL expand = NO;
        for (int i=0; i<_data.count; i++) {
            Node *node = [_data objectAtIndex:i];
            if (node.parentId == parentNode.nodeId) {
                node.expand = !node.expand;
                if (node.expand) {
                    [self.tempData insertObject:node atIndex:endPosition];
                    expand = YES;
                    endPosition++;
                }else{
                    expand = NO;
                    endPosition = [self removeAllNodesAtParentNode:parentNode];
                    break;
                }
            }
        }

        //获得需要修正的indexPath
        NSMutableArray *indexPathArray = [NSMutableArray array];
        for (NSUInteger i=startPosition; i<endPosition; i++) {
            NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [indexPathArray addObject:tempIndexPath];
        }
        ThreeeDeptTableViewCell *cell = (ThreeeDeptTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        //插入或者删除相关节点
        if (expand) {
            [self insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            cell.xianDown.image = [UIImage imageNamed:@"xiajiantup"];
        }else{
            [self deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            cell.xianDown.image = [UIImage imageNamed:@"xiajiant"];
        }
    }
   
}

/**
 *  删除该父节点下的所有子节点（包括孙子节点）
 *  @param parentNode 父节点
 *  @return 该父节点下一个相邻的统一级别的节点的位置
 */
-(NSUInteger)removeAllNodesAtParentNode : (Node *)parentNode {
    NSUInteger startPosition = [_tempData indexOfObject:parentNode];
    NSUInteger endPosition = startPosition;
    for (NSUInteger i=startPosition+1; i<_tempData.count; i++) {
        Node *node = [self.tempData objectAtIndex:i];
        endPosition++;
        if (node.depth <= parentNode.depth) {
            break;
        }
        if(endPosition == self.tempData.count-1){
            endPosition++;
            node.expand = NO;
            break;
        }
        node.expand = NO;
    }
    if (endPosition>startPosition) {
        [self.tempData removeObjectsInRange:NSMakeRange(startPosition+1, endPosition-startPosition-1)];
    }
    return endPosition;
}

@end

