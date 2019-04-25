//
//  SJOperationQueue.swift
//  SJOperationQueue
//
//  Created by Shenglong Jiang on 29/03/2019.
//

import UIKit

class SJOperationQueue: NSObject {
    
    enum OperateType {
        case sync
        case async
    }
    
    typealias SJOperation = (_ onCompleted: () -> Void) -> Void
    
    private var queue : [()->Void] = []
    private var completedCount: Int = 0
    private var totalCount: Int = 0
    
    private var opQueueList: [SJOperationQueue] = []
    
    var isOperating : Bool {
        return _isOperating
    }
    private var _isOperating : Bool = false
    
    private var shouldStop : Bool = false
    
    var operateType: OperateType = .sync
    var onComplete: () -> Void = {}
    
    
    /// init
    ///
    /// - Parameters:
    ///   - type: Operate Type (aync or sync)
    ///   - queue: Operation List
    
    init(sync queue: [SJOperation]) {
        super.init()
        
        self.operateType = .sync
        self.queue = queue.map({op in
            {
                op(self.next)
            }
        })
    }
    
    init(async queue: [SJOperation]) {
        super.init()
        
        self.operateType = .async
        
        self.totalCount = queue.count
        self.completedCount = 0
        
        self.queue = queue.map({op in
            {
                op(self.subQueueCompleted)
            }
        })
    }
    
    init(syncOpQueueList: [SJOperationQueue]) {
        super.init()
        
        self.operateType = .sync
        self.queue = opQueueList.map({ [weak self] op in
            let newOp: () -> Void = {
                op.onComplete = {
                    self?.next()
                }
                op.start()
            }
            return newOp
        })
    }
    
    init(ayncOpQueueList: [SJOperationQueue]) {
        super.init()
        
        self.operateType = .async
        self.queue = opQueueList.map({ [weak self] op in
            let newOp: () -> Void = {
                op.onComplete = {
                    self?.subQueueCompleted()
                }
                op.start()
            }
            return newOp
        })
    }
    
    deinit {
        queue = []
        onComplete = {}
    }
    
    // MARK: - Public Interfaces
    func start() {
        guard _isOperating == false else {
            return
        }
        
        if operateType == .sync {
            self.runFirst()
        } else if operateType == .async {
            // run all operations
            for op in queue {
                op()
            }
        }
    }
    
    func clear() {
        shouldStop = true
        queue = []
    }
    
    func stop() {
        shouldStop = true
    }
}

// Sync Mode function
extension SJOperationQueue {
    fileprivate func runFirst() {
        // check if need stop runing
        guard shouldStop == false else {
            _isOperating = false
            shouldStop = false
            
            onComplete()
            return
        }
        
        // get next operation to run
        if let op = queue.first {
            _isOperating = true
            op()
        } else {
            //all of opereations is done.
            //post on completed operation
            _isOperating = false
            shouldStop = false
            onComplete()
        }
    }
    
    
    fileprivate func next() {
        _ = queue.removeFirst()
        runFirst()
    }
}

// MARK: - Async Mode Functions
extension SJOperationQueue {
    
    private func subQueueCompleted() {
        completedCount += 1
        
        if completedCount == totalCount {
            self.onComplete()
        }
    }
}
