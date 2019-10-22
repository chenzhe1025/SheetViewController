//
//  SheetAction.swift
//  Social
//
//  Created by 7 on 2019/8/27.
//  Copyright © 2019 shengsheng. All rights reserved.
//

import Foundation

public class SheetAction {
    
    public typealias SheetActionHandler = ((SheetAction) -> Void)
    
    public init(title: String, image: UIImage? = nil, style: SheetAction.Style, handler: SheetActionHandler? = nil) {
        self.title = title
        self.image = image
        self.style = style
        self.handler = handler
        
    }
    
    public let title: String
    public let image: UIImage?
    public let style: SheetAction.Style
    public var handler: SheetActionHandler?
    
    var itemHeight: CGFloat {
        switch style {
        case .cancel:
            return 53
        default:
            return 55
        }
    }
}

extension SheetAction {
    
    public enum Style: Int {
        
        case `default`
        
        case cancel
    }
}
