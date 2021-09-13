//
//  MTLayoutCollectionView.swift
//  MTVideoMateriaListViewController
//
//  Created by Quan on 2021/9/13.
//
#if os(iOS)
import UIKit
#else
import Cocoa
#endif

class MTLayoutCollectionView: MTCollectionView {


    
}
#if os(iOS)
extension MTLayoutCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard  let title = data[indexPath.item].title else {
            return (self.layout as? UICollectionViewFlowLayout)?.itemSize ?? .zero
        }
        let font = UIFont.boldSystemFont(ofSize: 15.0)
        let attributes = [NSAttributedString.Key.font: font]
        let size = title.size(withAttributes: attributes)
        return CGSize(width: size.width + 20, height: (self.layout as? UICollectionViewFlowLayout)?.itemSize.height ?? 50)
    }
}
#else
extension MTLayoutCollectionView: NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        guard  let title = data[indexPath.item].title else {
            return (self.layout as? NSCollectionViewFlowLayout)?.itemSize ?? .zero
        }
        let font = NSFont.boldSystemFont(ofSize: 15.0)
        let attributes = [NSAttributedString.Key.font: font]
        let size = title.size(withAttributes: attributes)
        return CGSize(width: size.width + 20, height: (self.layout as? NSCollectionViewFlowLayout)?.itemSize.height ?? 50)
    }
}
#endif
