//
//  MTBaseCollectionCell.swift
//  VidMe-iOS
//
//  Created by Quan on 2021/9/10.
//
#if os(iOS)
import UIKit
#else
import Cocoa
#endif

open class MTDefaultCollectionCell: QCollectionCell {
    public private(set) lazy var mt_imageView = createImageView()
    public private(set) lazy var titleLabel = createTitleLabel()
    
    /// 数据模型
    public private(set) var model: MTCollectionModel?
    /// 允许选中
    public var allowSelect: Bool = true
    
    open override var isSelected: Bool {
        didSet {
            guard allowSelect else { return }
            #if os(iOS)
            self.layer.borderWidth = isSelected ?  2 : 0
            #else
            self.view.layer?.borderWidth = isSelected ?  2 : 0
            #endif
        }
    }
    //MARK: - Init
    //MARK: -
    #if os(iOS)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    #else
    open override func loadView() {
        self.view = NSView.init()
        self.view.wantsLayer = true
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    #endif
    
    //MARK: - open
    //MARK:
    open func setValue(model: MTCollectionModel) {
        self.model = model
        if let image = model.image {
            mt_imageView.image = image
        } else if let imageName = model.imageName {
            mt_imageView.image = QImage(named: imageName)
        }
        if let title = model.title {
            #if os(iOS)
            titleLabel.text = title
            #else
            titleLabel.stringValue = title
            #endif
        }
    }
    
    open func setUp() {
        #if os(iOS)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.orange.cgColor
        self.addSubview(mt_imageView)
        self.addSubview(titleLabel)
        #else
        let layer = self.view.layer!
        layer.cornerRadius = 5
        layer.masksToBounds = true
        layer.borderColor = NSColor.orange.cgColor
        self.view.addSubview(mt_imageView)
        self.view.addSubview(titleLabel)
        #endif
        
        mt_imageView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }
    }
}

//MARK: - Getter && Setter
//MARK:
extension MTDefaultCollectionCell {
    private func createImageView() -> QImageView {
        let example = QImageView.init()
        return example
    }
    
    private func createTitleLabel() -> QLabel {
        let example = QLabel.init()
        #if os(iOS)
        example.font = UIFont.systemFont(ofSize: 15)
        #else
        example.font = NSFont.systemFont(ofSize: 15)
        example.isEditable = false
        example.isBordered = false
        example.isBezeled = false
        example.backgroundColor = NSColor.clear
        #endif
        return example
    }
}

