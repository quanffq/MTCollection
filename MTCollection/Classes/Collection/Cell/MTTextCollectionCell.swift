//
//  MTTextCollectionCell.swift
//  MTVideoMateriaListViewController
//
//  Created by Quan on 2021/9/13.
//

#if os(iOS)
import UIKit
#else
import Cocoa
#endif
class MTTextCollectionCell: MTDefaultCollectionCell {
    
    override func setUp() {
        #if os(iOS)
        let layer = self.layer
        layer.cornerRadius = 5
        layer.masksToBounds = true
        layer.borderColor = QColor.orange.cgColor
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        #else
        let layer = self.view.layer!
        layer.cornerRadius = 5
        layer.masksToBounds = true
        layer.borderColor = QColor.orange.cgColor
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        #endif
    }
    
    
}
