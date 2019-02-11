//
//  SaveStuffViewController.swift
//  MVVM Test
//
//  Created by Amadeu Cavalcante Filho on 11/02/19.
//  Copyright © 2019 Amadeu Cavalcante Filho. All rights reserved.
//

import UIKit

class SaveStuffViewController: NiblessViewController {
    let viewModel: SaveViewModel
    weak var coordinator: AppCoordinator?
    
    public init(viewModel: SaveViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        self.view = SaveView(viewModel: viewModel)
        
        viewModel.stuffSaved = {
            self.coordinator?.stuffSaved()
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        (view as! SaveView).configureViewAfterLayout()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
}

extension SaveStuffViewController {
    func addKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleContentUnderKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleContentUnderKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func removeObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    @objc func handleContentUnderKeyboard(notification: Notification) {
        if let userInfo = notification.userInfo,
            let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let convertedKeyboardEndFrame = view.convert(keyboardEndFrame.cgRectValue, from: view.window)
            if notification.name == UIResponder.keyboardWillHideNotification {
                (view as! SaveView).moveContentForDismissedKeyboard()
            } else {
                (view as! SaveView).moveContent(forKeyboardFrame: convertedKeyboardEndFrame)
            }
        }
    }
}
