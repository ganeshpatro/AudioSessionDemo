//
//  ViewController.swift
//  HeadPhonesChecker
//
//  Created by Ganesh Patro on 11/11/17.
//  Copyright © 2017 Ganesh Patro. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var lblDeviceDetails: UILabel!
    
    var headphonesConnected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.allowBluetooth)
        setupNotifications()
        print("Current connected output devices - \(AVAudioSession.sharedInstance().currentRoute.outputs)")
        lblDeviceDetails.text = "Current connected output devices - \n \(AVAudioSession.sharedInstance().currentRoute.outputs)"
    }

    func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleRouteChange),
                                               name: .AVAudioSessionRouteChange,
                                               object: AVAudioSession.sharedInstance())
    }
    
    @objc func handleRouteChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
            let reason = AVAudioSessionRouteChangeReason(rawValue:reasonValue) else {
                return
        }
        switch reason {
        case .newDeviceAvailable:
            let session = AVAudioSession.sharedInstance()
            for output in session.currentRoute.outputs where output.portType == AVAudioSessionPortHeadphones {
                headphonesConnected = true
                print("New device name is - \(output.description)")
            }
            print("New device available !!")
            lblDeviceDetails.text = "Current connected output devices - \n \(AVAudioSession.sharedInstance().currentRoute.outputs)"
        case .oldDeviceUnavailable:
            if let previousRoute =
                userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription {
                for output in previousRoute.outputs where output.portType == AVAudioSessionPortHeadphones {
                    headphonesConnected = false
                }
                lblDeviceDetails.text = "Current connected output devices - \n \(AVAudioSession.sharedInstance().currentRoute.outputs)"
            }
            print("Old device not reachable!!")
        default: ()
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

