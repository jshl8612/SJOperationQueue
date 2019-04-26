//
//  ViewController.swift
//  SJOperationQueue
//
//  Created by jshl8612 on 03/29/2019.
//  Copyright (c) 2019 jshl8612. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var opQueue: SJOperationQueue!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        opQueue = SJOperationQueue(syncOpQueueList: [getLoadOpQueue(), getSaveOpQueue()])
        opQueue.onComplete = {
            print("All Work is Done, go to next step")
        }
        
        opQueue.start()
    }
    
    // Load Operation is async mode
    func getLoadOpQueue() -> SJOperationQueue {
        
        var opList: [SJOperationQueue.SJOperation] = []
        for index in (0...10) {
            
            opList.append { onCompleted in
                DispatchQueue.main.asyncAfter(
                deadline: .now() + .seconds(Int.random(in: (1...2)))) {
                    
                    let desc = "\nLoadOperation\(index) is Done."
                    print(desc)
                    onCompleted()
                }
            }
        }
        
        
        let loadOpQueue = SJOperationQueue(async: opList)
        
        loadOpQueue.onComplete = {
            print("All of load operations is Done")
        }
        
        
        return loadOpQueue
    }
    
    // Save Operation is sync mode
    func getSaveOpQueue() -> SJOperationQueue {
        
        var opList: [SJOperationQueue.SJOperation] = []
        for index in (0...10) {
            
            opList.append { onCompleted in
                DispatchQueue.main.asyncAfter(
                deadline: .now() + .seconds(Int.random(in: (1...2)))) {
                    
                    let desc = "\nSaveOperation\(index) is Done."
                    print(desc)
                    onCompleted()
                }
            }
        }
        
        
        let saveOpQueue = SJOperationQueue(sync: opList)
        
        saveOpQueue.onComplete = {
            
            print("All of save operations is Done")
        }
        
        return saveOpQueue
    }
}

