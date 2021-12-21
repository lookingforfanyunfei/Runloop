//
//  TimerViewController.m
//  NSRunloop
//
//  Created by 范云飞 on 2021/10/29.
//  Copyright © 2021 范云飞. All rights reserved.
//

#import "TimerViewController.h"

@interface TimerViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray <NSString *>*dataArray;

@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic, strong) NSThread *myThread;

@end

@implementation TimerViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self cancelTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"runloop应用场景";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _dataArray = @[@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer",@"Timer"];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:_tableView];
    
    [self startTimerOnMainThread];
    
//    [self startTimerOnChildThread];
}

- (void)cancelTimer {
    if (self.timer && self.myThread) {
        [self performSelector:@selector(cancel) onThread:self.myThread withObject:nil waitUntilDone:NO];
    }
}

- (void)cancel {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    // 停止RunLoop
    CFRunLoopStop(CFRunLoopGetCurrent());
    
    [self.myThread cancel];
    self.myThread = nil;
}

- (void)startTimerOnChildThread {
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        _myThread = [NSThread currentThread];
//        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(testTimer) userInfo:nil repeats:YES];
//
//        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
//        [runloop addTimer:_timer forMode:NSDefaultRunLoopMode];
//        [runloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.myThread = [NSThread currentThread];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(testTimer) userInfo:nil repeats:YES];
        
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addTimer:self.timer forMode:NSDefaultRunLoopMode];
        [runloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    });
}

- (void)startTimerOnMainThread {
//    if (!_timer) {
//        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(testTimer) userInfo:nil repeats:YES];
//    _myThread = [NSThread currentThread];
//    }
//    [_timer fire];
    
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(testTimer) userInfo:nil repeats:YES];
        _myThread = [NSThread currentThread];
    }
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)testTimer {
    NSLog(@"测试定时器");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
