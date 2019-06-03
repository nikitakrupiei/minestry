//
//  DetailerPogodViewController.swift
//  AppForTitarchuk
//
//  Created by Никита Крупей on 1/24/19.
//  Copyright © 2019 Никита Крупей. All rights reserved.
//

import UIKit
import CloudKit
import WebKit

class DetailerPogodViewController: UIViewController {

    @IBOutlet weak var WebVideo: WKWebView!
    //var inform = PogodRada(date: "", info: "")
    var information: String = ""
    var videoURL = ""
    
    //var myScrollView = UIScrollView()
    
    @IBOutlet weak var PogodInformation: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setNeedsStatusBarAppearanceUpdate()
        //PogodInformation.lineBreakMode = NSLineBreakMode.byWordWrapping
        PogodInformation.text = information
//        myScrollView = UIScrollView(frame: self.view.bounds)
//        myScrollView.addSubview(PogodInformation)
//        myScrollView.contentSize = self.PogodInformation.bounds.size
//        self.view.addSubview(myScrollView)
        getVideo(videoCode: videoURL)
        scrollView.bottomAnchor.constraint(equalTo: WebVideo.bottomAnchor).isActive = true
        
        // Do any additional setup after loading the view.
    }
    
    func getVideo(videoCode: String) {
        let url = URL(string: "https://www.youtube.com/embed/\(videoCode)")
        WebVideo.load(URLRequest(url: url!))
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
