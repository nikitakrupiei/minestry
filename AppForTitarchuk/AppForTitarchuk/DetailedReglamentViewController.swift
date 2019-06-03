//
//  DetailedReglamentViewController.swift
//  AppForTitarchuk
//
//  Created by Никита Крупей on 1/24/19.
//  Copyright © 2019 Никита Крупей. All rights reserved.
//

import UIKit
import WebKit

class DetailedReglamentViewController: UIViewController {

    //var inform = PogodRada(date: "", info: "")
    var information: String = ""
    
    
   // @IBOutlet weak var WebVideo: WKWebView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ReglamentInformation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        ReglamentInformation.text = information
        scrollView.bottomAnchor.constraint(equalTo: ReglamentInformation.bottomAnchor).isActive = true
        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
