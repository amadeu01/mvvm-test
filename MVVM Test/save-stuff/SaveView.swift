//
//  SaveView.swift
//  MVVM Test
//
//  Created by Amadeu Cavalcante Filho on 11/02/19.
//  Copyright © 2019 Amadeu Cavalcante Filho. All rights reserved.
//

import UIKit

class SaveView: NiblessView {
    
    // MARK: - Properties
    let viewModel: SaveViewModel
    
    var hierarchyNotReady = true
    var bottomLayoutConstraint: NSLayoutConstraint?
    
    let scrollView: UIScrollView = UIScrollView()
    let contentView: UIView = UIView()
    
    lazy var inputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [saveInputStack])
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    lazy var saveInputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [saveTextInputField])
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()
    
    let saveTextInputField: UITextField = {
        let field = UITextField()
        field.placeholder = "Type any test here"
        field.textColor = .white
        field.backgroundColor = .gray
        field.autocapitalizationType = .none
        field.minimumFontSize = 16
        field.autocorrectionType = .no
        field.height(constant: 100)
        return field
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Save stuff", for: .normal)
        button.setTitle("", for: .disabled)
        button.backgroundColor = .red
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()
    
    let savingActivityIndicator: UIActivityIndicatorView  = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Methods
    init(frame: CGRect = .zero,
         viewModel: SaveViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        viewModel.savingStuff = {
            self.savingActivityIndicator.startAnimating()
            self.backgroundColor = .lightGray
        }
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady else {
            return
        }
        backgroundColor = .white
        constructHierarchy()
        activateConstraints()
        wireController()
        hierarchyNotReady = false
    }
    
    func constructHierarchy() {
        scrollView.addSubview(contentView)
        contentView.addSubview(inputStack)
        contentView.addSubview(saveButton)
        saveButton.addSubview(savingActivityIndicator)
        addSubview(scrollView)
    }
    
    func activateConstraints() {
        activateConstraintsScrollView()
        activateConstraintsContentView()
        activateConstraintsInputStack()
        activateConstraintsSignInButton()
        activateConstraintsSignInActivityIndicator()
    }
    
    func wireController() {
        saveButton.addTarget(viewModel,
                               action: #selector(SaveViewModel.save),
                               for: .touchUpInside)
    }
    
    func configureViewAfterLayout() {
        resetScrollViewContentInset()
    }
    
    func resetScrollViewContentInset() {
        let scrollViewBounds = scrollView.bounds
        let contentViewHeight = CGFloat(180.0)
        
        var scrollViewInsets = UIEdgeInsets.zero
        scrollViewInsets.top = scrollViewBounds.size.height / 2.0;
        scrollViewInsets.top -= contentViewHeight / 2.0;
        
        scrollViewInsets.bottom = scrollViewBounds.size.height / 2.0
        scrollViewInsets.bottom -= contentViewHeight / 2.0
        
        scrollView.contentInset = scrollViewInsets
    }
    
    func moveContentForDismissedKeyboard() {
        resetScrollViewContentInset()
    }
    
    func moveContent(forKeyboardFrame keyboardFrame: CGRect) {
        var insets = scrollView.contentInset
        insets.bottom = keyboardFrame.height
        scrollView.contentInset = insets
    }
}

// MARK: - Layout
extension SaveView {
    
    func activateConstraintsScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let leading = scrollView.leadingAnchor
            .constraint(equalTo: layoutMarginsGuide.leadingAnchor)
        let trailing = scrollView.trailingAnchor
            .constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        let top = scrollView.topAnchor
            .constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        let bottom = scrollView.bottomAnchor
            .constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate(
            [leading, trailing, top, bottom])
    }
    
    func activateConstraintsContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let width = contentView.widthAnchor
            .constraint(equalTo: scrollView.widthAnchor)
        let leading = contentView.leadingAnchor
            .constraint(equalTo: scrollView.leadingAnchor)
        let trailing = contentView.trailingAnchor
            .constraint(equalTo: scrollView.trailingAnchor)
        let top = contentView.topAnchor
            .constraint(equalTo: scrollView.topAnchor)
        let bottom = contentView.bottomAnchor
            .constraint(equalTo: scrollView.bottomAnchor)
        NSLayoutConstraint.activate(
            [width, leading, trailing, top, bottom])
    }
    
    func activateConstraintsInputStack() {
        inputStack.translatesAutoresizingMaskIntoConstraints = false
        let leading = inputStack.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor)
        let trailing = inputStack.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor)
        let top = inputStack.topAnchor
            .constraint(equalTo: contentView.topAnchor)
        NSLayoutConstraint.activate(
            [leading, trailing, top])
    }
    
    func activateConstraintsSignInButton() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        let leading = saveButton.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor)
        let trailing = saveButton.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor)
        let top = saveButton.topAnchor
            .constraint(equalTo: inputStack.bottomAnchor, constant: 20)
        let bottom = contentView.bottomAnchor
            .constraint(equalTo: saveButton.bottomAnchor, constant: 20)
        let height = saveButton.heightAnchor
            .constraint(equalToConstant: 50)
        NSLayoutConstraint.activate(
            [leading, trailing, top, bottom, height])
    }
    
    func activateConstraintsSignInActivityIndicator() {
        savingActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let centerX = savingActivityIndicator.centerXAnchor
            .constraint(equalTo: saveButton.centerXAnchor)
        let centerY = savingActivityIndicator.centerYAnchor
            .constraint(equalTo: saveButton.centerYAnchor)
        NSLayoutConstraint.activate(
            [centerX, centerY])
    }
}

extension UIView {
    func height(constant: CGFloat) {
        setConstraint(value: constant, attribute: .height)
    }
    
    func width(constant: CGFloat) {
        setConstraint(value: constant, attribute: .width)
    }
    
    private func removeConstraint(attribute: NSLayoutConstraint.Attribute) {
        constraints.forEach {
            if $0.firstAttribute == attribute {
                removeConstraint($0)
            }
        }
    }
    
    private func setConstraint(value: CGFloat, attribute: NSLayoutConstraint.Attribute) {
        removeConstraint(attribute: attribute)
        let constraint =
            NSLayoutConstraint(item: self,
                               attribute: attribute,
                               relatedBy: NSLayoutConstraint.Relation.equal,
                               toItem: nil,
                               attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                               multiplier: 1,
                               constant: value)
        self.addConstraint(constraint)
    }
}
