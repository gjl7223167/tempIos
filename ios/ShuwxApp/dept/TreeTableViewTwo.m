//
//  TreeTableViewTwo.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/5/7.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "TreeTableViewTwo.h"
#import "Node.h"

@interface TreeTableViewTwo ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong) NSArray *data;//传递过来已经组织好的数据（全量数据）
@property (nonatomic , strong) NSMutableArray *tempData;//用于存储数据源（部分数据）

@end

@implementation TreeTableViewTwo

-(instancetype)initWithFrame:(CGRect)frame withData : (NSArray *)data{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.data = data;
        self.tempData = [self createTempData:data];
        
        _oneNib = [UINib nibWithNibName:@"OneDeptTableViewCell" bundle:nil];
          _twoNib = [UINib nibWithNibName:@"TwoTableViewCell" bundle:nil];
        
        _emptyNib = [UINib nibWithNibName:@"EmptyViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
        _nodataNib = [UINib nibWithNibName:@"NoDateTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
        
        _hasMore = true;
            startRow = 1;
        
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.tempData.count && _hasMore)
    {
        return 2; // 增加一个加载更多
    }
    
    return 2;
}


#pragma mark - UITableViewDataSource
#pragma mark - Required
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    if (section == 0)
    {
        return self.tempData.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ( [self.tempData count] <= 0) {
        
        // 加载更多
        static NSString * noDataLoadMore = @"EmptyCall";
        
        EmptyViewCell *loadCell = [tableView dequeueReusableCellWithIdentifier:noDataLoadMore];
        if (!loadCell)
        {
            loadCell = [_emptyNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
        }
        loadCell.selectionStyle = UITableViewCellSelectionStyleNone;  //无法点击
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return loadCell;
    }
    if (indexPath.section == 0) {
        Node *node = [self.tempData objectAtIndex:indexPath.row];
       int typeInt = node.type;
       
       if (typeInt == 0) {
           static NSString *  OneDeptCellView = @"CellId";
                 //自定义cell类
                 OneDeptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OneDeptCellView];
                 if (!cell) {
                     cell = [_oneNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
                 }
           
           NSString * name = node.name;
           cell.strateName.text = name;
           
           cell.xkButton.indexPath = indexPath;
           
           [cell.xkButton addTarget:self action:@selector(setXkBtn:) forControlEvents:UIControlEventTouchUpInside];
           
   //        cell.xkButton
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
           return cell;
       }else{
           static NSString *  TwpDeptCellView = @"CellId";
                        //自定义cell类
                        TwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TwpDeptCellView];
                        if (!cell) {
                            cell = [_twoNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
                        }
           
           NSString * name = node.name;
           NSString * descrip = node.descrip;
           cell.strategyName.text = name;
           cell.strateDesci.text  = descrip;
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
           
           cell.twoButton.indexPath = indexPath;
                  
                  [cell.twoButton addTarget:self action:@selector(setXkBtn:) forControlEvents:UIControlEventTouchUpInside];
           
                  return cell;
    }
    }
    
    // 加载更多
    static NSString * noDataLoadMore = @"CellIdentifierLoadMore";
    
    NoDateTableViewCell *loadCell = [tableView dequeueReusableCellWithIdentifier:noDataLoadMore];
    if (!loadCell)
    {
        loadCell = [_nodataNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
    }
    if (!_hasMore) {
        loadCell.loadLabel.text = @"--没有更多数据了--";
    }else{
        loadCell.loadLabel.text = @"自动加载更多";
    }
    return loadCell;
    
}
-(void)setXkBtn:(ProBtn *)proBtn{
    NSIndexPath * indexPath = proBtn.indexPath;
     Node *node = [_tempData objectAtIndex:indexPath.row];
    
    [self.treeTableCellDelegate cellClick:node];
}

#pragma mark - Optional
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if ( [self.tempData count] <= 0) {
        return SCREEN_HEIGHT - NAV_HEIGHT;
    }
    if (indexPath.section == 0){
        Node *node = [self.tempData objectAtIndex:indexPath.row];
        int typeInt = node.type;
        
        if (typeInt == 0) {
            return 50;
        }
        return 80;
    }
    return 44;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark - UITableViewDelegate
#pragma mark - Optional
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_tempData.count <= 0) {
        return;
    }
    
    
    Node *parentNode = [_tempData objectAtIndex:indexPath.row];
    int typeInt = parentNode.type;
    
    if (_treeTableCellDelegate && [_treeTableCellDelegate respondsToSelector:@selector(cellClick:)]) {
           [_treeTableCellDelegate cellClick:parentNode];
       }
    
    if (typeInt == 1) {
        NSUInteger startPosition = indexPath.row+1;
        NSUInteger endPosition = startPosition;
        BOOL expand = NO;
        for (int i=0; i<_data.count; i++) {
            Node *node = [_data objectAtIndex:i];
            if (node.parentId == parentNode.nodeId) {
                node.expand = !node.expand;
                if (node.expand) {
                    [_tempData insertObject:node atIndex:endPosition];
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

        //插入或者删除相关节点
        if (expand) {
            [self insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [self deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
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
        Node *node = [_tempData objectAtIndex:i];
        endPosition++;
        if (node.depth <= parentNode.depth) {
            break;
        }
        if(endPosition == _tempData.count-1){
            endPosition++;
            node.expand = NO;
            break;
        }
        node.expand = NO;
    }
    if (endPosition>startPosition) {
        [_tempData removeObjectsInRange:NSMakeRange(startPosition+1, endPosition-startPosition-1)];
    }
    return endPosition;
}

@end

