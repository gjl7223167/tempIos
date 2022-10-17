//
//  BaoqgzDialogViewController.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/2/25.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "BaoqgzDialogViewController.h"

@interface BaoqgzDialogViewController ()

@end

@implementation BaoqgzDialogViewController


-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"EventDialogViewController"];
    [self getSelectEventSetPage];
     
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"EventDialogViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
      [self initView];
}

- (void)initView{
  
_personNib = [UINib nibWithNibName:@"BqgzDialogTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    
    [self.cancelBtn.layer setCornerRadius:5];
     self.cancelBtn.layer.masksToBounds = YES;
    
    [self.uitableView.layer setCornerRadius:5];
       self.uitableView.layer.masksToBounds = YES;
    
     [self.cancelBtn addTarget:self action:@selector(setCancelBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.uitableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
      [self dataSource];
    [self getSelectEventSetPage];
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
    
    if ([objectStr isKindOfClass:[NSDictionary class]]) {
         NSMutableDictionary * nsdicStr = [_dataSource objectAtIndex:indexPath.row];
        NSString * set_name = [nsdicStr objectForKey:@"set_name"];
                   cell.setName.text = set_name;
        cell.setName.textColor = [UIColor colorWithRed:0/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
    }else{
         NSString * nssStr = [_dataSource objectAtIndex:indexPath.row];
                   cell.setName.text = nssStr;
        cell.setName.textColor = [UIColor lightGrayColor];
    }
    
   // NSMutableDictionary * objectStr = [_dataSource objectAtIndex:indexPath.row];
          return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSMutableDictionary * objectStr = [_dataSource objectAtIndex:indexPath.row];
    NSString * nsString = @"";
    
    NSMutableDictionary * dicNary = [NSMutableDictionary dictionary];
     
    if ([objectStr isKindOfClass:[NSDictionary class]]) {
      
        
        __weak typeof(self) weakself = self;
          if (weakself.returnValueBlock) {
              //将自己的值传出去，完成传值
              weakself.returnValueBlock(objectStr);
          }
        
    }else{
//         NSString * nssStr = [_dataSource objectAtIndex:indexPath.row];
//        nsString = nssStr;
    }
  
       [[self presentingViewController] dismissModalViewControllerAnimated:YES];
         
}


-(void)getSelectEventSetPage{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * baseUrl = [defaults objectForKey:@"baseUrl"];
    
    NSMutableDictionary * dicnary = [self queryData];
    NSString *ptoken = [dicnary objectForKey:@"ptoken"];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:ptoken forKey:@"token"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
       int app_Version = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
       [diction setValue:@(app_Version) forKey:@"version_code"];
    [diction setValue:@"1" forKey:@"is_app"];
   
 
    NSString * url = [self getPinjieNSString:baseUrl :selectEventSetListIsSystem];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
         [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];

    [PPNetworkHelper setValue:ptoken forHTTPHeaderField:@"token"];
    [PPNetworkHelper POST:url parameters:diction success:^(id responseObject) {
        id myResult =  [ self getMyResult:responseObject];
        if ([myResult isKindOfClass:[NSArray class]]) {
            [self setSelectEventSetPage:myResult];
        }
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            
        }
        if ([myResult isKindOfClass:[NSString class]]) {
            [self showToastTwo:myResult];
        }
    
    } failure:^(NSError *error) {
        //请求失败
        NSString * errorStr =  [self getError:error];
        [self showToastTwo:errorStr];
       
    }];
}
-(void)setSelectEventSetPage:(NSMutableArray *) nsmutable{
    
    if ([nsmutable count] <= 0) {
        [self showToast:@"暂无标签故障"];
        dispatch_async(dispatch_get_main_queue(), ^{
           // UI更新代码
            [[self presentingViewController] dismissModalViewControllerAnimated:YES];
        });
        
        return;
    }
    
   [self.dataSource removeAllObjects];
     [_dataSource addObject:@"请选择"];
    for (int i = 0;i< [nsmutable count];i++) {
        NSMutableDictionary * diction = [nsmutable objectAtIndex:i];
        [_dataSource addObject:diction];
       
    }
 //     [_dataSource addObject:@"更多事件"];
     [self.uitableView reloadData];
}

@end
