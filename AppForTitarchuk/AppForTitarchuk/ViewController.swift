//
//  ViewController.swift
//  AppForTitarchuk
//
//  Created by Никита Крупей on 1/24/19.
//  Copyright © 2019 Никита Крупей. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Regl: UIButton!
    @IBOutlet weak var Cabmin: UIButton!
    @IBOutlet weak var Pogod: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Cabmin.backgroundColor = UIColor.gray
        Regl.backgroundColor = UIColor.gray
        Pogod.backgroundColor = UIColor.gray
        
        Regl.layer.cornerRadius = 20
        Cabmin.layer.cornerRadius = 20
        Pogod.layer.cornerRadius = 20
        
        
        // Do any additional setup after loading the view, typically from a nib.
        //setNeedsStatusBarAppearanceUpdate()
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }


}

