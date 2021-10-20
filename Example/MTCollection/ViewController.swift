//
//  ViewController.swift
//  MTCollection
//
//  Created by 1144740954@qq.com on 09/13/2021.
//  Copyright (c) 2021 1144740954@qq.com. All rights reserved.
//

import UIKit
import MTCollection

class ViewController: UIViewController, MTCollectionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collection = MTCollectionView.init()
        collection.delegate = self
        self.view.addSubview(collection)
        collection.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(70)
        }
        collection.setData(titles: ["sddfsa","fsdf","hgh","rer","cvss","sddfsa","fsdf","hgh",])
        collection.selectRow(6)
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func colletionMessageCallback(dictioanry: [MTCollectionParameter : Any?]) {
        
    }
    
}

