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
    
    func testExtensionFunc() {
        let printQueue: (_ startInt: Int) -> [() -> Void] = { startInt in
            
            return (startInt...startInt+29).map({ val in
                let op: ()->Void = {
                    print("\(val)")
                }
                return op
            })
        }
        
        
    }
}
