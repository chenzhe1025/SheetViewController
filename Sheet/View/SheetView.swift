//
//  SheetView.swift
//  Social
//
//  Created by 7 on 2019/8/27.
//  Copyright © 2019 shengsheng. All rights reserved.
//

import UIKit

public protocol SheetViewDelegate: NSObjectProtocol {
    
    func sheetViewHiddenCompletion(_ sheetView: SheetView)
    
    func sheetViewDidSlectedRow(at indexPath: IndexPath)
}

public class SheetView: UIView {
    
    public weak var delegate: SheetViewDelegate?
    
    private let actions: [SheetAction]
    
    private let containerView = UIView()
    
    private let tableView = UITableView()
    
    private lazy var cancleButton = UIButton()
    
    private var defaultActions: [SheetAction] {
        return actions.filter({ $0.style != .cancel })
    }
    
    private var cancleAction: SheetAction? {
        return actions.filter({ $0.style == .cancel }).first
    }
    
    private var containerViewHeight: CGFloat {
        
        var allActionItemHeight: CGFloat = actions.map({ $0.itemHeight }).reduce(0) { $0 + $1 }
        allActionItemHeight += 15
        if cancleAction != nil {
            allActionItemHeight += 15
        }
        return allActionItemHeight
    }
    
    public required init(actions: [SheetAction]) {
        self.actions = actions
        super.init(frame: .zero)
        backgroundColor = UIColor(r: 0, g: 0, b: 0, a: 0.5)
        
        setup()
        setupLayout()
        setInitTransform()
        setAnimationTransform()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        tapGestureRecognizer.addTarget(self, action: #selector(cancle))
        addGestureRecognizer(tapGestureRecognizer)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.scrollsToTop = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(SheetActionCell.self, forCellReuseIdentifier: String(describing: SheetActionCell.self))
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 8
        containerView.addSubview(tableView)
        
        guard let cancleAction = cancleAction else { return }
        
        cancleButton.setTitle(cancleAction.title, for: .normal)
        cancleButton.setTitleColor(.white, for: .normal)
        
        cancleButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancleButton.addTarget(self, action: #selector(cancle), for: .touchUpInside)
        cancleButton.translatesAutoresizingMaskIntoConstraints = false
        cancleButton.clipsToBounds = true
        cancleButton.layer.cornerRadius = 8
        cancleButton.adjustsImageWhenHighlighted = false
        if let cancleBackgroundImage = cancleAction.image {
            cancleButton.setBackgroundImage(cancleBackgroundImage, for: .normal)
        }
        containerView.addSubview(cancleButton)
    }
    
    private func setupLayout() {
        
        let containerViewConstraints = [
            
            NSLayoutConstraint(
                item: containerView,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: self,
                attribute: .bottom,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: containerView,
                attribute: .leading,
                relatedBy: .equal,
                toItem: self,
                attribute: .leading,
                multiplier: 1.0,
                constant: 15
            ),
            NSLayoutConstraint(
                item: containerView,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: self,
                attribute: .trailing,
                multiplier: 1.0,
                constant: -15
            ),
            NSLayoutConstraint(
                item: containerView,
                attribute: .height,
                relatedBy: .lessThanOrEqual,
                toItem: self,
                attribute: .height,
                multiplier: 1.0,
                constant: 0
            )
        ]
        addConstraints(containerViewConstraints)
        
        if let cancleAction = cancleAction {
            
            let cancleButtonConstraints = [
                
                NSLayoutConstraint(
                    item: cancleButton,
                    attribute: .bottom,
                    relatedBy: .equal,
                    toItem: containerView,
                    attribute: .bottom,
                    multiplier: 1.0,
                    constant: -15
                ),
                NSLayoutConstraint(
                    item: cancleButton,
                    attribute: .leading,
                    relatedBy: .equal,
                    toItem: containerView,
                    attribute: .leading,
                    multiplier: 1.0,
                    constant: 0
                ),
                NSLayoutConstraint(
                    item: cancleButton,
                    attribute: .trailing,
                    relatedBy: .equal,
                    toItem: containerView,
                    attribute: .trailing,
                    multiplier: 1.0,
                    constant: 0
                ),
                NSLayoutConstraint(
                    item: cancleButton,
                    attribute: .height,
                    relatedBy: .equal,
                    toItem: nil,
                    attribute: .notAnAttribute,
                    multiplier: 1.0,
                    constant: cancleAction.itemHeight
                )
            ]
            containerView.addConstraints(cancleButtonConstraints)
        }
        let tableViewItemHeight: CGFloat = defaultActions.first?.itemHeight ?? 0
        let tableViewHeight: CGFloat = CGFloat(defaultActions.count) * tableViewItemHeight
        var tableViewConstraints = [
            
            NSLayoutConstraint(
                item: tableView,
                attribute: .top,
                relatedBy: .equal,
                toItem: containerView,
                attribute: .top,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: tableView,
                attribute: .leading,
                relatedBy: .equal,
                toItem: containerView,
                attribute: .leading,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: tableView,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: containerView,
                attribute: .trailing,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: tableView,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: tableViewHeight
            )
        ]
        var tableViewbottomConstraint = NSLayoutConstraint(
            item: tableView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: containerView,
            attribute: .bottom,
            multiplier: 1.0,
            constant: -83
        )
        if cancleAction == nil {
            tableViewbottomConstraint = NSLayoutConstraint(
                item: tableView,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: containerView,
                attribute: .bottom,
                multiplier: 1.0,
                constant: -15
            )
            
        }
        tableViewConstraints.append(tableViewbottomConstraint)
        containerView.addConstraints(tableViewConstraints)
    }
}

extension SheetView {
    
    private func setInitTransform() {
        containerView.transform = CGAffineTransform(translationX: 0, y: containerViewHeight)
    }
    
    private func setAnimationTransform() {
        UIView.animate(withDuration: 0.5, delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.containerView.transform = .identity
                        self.alpha = 1
        })
    }
    
    @objc private func cancle() {
        UIView.animate(withDuration: 0.5, delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.setInitTransform()
                        self.alpha = 0
        }) {(complation) in
            self.delegate?.sheetViewHiddenCompletion(self)
        }
    }
}


extension SheetView: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SheetActionCell.self), for: indexPath) as? SheetActionCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = defaultActions[indexPath.row].title
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defaultActions.count
    }
    
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return defaultActions[indexPath.row].itemHeight
    }
}

extension SheetView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sheetViewDidSlectedRow(at: indexPath)
        cancle()
    }
    
}

extension SheetView: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard touch.view is SheetView else {
            return false
        }
        return true
    }
}
