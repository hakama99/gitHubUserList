//
//  Downloader.swift
//  gitHubUserList
//
//  Created by CE on 2020/8/4.
//  Copyright © 2020 hakama. All rights reserved.
//

import UIKit

public class DownloadManager{
    
    
    // The Singleton Facade instance
    fileprivate static var instance: DownloadManager?
    // Concurrent queue for singleton instance
    fileprivate static let instanceQueue = DispatchQueue(label: "DownloadManager", attributes: DispatchQueue.Attributes.concurrent)
    
    
    private class func getInstance(_ closure: (() -> DownloadManager)) -> DownloadManager {
        instanceQueue.sync(flags: .barrier, execute: {
            if(DownloadManager.instance == nil) {
                DownloadManager.instance = closure()
            }
        })
        return instance!
    }
    
    class func Instance() -> DownloadManager {
        return getInstance { DownloadManager() }
    }
    

    func Load(url: URL, completion: @escaping(_ data:Data?,_ response:URLResponse?,_ error:Error?)->Void) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let task = session.dataTask(with: url) { (data, response, error) in
            
            completion(data,response,error)
        }
        task.resume()
    }
}


extension UIImageView{
    func download(url:URL,defaultImg:String = ""){
        self.isHidden = true
        DownloadManager.Instance().Load(url: url,completion: {(data,response,error) in

            DispatchQueue.main.async() {
                if let data = data{
                    self.image = UIImage(data:data,scale:1.0)
                    self.isHidden = false
                }else{
                    print("message:\(error)")
                    guard let image = UIImage(named: defaultImg) else{
                        self.isHidden = true
                        return
                    }
                    self.image = image
                    self.isHidden = false
                    return
                }
            }
        })
    }
}
