//
//  ym_keyboardView.m
//  ym_keyboardViewDemo
//
//  Created by 熊雯婷 on 2017/8/21.
//  Copyright © 2017年 rionsoft. All rights reserved.
//

#import "ym_keyboardView.h"
#define NomalerBtnColor [UIColor whiteColor]
#define EspecialBtnGrayColor  [UIColor colorWithRed:154.0/255.0 green:163.0/255.0 blue:176.0/255.0 alpha:1.0]
#define KeyboardBackgroundColor [UIColor colorWithRed:198.0/255.0 green:203.0/255.0 blue:210.0/255.0 alpha:1.0]

#ifndef KScreenWidth
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#endif

#ifndef keyboardHeight
#define keyboardHeight self.bounds.size.height
#endif

@interface ym_keyboardView()
@property (weak ,nonatomic) UIView *ym_NumKeyboardView;
@property (weak ,nonatomic) UIView *ym_EnKeyboardView;
@property (strong ,nonatomic) strBlock normalClick;
@property (strong ,nonatomic) Block deleteClick;
@property (strong ,nonatomic) Block clearClick;
@property (strong ,nonatomic) Block confirmClick;
@property (assign ,nonatomic) YMkeyboardType type;
@end

@implementation ym_keyboardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype) initWithFrame:(CGRect)frame andKeyboardType:(YMkeyboardType)type andClickNormalBtn:(strBlock)normalClick andClickDeleteBtn:(Block)deleteClick andClickClearBtn:(Block)clearClick andComfirmClick:(Block)confirmClick{
    if (self = [super initWithFrame:frame]) {
        switch (type) {
            case YMkeyboardNumType:
            {
                [self creatNumTypeKeyboard];
            }
                break;
            case YMkeyboardEnType:
            {
                [self creatEnTypeKeyboard];
            }
                break;
            default:
                break;
        }
        self.backgroundColor = [UIColor clearColor];
        
        self.type = type;
        
        //建立block关联
        self.normalClick = normalClick;
        self.deleteClick = deleteClick;
        self.clearClick = clearClick;
        self.confirmClick = confirmClick;
    }
    return self;
}

- (void)creatNumTypeKeyboard{
    UIView *view = [[UIView alloc]initWithFrame:self.bounds];
    view.backgroundColor = KeyboardBackgroundColor;
    NSMutableArray *ary = [NSMutableArray arrayWithObjects:@"600",@"1",@"2",@"3",@"🔙",@"601",@"4",@"5",@"6",@"隐藏",@"300",@"7",@"8",@"9",@"清空",@"000",@"0",@"确认",@"abc",nil];
    
    //计算按钮大小
    int rowCount = 5;
    float leftX = 3.0;
    float rightX = 3.0;
    float top = 10.0;
    float bottom = 5.0;
    float distance = 3.0;
    float btnWidth = (KScreenWidth - leftX - rightX - 4 * distance)/5.0;
    float largeBtnWidth = btnWidth * 2 + distance ;
    float btnHeight = (keyboardHeight - top - bottom - 3*distance)/4.0;
    
    //创建按钮
    for (int i=0; i<ary.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        if (i != 17 && i != 18) {
            btn.frame = CGRectMake(i%rowCount*(distance + btnWidth)+leftX, i/rowCount*(btnHeight + distance)+top, btnWidth, btnHeight);
        }else if (i == 17){
            btn.frame = CGRectMake(i%rowCount*(distance + btnWidth)+leftX, i/rowCount*(btnHeight + distance)+top, largeBtnWidth, btnHeight);
        }else{
            btn.frame = CGRectMake((i+1)%rowCount*(distance + btnWidth)+leftX, (i+1)/rowCount*(btnHeight + distance)+top, btnWidth, btnHeight);
        }
        btn.layer.cornerRadius = 5.0;
        btn.layer.masksToBounds = YES;
        if (i%5 == 4 || i == 18) {
            [btn setBackgroundColor:EspecialBtnGrayColor];
        }else{
            [btn setBackgroundColor:NomalerBtnColor];
        }
        [btn setTitle:[ary objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (i == 4) {
            [btn addTarget:self action:@selector(deleteText:) forControlEvents:UIControlEventTouchUpInside];
        }else if (i == 9 || i == 17){
            [btn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
        }else if (i == 14){
            [btn addTarget:self action:@selector(clearText:) forControlEvents:UIControlEventTouchUpInside];
        }else if (i == 18){
            [btn addTarget:self action:@selector(changeType) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [btn addTarget:self action:@selector(inputText:) forControlEvents:UIControlEventTouchUpInside];
        }
        [view addSubview:btn];
    }
    [self addSubview:view];
    self.ym_NumKeyboardView = view;
}

- (void)creatEnTypeKeyboard{
    UIView *view = [[UIView alloc]initWithFrame:self.bounds];
    view.backgroundColor = KeyboardBackgroundColor;
    NSMutableArray *ary = [NSMutableArray arrayWithObjects:@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",@"Z",@"X",@"C",@"V",@"B",@"N",@"M",@"清空",@"🔙",@"隐藏",@"123",@"确认",nil];
    //计算按钮大小
    int row1Count = 10;
    int row2Count = 9;
    int row3Count = 7;
    float leftX = 3.0;
    float rightX = 3.0;
    float top = 10.0;
    float bottom = 5.0;
    float distanceX = 3.0;
    float distanceY = 10.0;
    float btnWidth = (KScreenWidth - leftX - rightX - 9 * distanceX)/10.0;
    float btnHeight = (keyboardHeight - top - bottom - 3 * distanceY)/4.0;
    for (int i=0; i<ary.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        if (i < row1Count) {
            btn.frame = CGRectMake(i%row1Count*(distanceX + btnWidth)+leftX, top, btnWidth, btnHeight);
        }else if (i < row1Count + row2Count){
            btn.frame = CGRectMake(i%row2Count*(distanceX + btnWidth)+(leftX + btnWidth/2.0), top+(distanceY+btnHeight)*1, btnWidth, btnHeight);
        }else if (i < row1Count + row2Count + row3Count){
            btn.frame = CGRectMake(i%row3Count*(distanceX + btnWidth)+(leftX + distanceX + 1.5*btnWidth), top+(distanceY+btnHeight)*2, btnWidth, btnHeight);
        }else if (i < row1Count + row2Count + row3Count + 2){
            CGFloat x = i%2?KScreenWidth - rightX - 1.4 * btnWidth : leftX;
            btn.frame = CGRectMake(x, top+(distanceY+btnHeight)*2, 1.4*btnWidth, btnHeight);
        }else if (i < row1Count + row2Count + row3Count + 4){
            CGFloat x = i%2?KScreenWidth - rightX - 2.5 * btnWidth - distanceX : leftX;
            btn.frame = CGRectMake(x, top+(distanceY+btnHeight)*3, 2.5 * btnWidth + distanceX, btnHeight);
        }else{
            btn.frame = CGRectMake(2.5 * btnWidth + distanceX*2 + leftX, top+(distanceY+btnHeight)*3, 5 * btnWidth + 4 * distanceX, btnHeight);
        }
        btn.layer.cornerRadius = 5.0;
        btn.layer.masksToBounds = YES;
        if (i < 26 || i == 30) {
            [btn setBackgroundColor:NomalerBtnColor];
            if (i < 26) {
                [btn addTarget:self action:@selector(inputText:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [btn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
            }
        }else{
            [btn setBackgroundColor:EspecialBtnGrayColor];
            if (i == 26) {
                [btn addTarget:self action:@selector(clearText:) forControlEvents:UIControlEventTouchUpInside];
            }else if (i == 27){
                [btn addTarget:self action:@selector(deleteText:) forControlEvents:UIControlEventTouchUpInside];
            }else if (i == 28){
                [btn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
            }else if (i == 29){
                [btn addTarget:self action:@selector(changeType) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        [btn setTitle:[ary objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [view addSubview:btn];
    }
    [self addSubview:view];
    self.ym_EnKeyboardView = view;
}

#pragma mark - setter and getter
- (void)setType:(YMkeyboardType)type{
    _type = type;
    if (type == YMkeyboardNumType) {
        [self.ym_EnKeyboardView removeFromSuperview];
        [self creatNumTypeKeyboard];
    }else if(type == YMkeyboardEnType) {
        [self.ym_NumKeyboardView removeFromSuperview];
        [self creatEnTypeKeyboard];
    }
}


#pragma mark - clickEvent
- (void)inputText:(UIButton *)btn{
    NSString *str = btn.titleLabel.text;
    self.normalClick(str);
}

- (void)deleteText:(UIButton *)btn{
    self.deleteClick();
}

- (void)clearText:(UIButton *)btn{
    self.clearClick();
}

- (void)confirm:(UIButton *)btn{
    self.confirmClick();
}

- (void)changeType{
    if (self.type == YMkeyboardNumType) {
        self.type = YMkeyboardEnType;
    }else if (self.type == YMkeyboardEnType){
        self.type = YMkeyboardNumType;
    }
}

@end
