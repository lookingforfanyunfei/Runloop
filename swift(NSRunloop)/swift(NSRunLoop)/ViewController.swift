//
//  ViewController.swift
//  swift(NSRunLoop)
//
//  Created by 范云飞 on 2017/9/1.
//  Copyright © 2017年 范云飞. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    var myThread:Thread? = nil
    var runLoopThreadDidFinishFlag:Bool = false

    override func viewDidLoad()
    {
        super.viewDidLoad()
        runLoop()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    func runLoop()
    {
        print("Start a New Run Loop Thread")
        let runLoopThread = Thread(target: self, selector: #selector(self.handleRunLoopThreadTask), object: nil)
        runLoopThread.start()
        
        print("Exit handleRunLoopThreadButtonTouchUpInside")
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            while !self.runLoopThreadDidFinishFlag {
                self.myThread = Thread.current
                print("Begin RunLoop")
                let runLoop = RunLoop.current
                let myPort: Port? = Port()
                runLoop.add(myPort!, forMode: .defaultRunLoopMode)
                RunLoop.current.run(mode: .defaultRunLoopMode, before: Date.distantFuture)
                print("End RunLoop")
                self.myThread?.cancel()
                self.myThread = nil
            }
        })
        DispatchQueue.main.async(execute: {() -> Void in
            print("***********\("完成")*********")
        })
    }
    
    func handleRunLoopThreadTask() {
        print("Enter Run Loop Thread")
        for i in 0..<10 {
            print("In Run Loop Thread, count = \(i)")
            sleep(1)
        }
        #if false
            // 错误示范
            runLoopThreadDidFinishFlag = true
            // 这个时候并不能执行线程完成之后的任务，因为Run Loop所在的线程并不知道runLoopThreadDidFinishFlag被重新赋值。Run Loop这个时候没有被任务事件源唤醒。
            // 正确的做法是使用 "selector"方法唤醒Run Loop。 即如下:
        #endif
        print("Exit Normal Thread")
        perform(#selector(self.tryOnMyThread), on: myThread!, with: nil, waitUntilDone: false)
        print("Exit Run Loop Thread")
    }
    
    @objc func tryOnMyThread() {
        self.runLoopThreadDidFinishFlag = true
    }
}

