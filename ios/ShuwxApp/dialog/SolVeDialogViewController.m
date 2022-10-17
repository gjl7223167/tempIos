//
//  SolVeDialogViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/5/21.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "SolVeDialogViewController.h"

@interface SolVeDialogViewController ()

@end

@implementation SolVeDialogViewController


-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"SolVeDialogViewController"];
     
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"SolVeDialogViewController"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
      [self initView];
}


- (void)initView{
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
_personNib = [UINib nibWithNibName:@"BqgzDialogTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    
    [self.cancelBtn.layer setCornerRadius:5];
     self.cancelBtn.layer.masksToBounds = YES;
    
    [self.uitableView.layer setCornerRadius:5];
       self.uitableView.layer.masksToBounds = YES;
    
     [self.cancelBtn addTarget:self action:@selector(setCancelBtn) forControlEvents:(UIControlEventTouchUpInside)];
 [self.uitableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
      [self dataSource];
   
    [self.dataSource removeAllObjects];
        [_dataSource addObject:@"请选择"];
        [_dataSource addObject:@"已解决"];
       [_dataSource addObject:@"未解决"];
        [self.uitableView reloadData];
}
-(void)setCancelBtn{
    if ([self respondsToSelector:@selector(presentingViewController)]) {
           [[self presentingViewController] dismissModalViewControllerAnimated:YES];
       }
       else
       {
           [[self parentViewController] dismissModalViewControllerAnimated:YES];
       }
}

- (UITableView *)tabelview {
    
    return _uitableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *  DialogDetailsTableCellView = @"CellId";
          //自定义cell类
          BqgzDialogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DialogDetailsTableCellView];
          if (!cell) {
              cell = [_personNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
          }
    
    NSObject * objectStr = [_dataSource objectAtIndex:indexPath.row];
    
    NSString * nssStr = [_dataSource objectAtIndex:indexPath.row];
    if ([self getNSStringEqual:nssStr:@"请选择"]) {
        cell.setName.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    }
                      cell.setName.text = nssStr;
    
   // NSMutableDictionary * objectStr = [_dataSource objectAtIndex:indexPath.row];
          return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSObject * objectStr = [_dataSource objectAtIndex:indexPath.row];
    NSString * nsString = @"";
     
      NSString * nssStr = [_dataSource objectAtIndex:indexPath.row];
           nsString = nssStr;
    
    if ([self getNSStringEqual:@"请选择":nsString]) {
        return;
    }
  
    __weak typeof(self) weakself = self;
      if (weakself.returnValueBlock) {
          //将自己的值传出去，完成传值
          weakself.returnValueBlock(nsString);
      }
       [[self presentingViewController] dismissModalViewControllerAnimated:YES];
         
}


@end

