//
//  BTabCell.swift
//  BTabViewController
//
//  Created by Berkay Vurkan on 1.08.2020.
//  Copyright © 2020 Foo. All rights reserved.
//

import UIKit

open class BTabCell: UICollectionViewCell {

    // MARK: - Properties
    internal var nameLabel: UILabel?
    // Model
    private var model: BTabItemModel?
    // Definitions
    static let identifier = "BTabCell"

    override open func draw(_ rect: CGRect) {
        super.draw(rect)
//        print("BTabCell:::::> draw")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
//        print("BTabCell:::::> init frame")
        if nameLabel == nil {
            nameLabel = UILabel(frame: .zero)
            contentView.addSubview(nameLabel!)
        }
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
//        print("BTabCell:::::> init coder")
        if nameLabel == nil {
            nameLabel = UILabel(frame: .zero)
            contentView.addSubview(nameLabel!)
        }
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
//        print("BTabCell:::::> awakeFromNib")
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
//        print("BTabCell:::::> layoutSubviews")
        if nameLabel != nil {
            attachLabel()
        }
    }

    override open var reuseIdentifier: String? {
        get {
            return "BTabCell"
        }
    }

    private func attachLabel() {
        guard nameLabel != nil else { return }
        nameLabel?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            .init(item: nameLabel!, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0),
            .init(item: nameLabel!, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 0),
            .init(item: nameLabel!, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0),
            .init(item: nameLabel!, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0)])
        UIView.animate(withDuration: 0.2, animations: {
            self.nameLabel?.layoutIfNeeded()
        })
    }

    open func configureCell(_ model: BTabItemModel) {
        self.model = model
        UIView.animate(withDuration: 0.4, animations: {
            self.setTheme(selection: model.getActive())
        }, completion: nil)
        guard nameLabel != nil else { return }
        self.nameLabel!.textAlignment = model.textAlignment
        self.nameLabel!.text = model.title
//        print("Configure Cell order:\(model.order)")
    }

    private func setTheme(selection: Bool) {
        guard model != nil else { return }
        guard nameLabel != nil else { return }
        if selection {
            self.nameLabel!.font = model!.highlightFont
            self.nameLabel!.textColor = model!.highlightTextColor
        } else {
            self.nameLabel!.font = model!.titleFont
            self.nameLabel!.textColor = model!.titleTextColor
        }
    }
}
