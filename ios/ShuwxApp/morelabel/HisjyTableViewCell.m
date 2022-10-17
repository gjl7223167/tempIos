//
//  HisjyTableViewCell.m
//  ShuwxApp
//
//  Created by 袁小强 on 2019/10/10.
//  Copyright © 2019 tiantuosifang. All rights reserved.
//

#import "HisjyTableViewCell.h"
#import "XLHLookMoreLabel.h"
#import "XLHModel.h"

@interface HisjyTableViewCell ()<XLHAttributedLabelDelegate>

@end

@implementation HisjyTableViewCell

#pragma mark - ======== life cycle ========

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.careTime];
        [self.contentView addSubview:self.carePerson];
         [self.contentView addSubview:self.label];
        [self.contentView addSubview:self.setRunTimes];
        [self.contentView addSubview:self.setRemarks];
        
    }
    return self;
}

#pragma mark - ======== XLHAttributedLabelDelegate ========

- (void)displayView:(XLHLookMoreLabel *)label openHeight:(CGFloat)height {
    if ([self.delegate respondsToSelector:@selector(tableViewCell:model:numberOfLines:)]) {
        [self.delegate tableViewCell:self model:_model numberOfLines:0];
        //       int myHeight = height - 55;
        //          _remakes.transform = CGAffineTransformTranslate(_remakes.transform, 0, myHeight);
    }
}

- (void)displayview:(XLHLookMoreLabel *)label closeHeight:(CGFloat)height {
    if ([self.delegate respondsToSelector:@selector(tableViewCell:model:numberOfLines:)]) {
        [self.delegate tableViewCell:self model:_model numberOfLines:1];
        //        int myHeight = height - 55;
        //         _remakes.transform = CGAffineTransformTranslate(_remakes.transform, 0,  - myHeight);
    }
}

#pragma mark - ======== getter ========
- (XLHLookMoreLabel *)label {
    if (!_label) {
        _label = [[XLHLookMoreLabel alloc]init];
        _label.delegate = self;
        _label.textColor = [UIColor blackColor];
        _label.backgroundColor = [UIColor clearColor];
        [_label setOpenString:@"【报警条件】" andCloseString:@"【收起】" andFont:[UIFont systemFontOfSize:14] andTextColor:[UIColor blueColor]];
    }
    return _label;
}

//拼接字符串
-(NSString *) getPinjieNSString:(NSString *) fromStr:(NSString *) toStr{
    if (nil == fromStr) {
        fromStr = @"";
    }
    if (nil == toStr) {
        toStr = @"";
    }
    NSString * pinjieStr = @"";
    pinjieStr = [fromStr stringByAppendingString:toStr];
    return pinjieStr;
}

-(void)setValues:(XLHModel *)model{
    _bjTime.text = [self getPinjieNSString:@"报警时间：":model.careTime];
    _chulPerson.text = [self getPinjieNSString:@"处理人：":model.carePerson];
    _bjReason.text = [self getPinjieNSString:@"报警原因：":model.careWorkTimes];
    _bjMethod.text = [self getPinjieNSString:@"处理方法：":model.careRemares];
}

#pragma mark - ======== getter ========
- (UILabel *)careTime {
    if (!_bjTime) {
        _bjTime  = [[UILabel alloc] initWithFrame:CGRectMake(10, 10,250 , 25)];
        _bjTime.text = @"报警时间：";
        _bjTime.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
        _bjTime.textColor = [UIColor blackColor];
        _bjTime.backgroundColor = [UIColor clearColor];
        
    }
    return _bjTime;
}
- (UILabel *)carePerson {
    if (!_chulPerson) {
        _chulPerson  = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 210, 10,SCREEN_WIDTH - 210 , 25)];
        _chulPerson.text = @"处理人：";
        _chulPerson.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
        _chulPerson.textColor = [UIColor blackColor];
        _chulPerson.backgroundColor = [UIColor clearColor];
        
    }
    return _chulPerson;
}
- (UILabel *)setRunTimes {
    if (!_bjReason) {
        _bjReason  = [[UILabel alloc] initWithFrame:CGRectMake(10, 70,SCREEN_WIDTH - 10 , 25)];
        _bjReason.text = @"报警原因：";
        _bjReason.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
        _bjReason.textColor = [UIColor blackColor];
        _bjReason.backgroundColor = [UIColor clearColor];
        
    }
    return _bjReason;
}

#pragma mark - ======== setter ========
- (void)setModel:(XLHModel *)model {
    _model = model;
    [_label setText:model.title];
//    _label.state = model.state;
//    _label.numberOfLines = model.numberOfLines;
    CGSize size = [_label sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * 15, MAXFLOAT)];
    _label.frame = CGRectMake(10, 40, size.width, size.height);
    
//    [self setRemarks:size];
}

- (UILabel *)setRemarks {
    if (!_bjMethod) {
        _bjMethod  = [[UILabel alloc] initWithFrame:CGRectMake(10, 100,SCREEN_WIDTH - 10 , 25)];
        _bjMethod.text = @"处理方法：";
        _bjMethod.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
        _bjMethod.textColor = [UIColor blackColor];
        _bjMethod.backgroundColor = [UIColor clearColor];
        
        //        [self setMyViews:mySize];
    }
    return _bjMethod;
}

- (void)setRemarks:(CGSize)mySize {
       _bjReason.frame = CGRectMake(10, mySize.height + 40,SCREEN_WIDTH - 10 , 25);
    _bjMethod.frame = CGRectMake(10, mySize.height + 60,SCREEN_WIDTH - 10 , 25);
    
}


- (UILabel *)setMyViews:(CGSize)mySize {
    if (!_myView) {
        _myView  = [[UILabel alloc] initWithFrame:CGRectMake(0, mySize.height + 70,SCREEN_WIDTH , 1)];
        _myView.backgroundColor = [UIColor blackColor];
        
    }
    return _myView;
}
@end
