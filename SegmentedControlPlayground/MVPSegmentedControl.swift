//
//  File.swift
//  Chemowave
//
//  Created by Matt Pileggi on 10/10/17.
//  Copyright © 2017 Citrusbits. All rights reserved.
//

import UIKit

class MVPSegmentedControl : UIView {
    
    var selectedTextColor: UIColor
    var defaultTextColor: UIColor
    
    var selectedBackgroundColor: UIColor
    
    var options: [String]? {
        didSet {
            resetSubviews()
        }
    }
    
    private var optionViews: [UIView]?
    
    required init?(coder aDecoder: NSCoder) {
        
        //defaults
        selectedTextColor = UIColor.black
        defaultTextColor = UIColor.white
        selectedBackgroundColor = UIColor.orange
        
        super.init(coder: aDecoder)
        
        self.options = ["Low", "Medium", "High"]
        
        resetSubviews()
        applyDefaultStyles()
    }
    
    private func resetSubviews() {
        guard let options = options else { return }
        
        if let optionViews = optionViews {
            optionViews.forEach { view in
                view.removeFromSuperview()
            }
        }
        
        optionViews = []

        for i in 0..<options.count {
            let isLast = (i == options.count - 1)
            let subview = createSubview(withText: options[i], withDivider: !isLast)
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            subview.addGestureRecognizer(tap)
            
            addSubview(subview)

            optionViews!.append(subview)
        }
        addConstraints()
    }
    
    private func applyDefaultStyles() {
        layer.cornerRadius = 5
        layer.masksToBounds = true
//        clipsToBounds = true
        backgroundColor = UIColor.white.withAlphaComponent(0.1)
    }
    
    private func addConstraints() {
        guard let optionViews = optionViews, optionViews.count > 0 else { return }
        
        //apply constraints to leading/trailing to superview for first and last views respectively
        optionViews.first?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        optionViews.last?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        //apply trailing/leading and width constraints where appropriate
        for i in 0..<optionViews.count - 1 {
            optionViews[i].trailingAnchor.constraint(equalTo: optionViews[i+1].leadingAnchor).isActive = true
            optionViews[i].widthAnchor.constraint(equalTo: optionViews.last!.widthAnchor).isActive = true
        }
        
        //apply top and bottom constraints to all subviews
        for i in 0..<optionViews.count {
            optionViews[i].bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            optionViews[i].topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        }
    }
    
    private func createSubview(withText text: String, withDivider dividerVisible: Bool = true) -> UIView {
    
        //subview
        let subview = UIView()
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.layer.masksToBounds = true
        subview.layer.cornerRadius = 5
        
        //label
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = defaultTextColor
        
        subview.addSubview(label)
        
        label.centerXAnchor.constraint(equalTo: subview.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: subview.centerYAnchor).isActive = true

        //divider
        if (dividerVisible) {
            let divider = UIView()
            divider.translatesAutoresizingMaskIntoConstraints = false
            divider.backgroundColor = defaultTextColor
            
            subview.addSubview(divider)
            
            divider.trailingAnchor.constraint(equalTo: subview.trailingAnchor).isActive = true
            divider.topAnchor.constraint(equalTo: subview.topAnchor, constant: 8.0).isActive = true
            divider.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: -8.0).isActive = true
            divider.addConstraint(NSLayoutConstraint(item: divider, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1.0))
        }
        

        
//        divider.widthAnchor.constraint(equalTo: NSLayoutAnchor.)
        
        
        
        return subview
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let optionsViews = optionViews else { return }

        for i in 0..<optionsViews.count {
            let view = optionsViews[i]
            let selected = (view == sender.view)
            view.backgroundColor = selected ? selectedBackgroundColor : UIColor.clear
            
            
            
            //TODO: refactor into uiview subclass that always has a label and divider view
            for i in 0..<view.subviews.count {
                if let label = view.subviews[i] as? UILabel {
                    label.textColor = selected ? selectedTextColor : defaultTextColor
                }
            }
        }
        
        for i in 0..<optionsViews.count-1 {
            let dividerHidden = (optionsViews[i] == sender.view) || (optionsViews[i+1] == sender.view)
           
            for n in 0..<optionsViews[i].subviews.count {
                if let label = optionsViews[i].subviews[n] as? UILabel {
                    //do nothing because we write poopy code
                } else {
                    optionsViews[i].subviews[n].isHidden = dividerHidden
                }
            }
        }
    }
}

