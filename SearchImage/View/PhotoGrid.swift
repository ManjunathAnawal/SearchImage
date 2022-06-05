//
//  PhotoGrid.swift
//  SearchImage
//
//  Created by Manjunath on 03/06/22.
//

import UIKit

class PhotoGrid: UICollectionViewFlowLayout {
    private let minColumnWidth: CGFloat = 120.0
    private let paddingSize: CGFloat = 1.0
    
    override func prepare() {
        super.prepare()
        setCollectionViewUI()
        
    }
    private func setCollectionViewUI(){
        guard let collectionView = self.collectionView else { return }
        
        // set the spacing between cells
        self.minimumLineSpacing = paddingSize
        self.minimumInteritemSpacing = paddingSize
        
        // set the padding around sections
        self.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.sectionInsetReference = .fromSafeArea
        
        // calculate cell side length
        let availableWidth = collectionView.bounds.inset(by: collectionView.safeAreaInsets).width
        let maxNumColumns = (availableWidth / minColumnWidth).rounded(.down)
        let totalPaddingWidth = paddingSize * (maxNumColumns - 1) + self.sectionInset.left + self.sectionInset.right
        let sideLength = ((availableWidth - totalPaddingWidth) / maxNumColumns).rounded(.down)
        
        // set size
        self.itemSize = CGSize(width: sideLength, height: sideLength)
    }
}
