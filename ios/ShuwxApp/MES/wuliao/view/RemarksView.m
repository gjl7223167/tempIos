//
//  RemarksView.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2021/1/29.
//  Copyright © 2021 tiantuosifang. All rights reserved.
//

#import "RemarksView.h"
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

@implementation RemarksView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *mark = [UILabel new];
        mark.textColor = RGBA(51, 51, 51, 1);
        mark.font = [UIFont systemFontOfSize:14];
        mark.text = @"备注";
        mark.frame = CGRectMake(16, 10, 34, 20);
        [self addSubview:mark];
        
        UITextView *textView = [[UITextView alloc] init];
        textView.frame = CGRectMake(50, 5, frame.size.width - 50 - 16, frame.size.height - 20);
        textView.font = [UIFont systemFontOfSize:17];
        textView.placeholder = @"请输入您要备注的信息";
        textView.limitLength = @100;
        textView.placeholdColor = RGBA(153, 153, 153, 1);
        textView.limitPlaceColor = RGBA(102, 102, 102, 1);
        textView.placeholdFont = [UIFont systemFontOfSize:12];
        textView.limitPlaceFont = [UIFont systemFontOfSize:12];
        textView.font = [UIFont systemFontOfSize:12];
        //    textView.autoHeight = @1;
//        textView.limitLines = @2;//行数限制优先级低于字数限制
        [self addSubview:textView];
        self.contentTV = textView;
        self.contentTV.delegate = self;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    
        UILabel *mark = [UILabel new];
        mark.textColor = RGBA(51, 51, 51, 1);
        mark.font = [UIFont systemFontOfSize:14];
        mark.text = @"备注";
        mark.frame = CGRectMake(0, 10, 34, 20);
        [self addSubview:mark];
        
        UITextView *textView = [[UITextView alloc] init];
        textView.frame = CGRectMake(50, 5, SCREEN_WIDTH - 32 - 50 - 16, self.frame.size.height - 20);
        
        textView.font = [UIFont systemFontOfSize:17];
        textView.placeholder = @"请输入您要备注的信息";
        textView.limitLength = @100;
        textView.placeholdColor = RGBA(153, 153, 153, 1);
        textView.limitPlaceColor = RGBA(102, 102, 102, 1);
        textView.placeholdFont = [UIFont systemFontOfSize:12];
        textView.limitPlaceFont = [UIFont systemFontOfSize:12];
        textView.font = [UIFont systemFontOfSize:12];
        //    textView.autoHeight = @1;
//        textView.limitLines = @2;//行数限制优先级低于字数限制
        [self addSubview:textView];
        self.contentTV = textView;
        self.contentTV.delegate = self;

    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
