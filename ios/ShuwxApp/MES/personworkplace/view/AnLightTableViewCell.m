//
//  AnLightTableViewCell.m
//  ShuwxApp
//
//  Created by XuWei de apple on 2020/12/14.
//  Copyright © 2020 tiantuosifang. All rights reserved.
//

#import "AnLightTableViewCell.h"
#import "UrlRequest.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]

@implementation AnLightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initSubViews];
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString * identifer =  NSStringFromClass([self class]);
    AnLightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (nil == cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifer owner:nil options:nil].firstObject;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}

-(void)initSubViews
{
    [self.lightViewOne viewAddTaget:self sel:@selector(zhiliangClick)];
    [self.lightViewTwo viewAddTaget:self sel:@selector(shebeiClick)];
    [self.lightViewThree viewAddTaget:self sel:@selector(wuliaoClick)];
//    [self.lightViewFour viewAddTaget:self sel:@selector(qitaClick)];

    [self.lightViewOne viewSetBgColor:RGB(0, 137, 255) img:@"mes_zhil_selected" title:@"质量异常" titleColor:[UIColor whiteColor] forStatus:YES];
    [self.lightViewOne viewSetBgColor:RGB(244, 248, 251) img:@"mes_zhiliang" title:@"质量异常" titleColor:RGB(157, 168, 189) forStatus:NO];
    [self.lightViewTwo viewSetBgColor:RGB(0, 137, 255) img:@"mes_sheb_selected" title:@"设备异常" titleColor:[UIColor whiteColor] forStatus:YES];
    [self.lightViewTwo viewSetBgColor:RGB(244, 248, 251) img:@"mes_sheb_unselected" title:@"设备异常" titleColor:RGB(157, 168, 189) forStatus:NO];
    [self.lightViewThree viewSetBgColor:RGB(0, 137, 255) img:@"mes_peis_selected" title:@"物料配送" titleColor:[UIColor whiteColor] forStatus:YES];
    [self.lightViewThree viewSetBgColor:RGB(244, 248, 251) img:@"mes_peis_unselected" title:@"物料配送" titleColor:RGB(157, 168, 189) forStatus:NO];
//    [self.lightViewFour viewSetBgColor:RGB(0, 137, 255) img:@"mes_other_selected" title:@"其他" titleColor:[UIColor whiteColor] forStatus:YES];
//    [self.lightViewFour viewSetBgColor:RGB(244, 248, 251) img:@"mes_other_unselected" title:@"其他" titleColor:RGB(157, 168, 189) forStatus:NO];
    
}

-(void)updateStatus
{
    
    self.lightViewOne.isSelected = NO;
    self.lightViewTwo.isSelected = NO;
    self.lightViewThree.isSelected = NO;
//    self.lightViewFour.isSelected = NO;
}

-(void)zhiliangClick
{
    self.lightViewOne.isSelected = !self.lightViewOne.isSelected;
}

-(void)shebeiClick
{
    self.lightViewTwo.isSelected = !self.lightViewTwo.isSelected;
}

-(void)wuliaoClick
{
    self.lightViewThree.isSelected = !self.lightViewThree.isSelected;
}

-(void)qitaClick
{
    self.lightViewFour.isSelected = !self.lightViewFour.isSelected;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
