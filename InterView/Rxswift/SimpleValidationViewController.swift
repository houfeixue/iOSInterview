//
//  SimpleValidationViewController.swift
//  InterView
//
//  Created by heshenghui on 2020/5/14.
//  Copyright © 2020 Company. All rights reserved.
//

import UIKit

class SimpleValidationViewController: UIViewController {

    lazy var usernameOutlet:UITextField! = {
        let text = UITextField.init();
        return text;
    }();
    lazy var usernameValidOutlet:UILabel! = {
        let label = UILabel.init();
        return label;
    }();
    
    lazy var passwordOutlet:UITextField! = {
        let text = UITextField.init();
        return text;
    }();
    lazy var passwordValidOutlet:UILabel! = {
        let label = UILabel.init();
        return label;
    }();
    lazy var doSomethingOutlet:UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.system);
        return button;
    }();
    
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
