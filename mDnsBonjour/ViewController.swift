//
//  ViewController.swift
//  mDnsBonjour
//
//  Created by chinmaya panda on 19/04/20.
//  Copyright © 2020 chinmaya panda. All rights reserved.
//

import UIKit

class ViewController: UIViewController, serviceDataDelegate {


    var serviceProvider = ServiceProvider()
    var serviceBrowser = ServiceBrowser()
    var serviceHub: NSMutableArray!


    override func viewDidLoad() {
        super.viewDidLoad()
        serviceBrowser.delegate = self
        serviceProvider.publishService()
        serviceBrowser.browseService()

    }

    func dataReceived(serviceName: String, servicePort: Int, serviceType: String, serviceDomain: String, serviceInfoData: Data) {
        print("serviceName:", serviceName)
        print("serviceInfoData:", serviceInfoData)
        print("serviceType:", serviceType)
        print("serviceDomain", serviceDomain)

    }

}


