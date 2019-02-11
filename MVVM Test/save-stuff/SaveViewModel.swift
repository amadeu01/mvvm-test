//
//  SaveStuff.swift
//  MVVM Test
//
//  Created by Amadeu Cavalcante Filho on 11/02/19.
//  Copyright © 2019 Amadeu Cavalcante Filho. All rights reserved.
//

import Foundation

typealias Handler = () -> Void

final class SaveViewModel {
    
    var stuffSaved: Handler? = nil
    var savingStuff: Handler? = nil
    
    @objc func save() {
        savingStuff?()
        DispatchQueue.global().async {
            sleep(5)
            DispatchQueue.main.async {
                self.stuffSaved?()
            }
        }
    }
}
