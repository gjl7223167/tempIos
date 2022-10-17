//
//  LTSCalendarScrollView.m
//  LTSCalendar
//
//  Created by 李棠松 on 2018/1/13.
//  Copyright © 2018年 leetangsong. All rights reserved.
//

#import "LTSCalendarScrollView.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface LTSCalendarScrollView()<UITableViewDelegate,UITableViewDataSource>{
    UINib *_personNib;
            UINib * _emptyNib;
            UINib * _nodataNib;
            BOOL _hasMore;
        @public int startRow;
        @public int total;
}
@property (nonatomic,strong)UIView *line;
@property (nonatomic,strong)UIView *xunjSx;
@end
@implementation LTSCalendarScrollView

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)setBgColor:(UIColor *)bgColor{
    self.bgColor = bgColor;
    self.backgroundColor = bgColor;
    self.tableView.backgroundColor = bgColor;
    self.line.backgroundColor = bgColor;
}
-(void)setData:(NSMutableArray *)myDataSource{
    [self.dataSource removeAllObjects];
    for (NSMutableDictionary * nsmuTab in myDataSource) {
             [self.dataSource addObject:nsmuTab];
         }
    [self.tableView reloadData];
}

- (void)initUI{
    
    self.delegate = self;
    self.bounces = false;
    self.showsVerticalScrollIndicator = false;
    self.backgroundColor = [LTSCalendarAppearance share].scrollBgcolor;
    LTSCalendarContentView *calendarView = [[LTSCalendarContentView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [LTSCalendarAppearance share].weekDayHeight*[LTSCalendarAppearance share].weeksToDisplay)];
    calendarView.currentDate = [NSDate date];
     calendarView.eventSource = self.eventSource;
    [self addSubview:calendarView];
    self.calendarView = calendarView;
    self.line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(calendarView.frame), SCREEN_WIDTH,50)];
    self.xunjSx = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,49)];
    self.xunjSx.backgroundColor = [UIColor whiteColor];
     UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
      label.text = @"巡检事件筛选";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [self.xunjSx addSubview:label];
     [self.line addSubview:self.xunjSx];
    
    [self dataSource];
    
    _personNib = [UINib nibWithNibName:@"InspectionEventTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
         _emptyNib = [UINib nibWithNibName:@"EmptyViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
         _nodataNib = [UINib nibWithNibName:@"NoDateTableViewCell" bundle:nil]; //这句话就相当于把PersonCell.xib放到了内存里
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.line.frame), SCREEN_WIDTH, CGRectGetHeight(self.frame)-CGRectGetMaxY(self.line.frame))];
    self.tableView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:247/255.0 alpha:1.0];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.scrollEnabled = [LTSCalendarAppearance share].isShowSingleWeek;
    [self.tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self addSubview:self.tableView];
    self.line.backgroundColor = self.backgroundColor;
    [self addSubview:self.line];
    [LTSCalendarAppearance share].isShowSingleWeek ? [self scrollToSingleWeek]:[self scrollToAllWeek];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
      if (section == 0)
     {
         return self.dataSource.count;
     }
     return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
      if ( [self.dataSource count] <= 0) {
             return CGRectGetHeight(self.frame)-CGRectGetMaxY(self.line.frame);
         }
         if (indexPath.section == 0){
             return 150;
         }
         return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ( [self.dataSource count] <= 0) {
           
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
              static NSString *  EventTableCellView = @"CellId";
                      //自定义cell类
                      InspectionEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EventTableCellView];
                      if (!cell) {
                          cell = [_personNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
                      }
               
               NSDictionary * dicOne  =   [self.dataSource objectAtIndex:indexPath.row];
                     NSString * set_name = [dicOne objectForKey:@"set_name"];
                  NSString * line_name = [dicOne objectForKey:@"line_name"];
                  NSString * point_name = [dicOne objectForKey:@"point_name"];
                 NSString * user_name = [dicOne objectForKey:@"user_name"];
                NSString * create_time = [dicOne objectForKey:@"create_time"];
           
               cell.taskName.text = set_name;
               cell.taskTime.text = line_name;
                cell.taskDescre.text = point_name;
           [cell.orderCode setTitle:[self getDeviceDate:create_time] forState:UIControlStateNormal];
           
           NSString * userName = @"";
         userName =  [self getPinjieNSString:userName:@"执行人："];
            userName =  [self getPinjieNSString:userName:user_name];
               
            [cell.wuxXj setTitle:userName forState:UIControlStateNormal];
          
                      cell.selectionStyle = UITableViewCellSelectionStyleNone;  //无法点击
                      [tableView deselectRowAtIndexPath:indexPath animated:YES];
               
               return cell;
       }
    
    // 加载更多
       static NSString * noDataLoadMore = @"CellIdentifierLoadMore";
       
       NoDateTableViewCell *loadCell = [tableView dequeueReusableCellWithIdentifier:noDataLoadMore];
       if (!loadCell)
       {
           loadCell = [_nodataNib instantiateWithOwner:nil options:nil][0];//最初屏幕显示的cell都没有重用，都是要创建的，但是此时创建的过程都是走的内存缓存，大大提高了效率
       }
       if (!_hasMore) {
           if ( [_dataSource count] > 5) {
                 loadCell.loadLabel.text = @"--没有更多数据了--";
           }else{
                 loadCell.loadLabel.text = @"";
           }
         
       }else{
           loadCell.loadLabel.text = @"自动加载更多";
       }
       return loadCell;
    
}

-(NSString *)getDeviceDate:(NSString *)dateString{
    NSString * getMyDate = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nsDate = [formatter dateFromString:dateString];
    
    // 1.创建一个时间格式化对象
    NSDateFormatter *formatterOne = [[NSDateFormatter alloc] init];
    // 2.设置时间格式化对象的样式
    formatterOne.dateFormat = @"yyyy-MM-dd HH:mm";
    // 3.利用时间格式化对象对时间进行格式化
    NSString *str = [formatterOne stringFromDate:nsDate];
    NSLog(@"%@",str);
    
    return str;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
       
       int myInt =  indexPath.section;
       if (myInt != 0) {
           return;
       }
       
       if ([self.dataSource count] <= 0) {
           return;
       }
       
       NSDictionary * dicOne  =   [self.dataSource objectAtIndex:indexPath.row];
    
    __weak typeof(self) weakself = self;
     if (weakself.returnValueBlock) {
         weakself.returnValueBlock(dicOne);
     }
    
}

//判断不为空  不包括空字符串
- (BOOL) isBlankStringTwo:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    return NO;
}

//拼接字符串
-(NSString *) getPinjieNSString:(NSString *) fromStr:(NSString *) toStr{
    if ([self isBlankStringTwo:fromStr]){
        fromStr = @"";
    }
    if ([self isBlankStringTwo:toStr]){
        toStr = @"";
    }
    NSString * pinjieStr = @"";
    pinjieStr = [fromStr stringByAppendingString:toStr];
    return pinjieStr;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   
    CGFloat offsetY = scrollView.contentOffset.y;
    
    
    if (scrollView != self) {
        return;
    }
  
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    ///日历需要滑动的距离
    CGFloat calendarCountDistance = self.calendarView.singleWeekOffsetY;
    
    CGFloat scale = calendarCountDistance/tableCountDistance;
    
    CGRect calendarFrame = self.calendarView.frame;
    self.calendarView.maskView.alpha = offsetY/tableCountDistance;
    self.calendarView.maskView.hidden = false;
    calendarFrame.origin.y = offsetY-offsetY*scale;
    if(ABS(offsetY) >= tableCountDistance) {
         self.tableView.scrollEnabled = true;
        self.calendarView.maskView.hidden = true;
        //为了使滑动更加顺滑，这部操作根据 手指的操作去设置
//         [self.calendarView setSingleWeek:true];
        
    }else{
        
        self.tableView.scrollEnabled = false;
        if ([LTSCalendarAppearance share].isShowSingleWeek) {
           
            [self.calendarView setSingleWeek:false];
        }
    }
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = CGRectGetHeight(self.frame)-CGRectGetHeight(self.calendarView.frame)-CGRectGetHeight(self.line.frame)+offsetY;
    self.tableView.frame = tableFrame;
    self.bounces = false;
    if (offsetY<=0) {
        self.bounces = true;
        calendarFrame.origin.y = offsetY;
        tableFrame.size.height = CGRectGetHeight(self.frame)-CGRectGetHeight(self.calendarView.frame)-CGRectGetHeight(self.line.frame);
        self.tableView.frame = tableFrame;
    }
    self.calendarView.frame = calendarFrame;
    
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    if ( appearce.isShowSingleWeek) {
        if (self.contentOffset.y != tableCountDistance) {
            return  nil;
        }
    }
    if ( !appearce.isShowSingleWeek) {
        if (self.contentOffset.y != 0 ) {
            return  nil;
        }
    }

    return  [super hitTest:point withEvent:event];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);

    if (scrollView.contentOffset.y>=tableCountDistance) {
        [self.calendarView setSingleWeek:true];
    }
    
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (self != scrollView) {
        return;
    }
   
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    //point.y<0向上
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:scrollView];
    
    if (point.y<=0) {
       
        [self scrollToSingleWeek];
    }
    
    if (scrollView.contentOffset.y<tableCountDistance-20&&point.y>0) {
        [self scrollToAllWeek];
    }
}
//手指触摸完
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (self != scrollView) {
        return;
    }
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    //point.y<0向上
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:scrollView];
    
    
    if (point.y<=0) {
        if (scrollView.contentOffset.y>=20) {
            if (scrollView.contentOffset.y>=tableCountDistance) {
                [self.calendarView setSingleWeek:true];
            }
            [self scrollToSingleWeek];
        }else{
            [self scrollToAllWeek];
        }
    }else{
        if (scrollView.contentOffset.y<tableCountDistance-20) {
            [self scrollToAllWeek];
        }else{
            [self scrollToSingleWeek];
        }
    }
  
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
     [self.calendarView setUpVisualRegion];
}


- (void)scrollToSingleWeek{
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    [self setContentOffset:CGPointMake(0, tableCountDistance) animated:true];
    
    
}

- (void)scrollToAllWeek{
    [self setContentOffset:CGPointMake(0, 0) animated:true];
}


- (void)layoutSubviews{
    [super layoutSubviews];

    self.contentSize = CGSizeMake(0, CGRectGetHeight(self.frame)+[LTSCalendarAppearance share].weekDayHeight*([LTSCalendarAppearance share].weeksToDisplay-1));
}

@end
