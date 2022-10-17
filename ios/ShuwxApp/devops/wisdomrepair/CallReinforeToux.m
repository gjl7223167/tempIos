//
//  CallReinforeToux.m
//  ShuwxApp
//
//  Created by 袁小强 on 2020/6/22.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "CallReinforeToux.h"

@implementation CallReinforeToux


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CallReinforeToux *aaView = [[[NSBundle mainBundle] loadNibNamed:@"CallReinforeToux" owner:self options:nil] lastObject];
        self.callToux = aaView.callToux;
        self.touxBtn = aaView.touxBtn;
       
        [self addSubview:aaView];
        [self initView];
    }
    return self;
}
-(void)initView{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.pictureUrl = [defaults objectForKey:@"pictureUrl"];
    self.defaultImage = @"tempimage";
    
        [self.touxBtn addTarget:self action:@selector(setUpdateDataList:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setUpdateView:(NSString * )imageUrlStr{

    [self.callToux sd_setImageWithURL:imageUrlStr placeholderImage:[UIImage imageNamed:self.defaultImage]];
}
-(void)setUpdateDataList:(ProBtn *) mybtn{
    CallReinforceViewController * curCallReinfore = (CallReinforceViewController *) self.callReinfore;
    [curCallReinfore setUpdateDataList:mybtn];
}

@end
