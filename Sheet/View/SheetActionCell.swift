//
//  SheetActionCell.swift
//  Social
//
//  Created by 7 on 2019/8/27.
//  Copyright © 2019 shengsheng. All rights reserved.
//

import Foundation

public class SheetActionCell: UITableViewCell {
    
    public let titleLabel = UILabel()
    public let lineView = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        setupLayout()
    }
    
    private func setup() {
        selectionStyle = .none
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        lineView.backgroundColor = UIColor(hexString: "fafafa")
        lineView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lineView)
    }
    
    private func setupLayout() {
        let titleLabelConstraints = [
            
            NSLayoutConstraint(
                item: titleLabel,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .bottom,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: titleLabel,
                attribute: .leading,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .leading,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: titleLabel,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .trailing,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: titleLabel,
                attribute: .top,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .top,
                multiplier: 1.0,
                constant: 0
            )
        ]
        contentView.addConstraints(titleLabelConstraints)
        
        let lineViewConstraints = [
            
            NSLayoutConstraint(
                item: lineView,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .bottom,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: lineView,
                attribute: .leading,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .leading,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: lineView,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .trailing,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: lineView,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: 1
            )
        ]
        contentView.addConstraints(lineViewConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
