//
//  CollectionViewFlowLayoutExtension.swift
//  BLEDemo
//
//  Created by apple on 7/30/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewFlowLayout {
    //MARK:- Helper method to initialize custom flowlayout
    func configureFlowLayoutForColorPickerWith(margin: CGFloat) {
        minimumInteritemSpacing = margin
        minimumLineSpacing = margin
        sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        estimatedItemSize = itemSize
    }
}
