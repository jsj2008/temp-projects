//
//  UIPlaceHolderTextView.m
//  Matrix
//
//  Created by Justin on 12-9-18.
//  Copyright (c) 2012年 apple.inc. All rights reserved.
//

#import "UIPlaceHolderTextView.h"

@implementation UIPlaceHolderTextView

#pragma mark - Accessors

@synthesize placeholder = _placeholder;
@synthesize placeholderTextColor = _placeholderTextColor;

- (void)setText:(NSString *)string {
    [super setText:string];
    [self setNeedsDisplay];
}

- (void)insertText:(NSString *)string {
    [super insertText:string];
    [self setNeedsDisplay];
}


- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

- (void)setPlaceholder:(NSString *)string {
    
    if ([string isEqual:_placeholder]){
        return;
    }

    _placeholder = string;
    [self setNeedsDisplay];
}


- (void)setContentInset:(UIEdgeInsets)contentInset {
    [super setContentInset:contentInset];
    [self setNeedsDisplay];
}


- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self setNeedsDisplay];
}


- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    [super setTextAlignment:textAlignment];
    [self setNeedsDisplay];
}


#pragma mark - NSObject

- (void)dealloc {
}


#pragma mark - UIView

//- (id)initWithCoder:(NSCoder *)aDecoder {
//    if ((self = [super initWithCoder:aDecoder])) {
//        [self _initialize];
//    }
//    return self;
//}


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self _initialize];
    }
    return self;
}

- (id)init{
    if ((self = [super init])) {
        [self _initialize];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];

    if (self.text.length == 0 && self.placeholder){
        // Inset the rect
//        rect = UIEdgeInsetsInsetRect(rect, self.contentInset);
        
        // TODO: This is hacky. Not sure why 8 is the magic number
        if (self.contentInset.left == 0.0f) {
            rect.origin.x += 8.0f;
            rect.size.width -= 16.0f;
        }
        rect.origin.y += 8.0f;

        // Draw the text
        [_placeholderTextColor set];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = self.textAlignment;
        NSDictionary *attributes = @{ NSParagraphStyleAttributeName: paragraphStyle,
                                      NSForegroundColorAttributeName: _placeholderTextColor,
                                      NSFontAttributeName:self.font};
        [_placeholder drawInRect:rect withAttributes:attributes];
#else
		[_placeholder drawInRect:rect withFont:self.font lineBreakMode:UILineBreakModeTailTruncation alignment:self.textAlignment];
#endif
    }
}

#pragma mark - Private

- (void)_initialize{
    self.delegate = self;
    self.placeholderTextColor = [UIColor colorWithWhite:0.702f alpha:1.0f];
}

- (void)onTextDidChanged{
    [self setNeedsDisplay];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //响应回车事件
    if ([text isEqualToString:@"\n"]){
        [textView endEditing:true];
        return NO;
    }
    //设置输入字数限制
    if (text.length == 0) return YES;
    NSInteger existedLength = textView.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = text.length;
    
    if (self.maxInputNumber > 0) {
        if (existedLength - selectedLength + replaceLength > self.maxInputNumber) {
            return NO;
        }else{
            return YES;
        }
    }else{
        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    //提示
    [textView setNeedsDisplay];
    NSInteger number = [textView.text length];
    
    if (self.maxInputNumber > 0){
        //约定：如果不大于0就是没字数限制。。。。
        if (number > self.maxInputNumber ) {
            textView.text = [textView.text substringToIndex:self.maxInputNumber ];
        }
        [self.countDelegate refreshLeftCountLabel:(self.maxInputNumber  - textView.text.length)];
    }
}
@end
