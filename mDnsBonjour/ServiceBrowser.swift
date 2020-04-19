//
//  ServiceBrowser.swift
//  mDnsBonjour
//
//  Created by chinmaya panda on 19/04/20.
//  Copyright © 2020 chinmaya panda. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

protocol serviceDataDelegate {
    func dataReceived(serviceName: String, servicePort: Int, serviceType:String, serviceDomain: String, serviceInfoData: Data)
}

class ServiceBrowser: NSObject, NetServiceDelegate, NetServiceBrowserDelegate, GCDAsyncSocketDelegate {
    
    var service: NetService!
    var services: NSMutableArray!
    var serviceBrowser: NetServiceBrowser!
    var socket: GCDAsyncSocket!
    var delegate: serviceDataDelegate!
    
    func browseService() {
        if (services != nil) {
            services.removeAllObjects()
        } else {
            services = NSMutableArray()
        }
        
        serviceBrowser = NetServiceBrowser()
        serviceBrowser.delegate = self
        serviceBrowser.searchForServices(ofType: "_http._tcp", inDomain: "")
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        services.add(service)
        print("'ServicesFound':",services!)
        delegate.dataReceived(serviceName: service.name, servicePort: service.port, serviceType: service.type, serviceDomain: service.domain, serviceInfoData: service.txtRecordData()!)
        
        connectToService()
    }
    
    func connectToService() {
        service = (services.firstObject! as! NetService)
        service.delegate = self
        service.resolve(withTimeout: 30.0)
    }
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        if connectWithService(service: sender) {
            print("Did connect with service port:\(sender.port) having domain as:\(sender.domain) consisting of type:\(sender.type) and named as:\(sender.name)")
        } else {
            print("Error connecting with service")
        }
    }
    
    func netService(sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        service.delegate = nil
    }
    
    func connectWithService(service: NetService) -> Bool {
        var isConnected = false
        
        let addresses: NSArray = service.addresses! as NSArray
        print("addresses:->",addresses)
        
        if (socket == nil || !socket.isConnected) {
            socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
            //Connect
            var count = 0
            while (!isConnected && addresses.count >= count) {
                let address = addresses.object(at: count) as! NSData
                count += 1
                do {
                    try socket.connect(toAddress: address as Data)
                    isConnected = true
                } catch {
                    print("Failed to connect")
                }
            }
        } else {
            isConnected = socket.isConnected
        }
        return isConnected
        
    }
}

        
   

