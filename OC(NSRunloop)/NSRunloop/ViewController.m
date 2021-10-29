//
//  ViewController.m
//  NSRunloop
//
//  Created by 范云飞 on 2017/9/30.
//  Copyright © 2017年 范云飞. All rights reserved.
//

#import "ViewController.h"

#import "PerformSelectorViewController.h"
#import "TimerViewController.h"
#import "PortViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *titles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"runloop应用场景";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titles = @[@"PeformSelector",@"Timer",@"Port"];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:_tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        PerformSelectorViewController *performSelectorVC = [[PerformSelectorViewController alloc] init];
        [self.navigationController pushViewController:performSelectorVC animated:YES];
    } else if (indexPath.row == 1) {
        TimerViewController *timerVC = [[TimerViewController alloc] init];
        [self.navigationController pushViewController:timerVC animated:YES];
    } else if (indexPath.row == 2) {
        PortViewController *portVC = [[PortViewController alloc] init];
        [self.navigationController pushViewController:portVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

