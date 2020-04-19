//
//  ServiceProvider.swift
//  mDnsBonjour
//
//  Created by chinmaya panda on 19/04/20.
//  Copyright © 2020 chinmaya panda. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

class ServiceProvider: NSObject, NetServiceDelegate, GCDAsyncSocketDelegate {
    
    var socket: GCDAsyncSocket!
    var service: NetService?
    var services = [NetService]()
    var servicesCache : NSMutableArray!
    var countServiceInstance = 0
    
    func publishService() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.service1()
            self?.service2()
        }
    }
    
    func service1() {
        
        socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        do {
                   try socket.accept(onPort: 0)
                   service = NetService(domain: "", type: "_http._tcp", name: "My iPhone", port: 80)
               }catch {
                   print("Port1 listening error!")
               }
               if let service = service {
                   service.delegate = self
                   service.publish()
                   services.append(service)
               }
    }
    
    func service2() {
        socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        do {
                   try socket.accept(onPort: 1)
                   service = NetService(domain: "", type: "_http._tcp", name: "My iPad", port: 8080)
               }catch {
                   print("Port2 listening error!")
               }
               if let service = service {
                   service.delegate = self
                   service.publish()
                   services.append(service)
               }
    }
    
    func netServiceDidPublish(_ sender: NetService) {
        
        guard let service = service else { return }
        
        if sender.setTXTRecord(sender.txtRecordData()) == true {
            
            print("service\(countServiceInstance)",service)
            var statement = ""
            switch countServiceInstance {
            case 0:
                statement = "first"
            case 1:
                statement = "second"
            case 2:
                statement = "third"
            default:
                statement = " "
            }
            print("\(statement) service:",services[countServiceInstance])
            
            print(services[countServiceInstance].name)
            print(services[countServiceInstance].domain)
            print(services[countServiceInstance].type)
            print(services[countServiceInstance].port)
            print(countServiceInstance)
            print("Service Published Successfully for \(services[countServiceInstance].name)")
            countServiceInstance += 1
            }
        }
        
}

