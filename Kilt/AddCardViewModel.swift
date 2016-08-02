//
//  AddCardViewModel.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 8/3/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import Foundation

final class AddCardViewModel {

    func saveWithName(name: String?, icon: String?) {
        let company = Company(name: name, icon: icon)
        company.save()
    }
    
}
