//
//  ym_keyboardView.h
//  ym_keyboardViewDemo
//
//  Created by 熊雯婷 on 2017/8/21.
//  Copyright © 2017年 rionsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Block)();
typedef void(^strBlock)(NSString *str);

@interface ym_keyboardView : UIView
typedef NS_ENUM(NSInteger , YMkeyboardType){
    YMkeyboardNumType = 1,
    YMkeyboardEnType,
};

- (instancetype) initWithFrame:(CGRect)frame andKeyboardType:(YMkeyboardType)type andClickNormalBtn:(strBlock)normalClick andClickDeleteBtn:(Block)deleteClick andClickClearBtn:(Block)clearClick andComfirmClick:(Block)confirmClick;

@end
