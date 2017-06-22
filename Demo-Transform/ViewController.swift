//
//  ViewController.swift
//  Demo-Transform
//
//  Created by 孙继刚 on 2017/6/22.
//  Copyright © 2017年 madordie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var currentLayer: CALayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let view = DrawingBoard(frame: self.view.bounds)
        self.view.addSubview(view)
        view.setup()
        self.view.backgroundColor = UIColor.gray
    }
}

