//
//  PerformSelectorViewController.m
//  NSRunloop
//
//  Created by 范云飞 on 2021/10/29.
//  Copyright © 2021 范云飞. All rights reserved.
//

#import "PerformSelectorViewController.h"

@interface PerformSelectorViewController ()

//Permanent thread

@property (nonatomic, strong) NSThread *permanetThread;

@end

@implementation PerformSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self createPermanetThread];
    
    [self testPerformSelector];
}

- (void)testPerformSelector {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ///主线成的runloop默认开启
//        [self performSelectorOnMainThread:@selector(backGroundThread) withObject:nil waitUntilDone:NO];
//        NSLog(@"hello world 1");
        
        
        /// 子线程的runloop需要手动开启
        [self performSelector:@selector(backGroundThread) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];
        NSLog(@"hello world 1");
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        
//
//        [self performSelector:@selector(backGroundThread) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//        NSLog(@"hello world 1");
        
        
        
        ///不给runloop添加sources，runloop直接退出，执行后面的代码
//        while (1) {
//            NSLog(@"while begin");
//            NSRunLoop *subRunLoop = [NSRunLoop currentRunLoop];
//            [subRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//            NSLog(@"while end");
//        }
        
        
        
        ///给runloop添加sources，等待任务处理完后才会执行后面的代码
//        while (1) {
//            NSPort *macPort = [NSPort port];
//            NSLog(@"while begin");
//            NSRunLoop *subRunLoop = [NSRunLoop currentRunLoop];
//            [subRunLoop addPort:macPort forMode:NSDefaultRunLoopMode];
//            [subRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//            NSLog(@"while end");
//            NSLog(@"%@",subRunLoop);
//        }
        
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.permanetThread) {
        [self performSelector:@selector(task) onThread:self.permanetThread withObject:nil waitUntilDone:NO];
    }
}

- (void)backGroundThread{
    NSLog(@"—hello world2—");
}

- (void)createPermanetThread {
    self.permanetThread = [self networkRequestThread];
}

- (void)task {
    for (int i = 0 ; i < 1000; i++) {
        NSLog(@"执行耗时任务：%d",i);
    }
}

- (void)networkRequestThreadEntryPoint:(id)__unused object {
    @autoreleasepool {
        [[NSThread currentThread] setName:@"PermanetThread"];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

- (NSThread *)networkRequestThread {
    static NSThread *_networkRequestThread = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _networkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint:) object:nil];
        [_networkRequestThread start];
    });
    return _networkRequestThread;
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
