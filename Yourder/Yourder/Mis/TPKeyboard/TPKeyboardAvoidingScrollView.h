//
//  TPKeyboardAvoidingScrollView.h
//
//  Created by Michael Tyson on 11/04/2011.
//  Copyright 2011 A Tasty Pixel. All rights reserved.
//

@protocol TPKeyboardAvoidingScrollViewTouchDelegate <NSObject>

@optional
- (void)DidReceiveTouch;

@end

@interface TPKeyboardAvoidingScrollView : UIScrollView {
    UIEdgeInsets    _priorInset;
    BOOL            _priorInsetSaved;
    BOOL            _keyboardVisible;
    CGRect          _keyboardRect;
    CGSize          _originalContentSize;
}

@property (strong, nonatomic) id<TPKeyboardAvoidingScrollViewTouchDelegate> touchDelegate;
- (void)adjustOffsetToIdealIfNeeded;
@end
