//
//  PortViewController.m
//  NSRunloop
//
//  Created by 范云飞 on 2021/10/29.
//  Copyright © 2021 范云飞. All rights reserved.
//

#import "PortViewController.h"

@interface PortViewController ()

@property(nonatomic,strong) NSThread *myThread;
@property(nonatomic,assign) BOOL runLoopThreadDidFinishFlag;

@end

@implementation PortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self runLoopAddDependance];
}


- (void)runLoopAddDependance
{
    self.runLoopThreadDidFinishFlag = NO;
    NSLog(@"Start a New Run Loop Thread");
    NSThread *runLoopThread = [[NSThread alloc] initWithTarget:self selector:@selector(handleRunLoopThreadTask) object:nil];
    [runLoopThread start];
    
    NSLog(@"Exit handleRunLoopThreadButtonTouchUpInside");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (!_runLoopThreadDidFinishFlag) {
            self.myThread = [NSThread currentThread];
            NSLog(@"Begin RunLoop");
            NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
            NSPort *myPort = [NSPort port];
            [runLoop addPort:myPort forMode:NSDefaultRunLoopMode];
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            NSLog(@"End RunLoop");
            [self.myThread cancel];
            self.myThread = nil;
        }
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"***********%@*********",@"完成");
    });
}

- (void)handleRunLoopThreadTask
{
    NSLog(@"Enter Run Loop Thread");
    for (NSInteger i = 0; i < 10; i ++) {
        NSLog(@"In Run Loop Thread, count = %ld", i);
        sleep(1);
    }
#if 0
    // 错误示范
    _runLoopThreadDidFinishFlag = YES;
    // 这个时候并不能执行线程完成之后的任务，因为Run Loop所在的线程并不知道runLoopThreadDidFinishFlag被重新赋值。Run Loop这个时候没有被任务事件源唤醒。
    // 正确的做法是使用 "selector"方法唤醒Run Loop。 即如下:
#endif
    NSLog(@"Exit Normal Thread");
    [self performSelector:@selector(tryOnMyThread) onThread:self.myThread withObject:nil waitUntilDone:NO];
    
    NSLog(@"Exit Run Loop Thread");
}

- (void)tryOnMyThread
{
    _runLoopThreadDidFinishFlag = YES;
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

