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
    
    private var queue : [() -> Void] = []
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
    init(queue: [() -> Void]) {
        super.init()
        
        self.operateType = .sync
        self.queue = queue.map({ [weak self] op in
            let newOp: () -> Void = {
                op()
                self?.next()
            }
            return newOp
        })
    }
    
    init(opQueueList: [SJOperationQueue]) {
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
    
    deinit {
        queue = []
        onComplete = {}
    }
    
    func start() {
        guard _isOperating == false else {
            return
        }
        
        runFirst()
    }
    
    func clear() {
        shouldStop = true
        queue = []
    }
    
    func next() {
        _ = queue.removeFirst()
        runFirst()
    }
    
    func stop() {
        shouldStop = true
    }
    
    private func runFirst() {
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
    
    func addOperation(operation : @escaping ()->Void, atIndex index:Int? = nil) {
        if index != nil {
            queue.insert(operation, at: index!)
        } else {
            queue.append(operation)
        }
    }
}
