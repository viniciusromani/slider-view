//
//  ViewController.swift
//  Slider
//
//  Created by Vinicius Romani on 24/09/18.
//  Copyright © 2018 Vinicius Romani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var wrapper: WrapperView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func loadView() {
        let wrapper = WrapperView()
        self.wrapper = wrapper
        self.view = wrapper
    }
}

