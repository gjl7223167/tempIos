//
//  BottomListShowView.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/2/23.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "BottomListShowView.h"

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@implementation BottomListShowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initOtherViews];
    }
    return self;
}

-(void)initOtherViews
{
    self.backgroundColor = [UIColor clearColor];
    self.dataArr = [NSArray array];
    
    UIView *coverV = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    coverV.backgroundColor = RGBA(120, 120, 122, 0.8);
    [self addSubview:coverV];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewClick)];
    [coverV addGestureRecognizer:tap];
    
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 384, self.frame.size.width, 384)];
    bottomV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:bottomV];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    cancelBtn.frame = CGRectMake(0, 384 - 57 - 34, self.frame.size.width, 57);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(coverViewClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomV addSubview:cancelBtn];
    
    [bottomV addSubview:self.myTableView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bottomV.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = bottomV.bounds;
    maskLayer.path = maskPath.CGPath;
    
    bottomV.layer.mask = maskLayer;
    
}



- (BaseTableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 228+57) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        
        _myTableView.backgroundColor = [UIColor whiteColor];
        _myTableView.alwaysBounceVertical = YES;
//        _myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
    }
    return _myTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *iden = @"iden";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    NSDictionary *dic = self.dataArr[indexPath.row];
    NSString *textS = @"";
    if (self.showFrom == bottomApplyOutStoreInfo) {
        textS = dic[@"positionName"];
    }else if (self.showFrom == bottomInOutCreateStore||self.showFrom == bottomAddUnqualityRecord){
        textS = dic[@"dic_name"];
    }else if (self.showFrom == bottomAddDefectInfo){
        textS = dic[@"name"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",textS];

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 57.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataArr[indexPath.row];
    
    if (self.StoreLocationBack) {
        self.StoreLocationBack(dic);
    }
    
    [self coverViewClick];
}


-(void)coverViewClick
{
    self.hidden = YES;
    [self removeFromSuperview];
}

- (void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    [self.myTableView reloadData];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
