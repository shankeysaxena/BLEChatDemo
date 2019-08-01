//
//  ColorPickerController.swift
//  BLEDemo
//
//  Created by apple on 7/30/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import UIKit

protocol ColorPickerDelegate: class {
    func selectedColor(_ color: UIColor)
}

class ColorPickerController: UICollectionViewController
{
    let reuseIdentifier = "ColorPickerCell"
    let columnCount = 3
    let margin : CGFloat = 10
    weak var delegate: ColorPickerDelegate?
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.configureFlowLayoutForColorPickerWith(margin: margin)
        }
    }
}

// MARK: - UICollectionViewDataSource protocol
extension ColorPickerController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AppConstants.colorsForDevices.count
    }
    
    // make a cell for each cell index path
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.colorPickerCellID.rawValue, for: indexPath as IndexPath)
        cell.backgroundColor = AppConstants.colorsForDevices[indexPath.row]
        cell.layer.cornerRadius = 5.0
        return cell
    }
}

// MARK: - UICollectionViewDelegate protocol
extension ColorPickerController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.selectedColor(AppConstants.colorsForDevices[indexPath.row])
            dismiss(animated: true, completion: nil)
        }
    }
}

extension ColorPickerController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * CGFloat(columnCount - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(columnCount)).rounded(.down)
        return CGSize(width: itemWidth, height: itemWidth)
    }
}
