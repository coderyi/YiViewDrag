//
//  ViewController.swift
//  YiViewDrag
//
//  Created by coderyi on 10/04/2021.
//  Copyright (c) 2021 coderyi. All rights reserved.
//

import UIKit
import YiViewDrag

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let testView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        view.addSubview(testView)
        testView.backgroundColor = .darkGray
        
        testView.vd_enableDrag()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

