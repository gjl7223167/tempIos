//
//  LTSCalendarScrollView.h
//  LTSCalendar
//
//  Created by 李棠松 on 2018/1/13.
//  Copyright © 2018年 leetangsong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSCalendarContentView.h"
#import "LTSCalendarWeekDayView.h"
#import "InspectionEventTableViewCell.h"
#import "NoDateTableViewCell.h"
#import "EmptyViewCell.h"

typedef void (^ReturnValueBlockCalendar) (NSDictionary *strValue);

@interface LTSCalendarScrollView : UIScrollView
//事件代理
@property (weak, nonatomic) id<LTSCalendarEventSource> eventSource;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)LTSCalendarContentView *calendarView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong)UIColor *bgColor;
-(void)setData:(NSMutableArray *)dataSource;
- (void)scrollToSingleWeek;

- (void)scrollToAllWeek;

@property(nonatomic, copy) ReturnValueBlockCalendar returnValueBlock;

@end
