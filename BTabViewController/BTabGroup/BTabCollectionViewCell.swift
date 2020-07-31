//
//  BTabCollectionViewCell.swift
//  BTabViewController
//
//  Created by Berkay Vurkan on 31.07.2020
//  Copyright © 2020 foo. All rights reserved.
//

import UIKit

class BTabCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!

    // MARK: - Properties
    static let identifier = "BTabCollectionViewCell"
    static let nibName = "BTabCollectionViewCell"
    var model: BTabItemModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configureCell(_ model: BTabItemModel) {
        self.model = model
        UIView.animate(withDuration: 0.4, animations: {
            self.setTheme(selection: model.getActive())
        }, completion: nil)
        self.nameLabel.textAlignment = model.textAlignment
        self.nameLabel.text = model.title
    }

    func setTheme(selection: Bool) {
        guard model != nil else { return }
        if selection {
            self.nameLabel.font = model!.highlightFont
            self.nameLabel.textColor = model!.highlightTextColor
        } else {
            self.nameLabel.font = model!.titleFont
            self.nameLabel.textColor = model!.titleTextColor
        }
    }

}
