//
//  AddCardViewModel.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 8/3/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit

final class AddCardViewModel {

    func createCompanyWithName(name: String?, icon: UIImage?, completion: (errorMessage: String?) -> Void) {
        let company = Company(key: nil, name: name, icon: nil)
        company.saveName { completion(errorMessage: $0?.localizedDescription) }
    }
    
}
