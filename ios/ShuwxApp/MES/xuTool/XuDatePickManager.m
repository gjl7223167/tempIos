//
//  XuDatePickManager.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/1/4.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "XuDatePickManager.h"

@interface XuDatePickManager ()<PGDatePickerDelegate>

@end

@implementation XuDatePickManager

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isShadeBackground = true;
        PGDatePicker *datePicker = self.datePicker;
        datePicker.delegate = self;
        datePicker.datePickerType = PGDatePickerTypeSegment;
        datePicker.datePickerMode = PGDatePickerModeDateHourMinuteSecond;
        datePicker.language = @"zh-Hans";
    }
    return self;
}


#pragma mark PGDatePickerDelegate

- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
//    NSLog(@"dateComponents = %@", dateComponents);
  
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:dateComponents];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    NSLog(@"时间是  =====%@",dateStr);
    if (_DatePickerB) {
        _DatePickerB(dateStr);
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
