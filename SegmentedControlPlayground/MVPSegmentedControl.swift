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
        selectedTextColor = UIColor.black
        defaultTextColor = UIColor.white
        selectedBackgroundColor = UIColor.orange
        
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5
        clipsToBounds = true
        backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
        self.options = ["Male", "Female"]
        
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
            let subview = createSubview(withText: options[i])
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            subview.addGestureRecognizer(tap)
            
            addSubview(subview)

            optionViews!.append(subview)
        }
        
        addConstraints()
    }
    
    private func applyDefaultStyles() {

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
    
    private func createSubview(withText text: String) -> UIView {
    
        //subview
        let subview = UIView()
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.clipsToBounds = true
        subview.layer.cornerRadius = 5
        
        //label
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = defaultTextColor
        
        subview.addSubview(label)
        
        label.centerXAnchor.constraint(equalTo: subview.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: subview.centerYAnchor).isActive = true

        return subview
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let optionsViews = optionViews else { return }

        optionsViews.forEach { view in
            let selected = (view == sender.view)
            let backgroundColor = selected ? selectedBackgroundColor : UIColor.clear
            view.backgroundColor = backgroundColor
            
            //TODO: refactor into uiview subclass that always has a label
            view.subviews.forEach { possibleLabel in
                if let label = possibleLabel as? UILabel {
                    label.textColor = selected ? selectedTextColor : defaultTextColor
                }
            }
        }
    }
    

    
    
}

