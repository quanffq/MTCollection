//
//  MTCollectionView.swift
//  MagicPhotos
//
//  Created by Quan on 2021/4/25.
//

#if os(iOS)
import UIKit
public typealias QView = UIView
public typealias QColor = UIColor
public typealias QImage = UIImage
public typealias QLabel = UILabel
public typealias QImageView = UIImageView
public typealias QCollection = UICollectionView
public typealias QCollectionCell = UICollectionViewCell
public typealias QCollectionViewLayout = UICollectionViewLayout
public typealias QCollectionViewFlowLayout = UICollectionViewFlowLayout
#else
import Cocoa
public typealias QView = NSView
public typealias QColor = NSColor
public typealias QImage = NSImage
public typealias QLabel = NSTextField
public typealias QImageView = NSImageView
public typealias QCollection = NSCollectionView
public typealias QCollectionCell = NSCollectionViewItem
public typealias QCollectionViewLayout = NSCollectionViewLayout
public typealias QCollectionViewFlowLayout = NSCollectionViewFlowLayout
#endif
import SnapKit

public protocol MTCollectionDelegate: AnyObject {
    func colletionMessageCallback(dictioanry: [MTCollectionParameter: Any?])
}

public struct MTCollectionModel {
   public var imageName: String?
   public var image: QImage?
   public var title: String?
   public var object: Any?
   public var tag: Int = -1
   public init() {}
}

public enum MTCollectionParameter: String {
    case mt_mask    ///标记
    case model      ///数据模型
    case isSelect   /// 是否选中
    case index      /// 路径
}

public class MTCollectionView: QView {
    /// collection
    public lazy var collection = createCollectionView()
    /// layout
    public var layout: QCollectionViewLayout!
    /// cell
    public var cell: MTDefaultCollectionCell!
    
    ///代理
    public weak var delegate: MTCollectionDelegate?
    /// 数据
    public private(set) var data: [MTCollectionModel] = []
    /// 标记
    public var mt_mask: String?
    /// ReuseIdentifier
    public var reuseIdentifier: String = "default-Cell-reuse-Identifier"
    /// 允许选中
    public private(set) var allowSelect: Bool = true
    /// 允许回调取消选中
    public var cancelSelect: Bool = false
    /// 默认选中
    public var defaultSelect: IndexPath?
    
//    public private(set) var allowCancelBool: 
    /// 不参与单选，可以实现取消
    private var allowCancelIndexs: [Int] = []
    /// 初始化设置选中
    private var selectRow: Int = -1
    //MARK: - Init
    //MARK:
    public init(layout: QCollectionViewLayout? = nil, cell: MTDefaultCollectionCell? = nil ) {
        super.init(frame: .zero)
        self.layout = layout ?? defaultLayout()
        self.cell = cell ?? MTDefaultCollectionCell.init()
        self.reuseIdentifier = NSStringFromClass(type(of: self.cell!)) + "-Cell-reuse-Identifier"
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Configuration
    //MARK:
    private func setUp() {
        #if os(iOS)
        self.backgroundColor = UIColor.clear
        collection.backgroundColor = UIColor.clear
        self.addSubview(collection)
        collection.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        #else
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.clear.cgColor
        let scroll = NSScrollView.init()
        scroll.borderType = .noBorder
        scroll.hasHorizontalScroller = true
        scroll.autohidesScrollers = true
        scroll.documentView = collection
        self.addSubview(scroll)
        scroll.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        #endif
    }
}

//MARK: - Private
//MARK:
extension MTCollectionView {
    
}

//MARK: - Public
//MARK:
extension MTCollectionView {
    /// 设置数据
    public func setData(images: [QImage]? = nil, imageNames: [String]? = nil, titles: [String]? = nil, object: [Any]? = nil, tag: Int = -1) {
        guard let num = titles?.count ?? images?.count ?? imageNames?.count else {
            print("ERROR❌== 数据为空----" + #function )
            return
        }
        data = []
        for i in 0..<num {
            var model = MTCollectionModel.init()
            if let imageName = imageNames?[i] {
                model.imageName = imageName
            }
            if let image = images?[i] {
                model.image = image
            }
            if let title = titles?[i] {
                model.title = title
            }
            if let object = object?[i] {
                model.object = object
            }
            model.tag = tag
            data.append(model)
        }
        collection.reloadData()
    }
    
    /// 设置数据
    public func setData(_ models: [MTCollectionModel]) {
        self.data = models
        collection.reloadData()
    }
    
    
    public func selectRow(_ at: Int) {
        #if os(iOS)
        if collection.visibleCells.count == 0 {
            selectRow = at
        }
        collection.selectItem(at: IndexPath.init(row: at, section: 0), animated: false, scrollPosition: .centeredVertically)
        #else
        if collection.visibleItems().count == 0 {
            selectRow = at
        }
        collection.selectItems(at: [IndexPath.init(item: at, section: 0)], scrollPosition: .centeredVertically)
        #endif
    }
    
    public func setAllowSelect(_ allow: Bool) {
        self.allowSelect = allow
        collection.reloadData()
    }

    /// 部分cell 不参加单选
    /// - Parameters:
    ///   - indexs: 不参加单选
    ///   - allow:  参加单选是否允许取消
    public func allowPartCancel(indexs: [Int]?, allow: Bool = false) {
        if let indexs = indexs {
            allowCancelIndexs = indexs
            collection.allowsMultipleSelection = true
        } else {
            allowCancelIndexs = []
            collection.allowsMultipleSelection = false
        }
    }
    
    public func getSelectRow() -> Int? {
        #if os(iOS)
        guard let indexs = collection.indexPathsForSelectedItems else { return nil}
        #else
        let indexs = collection.selectionIndexPaths
        #endif
        return indexs.first?.item
    }
}

//MARK: - UITableViewDataSource
#if os(iOS)
extension MTCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as! MTDefaultCollectionCell
        let model = data[indexPath.row]
        cell.allowSelect = self.allowSelect
        cell.setValue(model: model)
        if let selectIndex = defaultSelect, indexPath == selectIndex {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
            defaultSelect = nil
        }
        if indexPath.row == selectRow {
            cell.isSelected = true
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = data[indexPath.row]
        self.delegate?.colletionMessageCallback(dictioanry: [.mt_mask: self.mt_mask, .index: indexPath, .model: model, .isSelect: true])
        for index in allowCancelIndexs {
            if index == indexPath.row { return }
            for row in 0..<collection.numberOfItems(inSection: 0) {
                if row != index && row != indexPath.row {
                    collection.deselectItem(at: IndexPath.init(row: row, section: 0), animated: false)
                }
            }
        }
        if selectRow != -1 && selectRow != indexPath.row {
            let cell = collection.cellForItem(at: IndexPath(item: selectRow, section: 0))
            cell?.isSelected = false
            selectRow = -1
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard cancelSelect else { return }
        let model = data[indexPath.row]
        self.delegate?.colletionMessageCallback(dictioanry: [.mt_mask: self.mt_mask, .index: indexPath, .model: model, .isSelect: false])
    }
}
#else
extension MTCollectionView: NSCollectionViewDelegate, NSCollectionViewDataSource {
    open func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    open func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let model = data[indexPath.item]
        let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: self.reuseIdentifier), for: indexPath) as! MTDefaultCollectionCell
        cell.allowSelect = self.allowSelect
        cell.setValue(model: model)
        if let selectIndex = defaultSelect, indexPath == selectIndex {
            collectionView.selectionIndexPaths = [selectIndex]
            cell.isSelected = true
            defaultSelect = nil
        }
        if indexPath.item == selectRow {
            cell.isSelected = true
        }
        return cell
    }
    
    open func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let item = indexPaths.first?.item else { return }
        let model = data[item]
        self.delegate?.colletionMessageCallback(dictioanry: [.mt_mask: self.mt_mask, .index: indexPaths.first, .model: model, .isSelect: true])
        for index in allowCancelIndexs {
            if index == item { return }
            for row in 0..<collection.numberOfItems(inSection: 0) {
                if row != index && row != item {
                    collection.deselectItems(at: [IndexPath.init(item: row, section: 0)])
                }
            }
        }
        if selectRow != -1 && selectRow != item {
            let cell = collection.item(at: IndexPath(item: selectRow, section: 0))
            cell?.isSelected = false
            selectRow = -1
        }
    }
    
    open func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        guard cancelSelect else { return }
        guard let item = indexPaths.first?.item else { return }
        let model = data[item]
        self.delegate?.colletionMessageCallback(dictioanry: [.mt_mask: self.mt_mask, .index: indexPaths.first, .model: model, .isSelect: false])
    }
}

#endif

//MARK: - Getter && Setter
//MARK:
extension MTCollectionView {
    private func defaultLayout() -> QCollectionViewLayout {
        let layout = QCollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.scrollDirection = .horizontal
        return layout
    }
    
    private func createCollectionView() -> QCollection {
        #if os(iOS)
        let collectionView = QCollection(frame: .zero, collectionViewLayout: self.layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.register(cell.classForCoder, forCellWithReuseIdentifier: self.reuseIdentifier)
        #else
        let collectionView = QCollection()
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColors = [ NSColor.clear]
        collectionView.allowsMultipleSelection = false
        collectionView.allowsEmptySelection = true
        collectionView.isSelectable = true
        collectionView.register(cell.classForCoder, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: self.reuseIdentifier))
        #endif
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }
}
