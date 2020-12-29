//
//  RunLoopViewController.swift
//  InterView
//
//  Created by heshenghui on 2020/5/13.
//  Copyright © 2020 Company. All rights reserved.
//

import UIKit

class RunLoopViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        //主队列
//        DispatchQueue.main.async {
//            print("1");
//            self.perform(#selector(self.methodName), with: nil, afterDelay: 0.0);
//            print("2");
//        };
        //全局队列
        DispatchQueue.global().async {
            print("1");
            self.perform(#selector(self.methodName), with: nil, afterDelay: 0.0);
            print("2");
        };
        
        
    }
    
    @objc func methodName() {
        
        print("current thread -- %@",Thread.current);
        print("3");
    }
    
    

}
