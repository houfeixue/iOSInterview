//
//  ChangeArrayViewController.swift
//  InterView
//
//  Created by heshenghui on 2020/5/24.
//  Copyright © 2020 Company. All rights reserved.
//

import UIKit

class ChangeArrayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let addTwo  = add(intput: 34);
        let a =  addTwo(2);
        
    }
    
//    数组交换
    func swap<T>(_ nums: inout [T], _ a : Int ,_ b : Int)  {
        let tmp = nums[a];
        nums[a] = nums[b];
        nums[b] = tmp;
//        元组的方式
        (nums[a],nums[b]) = (nums[b],nums[a]);
    }
//    柯里化是指 从一个多参数的函数变成一连串单参数的变化
    func add(intput : Int) -> (Int) ->Int {
        return {
            value in
            return value + intput;
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
