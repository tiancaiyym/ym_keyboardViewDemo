//
//  ViewController.m
//  ym_keyboardViewDemo
//
//  Created by 熊雯婷 on 2017/8/21.
//  Copyright © 2017年 rionsoft. All rights reserved.
//

#import "ViewController.h"
#import "ym_keyboardView.h"

@interface ViewController () <UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate>
@property (strong ,nonatomic) UISearchController *search;
@property (weak, nonatomic) IBOutlet UITableView *tab;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    __weak typeof(self) weakSelf = self;
    ym_keyboardView *keyboardView = [[ym_keyboardView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 216, self.view.frame.size.width, 216) andKeyboardType:YMkeyboardNumType andClickNormalBtn:^(NSString *str) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if ([[NSString stringWithFormat:@"%@%@",strongSelf.search.searchBar.text,str] length] < 7) {
            strongSelf.search.searchBar.text = [NSString stringWithFormat:@"%@%@",strongSelf.search.searchBar.text,str];
        }
    } andClickDeleteBtn:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.search.searchBar.text.length > 0) {
            strongSelf.search.searchBar.text = [strongSelf.search.searchBar.text substringToIndex:(strongSelf.search.searchBar.text.length - 1)];
        }
    } andClickClearBtn:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.search.searchBar.text.length != 0){
            strongSelf.search.searchBar.text = @"";
        }
    } andComfirmClick:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.search setActive:NO];
    }];
    
    self.search = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.search.delegate = self;
    self.search.searchResultsUpdater = self;
    self.search.dimsBackgroundDuringPresentation = NO;
    self.search.obscuresBackgroundDuringPresentation = NO;
    self.search.hidesNavigationBarDuringPresentation = NO;
    self.search.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    self.search.searchBar.placeholder = @"搜索姓名或关键字";
    self.search.searchBar.delegate = self;
    for (UIView *subView in [[self.search.searchBar.subviews lastObject] subviews]) {
        if ([subView isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField*)subView;
            textField.inputView = keyboardView;
        }
    }
    self.tab.tableHeaderView = self.search.searchBar;
    self.tab.tableFooterView = [[UIView alloc]init];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSLog(@"1");
}


@end
