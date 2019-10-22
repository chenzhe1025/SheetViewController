//
//  SheetViewController.swift
//  Social
//
//  Created by 7 on 2019/8/27.
//  Copyright © 2019 shengsheng. All rights reserved.
//

import UIKit

public class SheetViewControllor: UIViewController {

    private lazy var containerView = SheetView(actions: actions)

    private var actions: [SheetAction] = []
    
    public func addAction(_ action: SheetAction) {
        addActions([action])
    }
    
    public func addActions(_ actions: [SheetAction]) {
        self.actions.append(contentsOf: actions)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupLayout()
    }
    
    private func setup() {
        containerView.delegate = self
        view.addSubview(containerView)
    }
    
    private func setupLayout() {
        containerView.fillToSuperview()
    }
    
    public func show(in parent: UIViewController) {
        
        guard !actions.isEmpty else {
            fatalError("Oops: actions isEmpty")
        }
        
        parent.addChild(self)
        parent.view.addSubview(view)
        didMove(toParent: parent)
        view.fillToSuperview()
        
    }
}

extension SheetViewControllor: SheetViewDelegate {
    
    public func sheetViewHiddenCompletion(_ sheetView: SheetView) {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    public func sheetViewDidSlectedRow(at indexPath: IndexPath) {
        let action = actions[indexPath.row]
        action.handler?(action)
    }
}

extension UIView {
    @available(iOS 9, *)
    fileprivate func fillToSuperview() {
        // https://videos.letsbuildthatapp.com/
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            let left = leftAnchor.constraint(equalTo: superview.leftAnchor)
            let right = rightAnchor.constraint(equalTo: superview.rightAnchor)
            let top = topAnchor.constraint(equalTo: superview.topAnchor)
            let bottom = bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            NSLayoutConstraint.activate([left, right, top, bottom])
        }
    }
}
