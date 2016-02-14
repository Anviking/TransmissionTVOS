//
//  ViewController.swift
//  Test
//
//  Created by Johannes Lund on 2016-02-14.
//  Copyright © 2016 The Transmission Project. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let session = SessionSetup()
    var torrent: Torrent!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let bundle = NSBundle.mainBundle()
        guard let filePath = bundle.pathForResource("ubuntu.torrent", ofType: nil) else {
            fatalError("no torrent")
        }
        
        let path = NSTemporaryDirectory().stringByAppendingString("test")
        print(path)
        
        torrent = Torrent(path: filePath, location: path, deleteTorrentFile: true, lib: session.fLib )
        torrent.startTransferNoQueue()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

