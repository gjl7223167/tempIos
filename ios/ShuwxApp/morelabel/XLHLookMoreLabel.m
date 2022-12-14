//
//  XLHLookMoreLabel.m
//  XLHLookMoreLabel
//
//  Created by 薛立恒 on 2019/3/5.
//  Copyright © 2019 薛立恒. All rights reserved.
//

#import "XLHLookMoreLabel.h"
#import "NSMutableAttributedString+CTFrameRef.h"
#import "NSMutableAttributedString+config.h"
#import "XLHAttributedLabelTools.h"

static NSString * const kEllipsesCharacter = @"\u2026";

@interface XLHLookMoreLabel ()

@property(nonatomic,strong) NSMutableAttributedString *attributedString;
@property(nonatomic,strong) NSMutableAttributedString *attributedOpenString;
@property(nonatomic,strong) NSMutableAttributedString *attributedCloseString;

@property(nonatomic,assign) CTFrameRef frameRef;
@property(nonatomic,assign) CGFloat width;
@property(nonatomic,assign) NSRange range;
@property(nonatomic,assign) BOOL isSelected;

@end

@implementation XLHLookMoreLabel

#pragma mark - ======== life cycle ========

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_configSetting];
    }
    return self;
}

#pragma mark - ======== public method ========
- (void)setText:(NSString *)text {
    NSAttributedString *attributedText = [self attributedString:text];
    [self setAttributedText:attributedText];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    self.attributedString = [[NSMutableAttributedString alloc]initWithAttributedString:attributedText];
    //设置文字排版方式
    [self.attributedString setAttributedsWithLineSpacing:self.lineSpacing andParagraphSapcing:self.paragraphSpacing andTextAlignment:self.textAlignment andLineBreakMode:self.lineBreakMode];
    [self setNeedsDisplay];
}

//添加展开和收起
- (void)setOpenString:(NSString *)openString andCloseString:(NSString *)closeString {
    [self setOpenString:openString andCloseString:closeString andFont:self.font andTextColor:self.textColor];
}

- (void)setOpenString:(NSString *)openString andCloseString:(NSString *)closeString andFont:(UIFont *)font andTextColor:(UIColor *)textColor {
    self.attributedOpenString = [self attributedString:openString font:font textColor:textColor];
    self.attributedCloseString = [self attributedString:closeString font:font textColor:textColor];
    [self setNeedsDisplay];
}

//获取label的size
- (CGSize)sizeThatFits:(CGSize)size {
    self.width = size.width;
    if (!self.attributedString) {
        return CGSizeZero;
    }
    CGFloat height = 0;
    //绘制展开状态
    if (self.state == XLHOpenState) {
        //获取初始行数
        CFIndex count = [self p_getInitialNumberOfLines];
        //获取添加"点击收起"后的attrString
        NSMutableAttributedString *lineAttrString = [self.attributedString mutableCopy];
        [lineAttrString appendAttributedString:self.attributedCloseString];
        CTFrameRef lineFrameRef = [lineAttrString prepareFrameRefWithWidth:self.width];
        CFIndex lineCount = CFArrayGetCount(CTFrameGetLines(lineFrameRef));
        //同行显示
        if (count == lineCount) {
            height = [lineAttrString boundingHeightForWidth:self.width];
        }
        //分行显示
        else {
            NSMutableAttributedString *attrString = [self p_getOpenAttrString];
            height = [attrString boundingHeightForWidth:self.width];
        }
    }
    //绘制关闭状态和第一次进入
    else {
        //_numberOfLines行情况下文字的高度
        height = [self.attributedString boundingHeightForWidth:self.width numberOfLines:self.numberOfLines];
    }
    return CGSizeMake(self.width, height);
}


#pragma mark - ======== private method ========
//初始化
- (void)p_configSetting {
    self.numberOfLines = 0;
    self.lineSpacing = 3.0f;
    self.paragraphSpacing = 10.0f;
    self.font = [UIFont systemFontOfSize:12.0f];
    self.textColor = [UIColor blackColor];
    self.textAlignment = kCTTextAlignmentLeft;
    self.lineBreakMode = kCTLineBreakByWordWrapping | kCTLineBreakByCharWrapping;
    self.attributedOpenString = [[NSMutableAttributedString alloc]init];
    self.attributedCloseString = [[NSMutableAttributedString alloc]init];
}

//计算展开状态下的attString
- (NSMutableAttributedString *)p_getOpenAttrString {
    NSMutableAttributedString *attrString = [self attributedString:[NSString stringWithFormat:@"%@%@",self.attributedString.string,@"\n"]];
    NSMutableAttributedString *closeString = [self.attributedCloseString mutableCopy];
    [closeString setAttributedsWithLineSpacing:self.lineSpacing andParagraphSapcing:self.paragraphSpacing andTextAlignment:kCTTextAlignmentCenter andLineBreakMode:self.lineBreakMode];
    [attrString appendAttributedString:closeString];
    return attrString;
}

//获取初始行数
- (NSUInteger)p_getInitialNumberOfLines {
    NSMutableAttributedString *attributedString = [self.attributedString mutableCopy];
    CTFrameRef frameRef = [attributedString prepareFrameRefWithWidth:self.width];
    NSUInteger count = CFArrayGetCount(CTFrameGetLines(frameRef));
    return count;
}

//获取当前需要展示的行数
- (NSUInteger)p_getCurrentNumberOfLines {
    CFArrayRef lines = CTFrameGetLines(self.frameRef);
    CFIndex lineCount = CFArrayGetCount(lines);
    return self.numberOfLines > 0 ? MIN(self.numberOfLines, lineCount) : lineCount;
}

#pragma mark - ======== touch action ========
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self];
    //检查是否选中链接
    CFIndex index = [XLHAttributedLabelTools touchContentOffsetInView:self atPoint:point ctFrame:self.frameRef];
    if (NSLocationInRange(index, self.range)) {
        self.isSelected = YES;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self];
    CFIndex index = [XLHAttributedLabelTools touchContentOffsetInView:self atPoint:point ctFrame:self.frameRef];
    if (self.isSelected
        && NSLocationInRange(index, self.range)
        && self.numberOfLines >= 0) {
        self.isSelected = NO;
        //更改状态
        if (self.state == XLHCloseState) {
            self.state = XLHOpenState;
            //重新设置高度
            CGSize size = [self sizeThatFits:CGSizeMake(self.width, MAXFLOAT)];
            if ([self.delegate respondsToSelector:@selector(displayView:openHeight:)]) {
                [self.delegate displayView:self openHeight:size.height];
            }
        } else {
            self.state = XLHCloseState;
            //重新设置高度
            CGSize size = [self sizeThatFits:CGSizeMake(self.width, MAXFLOAT)];
            if ([self.delegate respondsToSelector:@selector(displayview:closeHeight:)]) {
                [self.delegate displayview:self closeHeight:size.height];
            }
        }
        [self setNeedsDisplay];
    }
}

#pragma mark - ======== drawrect ========
- (void)drawRect:(CGRect)rect {
    if (!self.attributedString) {
        return;
    }
    //获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //将坐标系上下翻转
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);
    CGContextConcatCTM(context, transform);
    //绘制展开状态
    if (self.state == XLHOpenState) {
        [self drawOpenContext:context];
    }
    //绘制关闭状态和第一次进入
    else {
        [self drawCloseContext:context attributedString:self.attributedString];
    }
}

//绘制展开的
- (void)drawOpenContext:(CGContextRef)context {
    CFIndex count = [self p_getInitialNumberOfLines];
    NSMutableAttributedString *lineAttrString = [self.attributedString mutableCopy];
    [lineAttrString appendAttributedString:self.attributedCloseString];
    CTFrameRef lineFrameRef = [lineAttrString prepareFrameRefWithWidth:self.width];
    CFIndex lineCount = CFArrayGetCount(CTFrameGetLines(lineFrameRef));
    if (count == lineCount) {
        CGPathRef path = CTFrameGetPath(lineFrameRef);
        CFArrayRef lines = CTFrameGetLines(lineFrameRef);
        CGRect rect = CGPathGetBoundingBox(path);
        CGPoint lineorigins[lineCount];
        CTFrameGetLineOrigins(lineFrameRef, CFRangeMake(0, lineCount), lineorigins);
        for (CFIndex lineIndex = 0; lineIndex < lineCount; lineIndex ++) {
            CGPoint lineOrigin = lineorigins[lineIndex];
            lineOrigin.y = self.frame.size.height + (lineOrigin.y - rect.size.height);
            CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y);
            CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
            CTLineDraw(line, context);
            CFRelease(line);
        }
        self.range = [lineAttrString.string rangeOfString:self.attributedCloseString.string];
        self.state = XLHOpenState;
        self.frameRef = [lineAttrString prepareFrameRefWithWidth:self.width];
    } else {
        NSMutableAttributedString *attrString = [self p_getOpenAttrString];
        [self drawCloseContext:context attributedString:attrString];
    }
}

//绘制关闭的
- (void)drawCloseContext:(CGContextRef)context attributedString:(NSMutableAttributedString *)attrString {
    self.frameRef = [attrString prepareFrameRefWithWidth:self.width];
    CGPathRef path = CTFrameGetPath(self.frameRef);
    CGRect rect = CGPathGetBoundingBox(path);
    CFArrayRef lines = CTFrameGetLines(self.frameRef);
    CFIndex lineCount = CFArrayGetCount(lines);
    NSInteger numberOfLines = lineCount;
    if ([attrString isEqualToAttributedString:self.attributedString]) {
        //获取需要展示的行数
        numberOfLines = self.numberOfLines > 0 ? MIN(self.numberOfLines,lineCount) : lineCount;
    }
    //换行展示"点击收起"
    else {
        self.state = XLHOpenState;
        self.range = [attrString.string rangeOfString:self.attributedCloseString.string];
    }
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(self.frameRef, CFRangeMake(0, numberOfLines), lineOrigins);
    NSAttributedString *attributedString = attrString;
    //遍历每一行
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex ++) {
        CGPoint lineOrigin = lineOrigins[lineIndex];
        lineOrigin.y = self.frame.size.height + (lineOrigin.y - rect.size.height);
        CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y);
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        BOOL shouldDrawLine = YES;
        //找到最后一行
        if (lineIndex == numberOfLines - 1) {
            CFRange lastLineRange = CTLineGetStringRange(line);
            if (lastLineRange.location + lastLineRange.length < (CFIndex)attributedString.length) {
                CTLineTruncationType truncationType = kCTLineTruncationEnd;
                NSUInteger truncationAttributePosition = lastLineRange.location + lastLineRange.length - 1;
                NSDictionary *tokenAttributes = [attributedString attributesAtIndex:truncationAttributePosition effectiveRange:NULL];
                //生成"..."
                NSMutableAttributedString *tokenString = [[NSMutableAttributedString alloc]initWithString:kEllipsesCharacter attributes:tokenAttributes];
                //拼接成"...查看更多"
                [tokenString appendAttributedString:self.attributedOpenString];
                CTLineRef truncationToken = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)tokenString);
                NSMutableAttributedString *truncationString = [[attributedString attributedSubstringFromRange:NSMakeRange(lastLineRange.location, lastLineRange.length)] mutableCopy];
                if (lastLineRange.length > 0) {
                    unichar lastCharacter = [[truncationString string] characterAtIndex:lastLineRange.length - 1];
                    if ([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:lastCharacter]) {
                        [truncationString deleteCharactersInRange:NSMakeRange(lastLineRange.length - 1, 1)];
                    }
                }
                //拼接成一整行话
                [truncationString appendAttributedString:tokenString];
                //替换
                CTLineRef truncationLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)truncationString);
                CTLineRef truncatedLine = CTLineCreateTruncatedLine(truncationLine, self.width, truncationType, truncationToken);
                if (!truncatedLine) {
                    truncatedLine = CFRetain(truncationToken);
                }
                CFRelease(truncationLine);
                CFRelease(truncationToken);
                CTLineDraw(truncatedLine, context);
                NSUInteger truncatedCount = CTLineGetGlyphCount(truncatedLine);
                //获取当前显示的文字
                NSMutableAttributedString *showString = [[attrString attributedSubstringFromRange:NSMakeRange(0, lastLineRange.location + truncatedCount - tokenString.length)] mutableCopy];
                [showString appendAttributedString:tokenString];
                //获取绘制后的新属性
                self.range = [showString.string rangeOfString:self.attributedOpenString.string];
                self.state = XLHCloseState;
                self.frameRef = [showString prepareFrameRefWithWidth:self.width];
                CFRelease(truncatedLine);
                shouldDrawLine = NO;
            }
        }
        if (shouldDrawLine) {
            CTLineDraw(line, context);
        }
    }
}



#pragma mark - ======== setter & getter ========

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    self.numberOfLines = numberOfLines;
}

- (void)setFont:(UIFont *)font {
    if (font != self.font) {
        self.font = font;
        [self.attributedString setFont:font];
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (textColor != self.textColor) {
        self.textColor = textColor;
        [self.attributedString setTextColor:textColor];
    }
}

- (void)setFrame:(CGRect)frame {
    if (!CGRectEqualToRect(self.frame, frame)) {
        if (self.frameRef) {
            CFRelease(self.frameRef);
            self.frameRef = nil;
        }
        if ([NSThread isMainThread]) {
            [self setNeedsDisplay];
        }
    }
    [super setFrame:frame];
    self.width = frame.size.width;
}

- (void)setFrameRef:(CTFrameRef)frameRef {
    if (self.frameRef != frameRef) {
        if (self.frameRef != nil) {
            CFRelease(self.frameRef);
        }
        CFRetain(frameRef);
        self.frameRef = frameRef;
    }
}


- (NSMutableAttributedString *)attributedString:(NSString *)text {
    return [self attributedString:text font:self.font textColor:self.textColor];
}

- (NSMutableAttributedString *)attributedString:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor {
    if (!text && !text.length) {
        return nil;
    }
    //初始化NSMutableAttributedString
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];
    [attributedString setFont:font];
    [attributedString setTextColor:textColor];
    return attributedString;
}

-(void)dealloc {
    if (!self.frameRef != nil) {
        CFRelease(self.frameRef);
        self.frameRef = nil;
    }
}


@end
