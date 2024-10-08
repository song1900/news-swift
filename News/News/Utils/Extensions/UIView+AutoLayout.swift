//
//  UIView+AutoLayout.swift
//  News
//
//  Created by 송우진 on 10/3/24.
//

import UIKit

extension UIView {
    enum Layout {
        case top(CGFloat)
        case leading(CGFloat)
        case bottom(CGFloat)
        case trailing(CGFloat)
        
        case topEqual(to: UIView, constant: CGFloat)
        case leadingEqual(to: UIView, constant: CGFloat)
        case bottomEqual(to: UIView, constant: CGFloat)
        case trailingEqual(to: UIView, constant: CGFloat)
        
        case topNext(to: UIView, constant: CGFloat)
        case leadingNext(to: UIView, constant: CGFloat)
        case bottomNext(to: UIView, constant: CGFloat)
        case trailingNext(to: UIView, constant: CGFloat)
        
        case centerX(CGFloat)
        case centerY(CGFloat)
        case center(CGFloat)
        
        case fillX(CGFloat)
        case fillY(CGFloat)
        case fill(CGFloat)
        
        case width(CGFloat)
        case height(CGFloat)
    }
}

extension UIView {
    func addSubview(
        _ view: UIView,
        autoLayout: [UIView.Layout] = []
    ) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        let layouts = autoLayout.map({ layout in
            switch layout {
            case .top(let constant): 
                [view.topAnchor.constraint(equalTo: topAnchor, constant: constant)]
            case .leading(let constant): 
                [view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constant)]
            case .bottom(let constant): 
                [view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -constant)]
            case .trailing(let constant): 
                [view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constant)]

            case .topEqual(let to, let constant): 
                [view.topAnchor.constraint(equalTo: to.topAnchor, constant: constant)]
            case .leadingEqual(let to, let constant): 
                [view.leadingAnchor.constraint(equalTo: to.leadingAnchor, constant: constant)]
            case .bottomEqual(let to, let constant): 
                [view.bottomAnchor.constraint(equalTo: to.bottomAnchor, constant: -constant)]
            case .trailingEqual(let to, let constant): 
                [view.trailingAnchor.constraint(equalTo: to.trailingAnchor, constant: -constant)]

            case .topNext(let to, let constant): 
                [view.topAnchor.constraint(equalTo: to.bottomAnchor, constant: constant)]
            case .leadingNext(let to, let constant): 
                [view.leadingAnchor.constraint(equalTo: to.trailingAnchor, constant: constant)]
            case .bottomNext(let to, let constant): 
                [view.bottomAnchor.constraint(equalTo: to.bottomAnchor, constant: -constant)]
            case .trailingNext(let to, let constant): 
                [view.trailingAnchor.constraint(equalTo: to.leadingAnchor, constant: -constant)]
                
            case .centerX(let constant):
                [view.centerXAnchor.constraint(equalTo: centerXAnchor, constant: constant)]
            case .centerY(let constant): 
                [view.centerYAnchor.constraint(equalTo: centerYAnchor, constant: constant)]
            case .center(let constant): 
                [
                    view.centerXAnchor.constraint(equalTo: centerXAnchor, constant: constant),
                    view.centerYAnchor.constraint(equalTo: centerYAnchor, constant: constant)
                ]
                
            case .fillX(let constant): 
                [
                    view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constant),
                    view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constant)
                ]
            case .fillY(let constant): 
                [
                    view.topAnchor.constraint(equalTo: topAnchor, constant: constant),
                    view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -constant)
                ]
            case .fill(let constant): 
                [
                    view.topAnchor.constraint(equalTo: topAnchor, constant: constant),
                    view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constant),
                    view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -constant),
                    view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constant)
                ]
            case .width(let constant): 
                [view.widthAnchor.constraint(equalToConstant: constant)]
            case .height(let constant): 
                [view.heightAnchor.constraint(equalToConstant: constant)]
            }
        }).flatMap { $0 }
        NSLayoutConstraint.activate(layouts)
    }
}
