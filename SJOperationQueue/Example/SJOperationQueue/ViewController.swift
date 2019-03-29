//
//  ViewController.swift
//  SJOperationQueue
//
//  Created by jshl8612 on 03/29/2019.
//  Copyright (c) 2019 jshl8612. All rights reserved.
//

import UIKit
import SJOperationQueue

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        testOpQueue()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func testOpQueue() {
        
        let printQueue: (_ startInt: Int) -> SJOperationQueue = { startInt in
            
            return SJOperationQueue(queue: (startInt...startInt+29).map({ val in
                let op: ()->Void = {
                    print("\(val)")
                }
                return op
            }))
        }
        
        let queue1 = SJOperationQueue(opQueueList: [printQueue(1), printQueue(31)])
        let queue2 = SJOperationQueue(opQueueList: [printQueue(61), printQueue(91)])
        let queue = SJOperationQueue(opQueueList: [queue1, queue2])
        
        queue.start()
    }
}

