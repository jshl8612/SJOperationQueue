//
//  testOperationQueueTests.swift
//  testOperationQueueTests
//
//  Created by Shenglong Jiang on 29/03/2019.
//  Copyright © 2019 Shenglong Jiang. All rights reserved.
//

import XCTest
@testable import testOperationQueue

class testOperationQueueTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    
    func testOpQueue() {
    
        let printQueue1: [() -> Void] = (1...30).map({ val in
            let op: ()->Void = {
                print("\(val)")
            }
            return op
        })
        
        let queue1 = SJOperationQueue(queue: printQueue1)
        
        let printQueue2: [() -> Void] = (31...60).map({ val in
            let op: ()->Void = {
                print("\(val)")
            }
            return op
        })
        
        let queue2 = SJOperationQueue(queue: printQueue2)
        
        let queue = SJOperationQueue(opQueueList: [queue1, queue2])
        
        queue.start()
        
    }
}
