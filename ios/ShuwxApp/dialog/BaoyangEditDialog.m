//
//  BaoyangEditDialog.m
//  ShuwxApp
//
//  Created by 袁小强 on 2019/9/9.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "BaoyangEditDialog.h"

@interface BaoyangEditDialog ()

@end

@implementation BaoyangEditDialog

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.viewBg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    //设置圆角半径值
    self.xiakView.layer.cornerRadius  = 10.f;
    //设置为遮罩，除非view有阴影，否则都要指定为YES的
    self.xiakView.layer.masksToBounds = YES;
    
      NSRange stringRange = NSMakeRange(0, 1); //该字符串的位置
    
    NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:_workTime.text];
  [noteString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:stringRange];
    [_workTime setAttributedText: noteString];
    
    
    NSMutableAttributedString *noteString2 = [[NSMutableAttributedString alloc] initWithString:_nextDate.text];
    [noteString2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:stringRange];
    [_nextDate setAttributedText: noteString2];
    
    NSMutableAttributedString *noteString3 = [[NSMutableAttributedString alloc] initWithString:_runWorkTime.text];
    [noteString3 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:stringRange];
    [_runWorkTime setAttributedText: noteString3];
    
    _baoyTimeValue.tag = 1001;
    _nextDateValue.tag = 1002;
    _baoyTimeValue.delegate = self;
    _workTimesValue.delegate = self;
    _nextDateValue.delegate = self;
     _runWrokTimeValue.delegate = self;
    
    _careContent.placeholder = @"请输入保养内容";
    _careContent.canPerformAction = NO;
    
    _careRemark.placeholder = @"请输入备注";
    _careRemark.canPerformAction = NO;
    
       _baoyTimeValue.backgroundColor = [UIColor whiteColor];
       _workTimesValue.backgroundColor = [UIColor whiteColor];
      _nextDateValue.backgroundColor = [UIColor whiteColor];
      _runWrokTimeValue.backgroundColor = [UIColor whiteColor];
     _careContent.backgroundColor = [UIColor whiteColor];
     _careRemark.backgroundColor = [UIColor whiteColor];
    
    self.xiakView.userInteractionEnabled=YES;
    
    self.myscrollview.keyboardDismissMode =UIScrollViewKeyboardDismissModeOnDrag;
    _runWrokTimeValue.keyboardType = UIKeyboardTypeNumberPad;
     _workTimesValue.keyboardType = UIKeyboardTypeNumberPad;
    
      [_okBtn addTarget:self action:@selector(setOkBtn) forControlEvents:UIControlEventTouchUpInside];
     [_cancelBtn addTarget:self action:@selector(setCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
     NSString *care_time = [_nsmuCare objectForKey:@"care_time"];
    _baoyTimeValue.text = care_time;
    
    NSString *run_total_time = [self getIntegerValue:[_nsmuCare objectForKey:@"run_total_time"]];
    _workTimesValue.text = run_total_time;
    
     NSString *content = [_nsmuCare objectForKey:@"content"];
    _careContent.text = content;
    
    NSString *remarks = [_nsmuCare objectForKey:@"remarks"];
    _careRemark.text = remarks;
    
    NSString *next_care_time = [_nsmuCare objectForKey:@"next_care_time"];
    _nextDateValue.text = next_care_time;
    
     NSString *plan_run_time = [self getIntegerValue:[_nsmuCare objectForKey:@"plan_run_time"]];
    _runWrokTimeValue.text = plan_run_time;
    
    
    
    UITapGestureRecognizer *ggggg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGesture2)];
    [self.xiakView addGestureRecognizer:ggggg];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGesture1)];
    
    [self.view addGestureRecognizer:gesture];
}
-(void)setOkBtn{
   NSString * baoyTime =    _baoyTimeValue.text;
    if ([self isBlankString:baoyTime]) {
        [self showToast:@"保养时间不能为空"];
        return;
    }
    NSString * workTime =    _workTimesValue.text;
    if ([self isBlankString:workTime]) {
        [self showToast:@"工作时长不能为空"];
        return;
    }
    
     NSString * careContent =   _careContent.text;
      NSString * careRemarks =   _careRemark.text;
    
    NSString * careTimeNext =    _nextDateValue.text;
    if ([self isBlankString:careTimeNext]) {
        [self showToast:@"下次保养时间不能为空"];
        return;
    }
    NSString * runWorkTime =    _runWrokTimeValue.text;
    if ([self isBlankString:runWorkTime]) {
        [self showToast:@"工作时长不能为空"];
        return;
    }
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
    [diction setValue:baoyTime forKey:@"baoyTime"];
      [diction setValue:workTime forKey:@"workTime"];
      [diction setValue:careContent forKey:@"careContent"];
      [diction setValue:careRemarks forKey:@"careRemarks"];
      [diction setValue:careTimeNext forKey:@"careTimeNext"];
      [diction setValue:runWorkTime forKey:@"runWorkTime"];
    
    __weak typeof(self) weakself = self;
    if (weakself.returnValueBlock) {
        //将自己的值传出去，完成传值
        weakself.returnValueBlock(diction);
    }
    
    
    [self tagGesture1];
}
-(void)setCancelBtn{
     [self tagGesture1];
}

//  获取当前日期
-(NSString *)getCurrentTimes{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 1001) {
        [self setMyDate];
        return NO;
        
    }
    if (textField.tag == 1002) {
        [self setMyDateTwo];
        return NO;
        
    }
    return YES;
}
-(void)setMyDate{
    
    MOFSDatePicker *p = [MOFSDatePicker new];
    [p showWithSelectedDate:nil commit:^(NSDate * _Nullable date) {
//        NSLog(@"%@", [date stringFromDate:date]);
        
        NSDateFormatter *df = [NSDateFormatter new];
        df.dateFormat = @"yyyy-MM-dd";
        NSString * careTime = [df stringFromDate:date];
        
        _baoyTimeValue.text = careTime;
        
    } cancel:^{

    }];
    

}
-(void)setMyDateTwo{
    
    MOFSDatePicker *p = [MOFSDatePicker new];
    [p showWithSelectedDate:nil commit:^(NSDate * _Nullable date) {
//        NSLog(@"%@", [date stringFromDate:date]);
        
        NSDateFormatter *df = [NSDateFormatter new];
        df.dateFormat = @"yyyy-MM-dd";
        NSLog(@"%@", [df stringFromDate:date]);
         NSString * careTimeNext = [df stringFromDate:date];
        _nextDateValue.text = careTimeNext;
        
    } cancel:^{

    }];
    
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

-(void)tagGesture1 {
    [self.view endEditing:YES];
    if ([self respondsToSelector:@selector(presentingViewController)]) {
        [[self presentingViewController] dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [[self parentViewController] dismissModalViewControllerAnimated:YES];
    }
    
}
-(void)tagGesture2 {
    
}

@end
