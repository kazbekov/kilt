//
//  CompaniesViewModel.swift
//  Kilt
//
//  Created by Otel Danagul on 07.09.16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit

final class CompaniesViewModel {
    var companies = [Company]()
    
    func fetchCompanies(completion: ()-> Void) {
        Company.fetchCompanies { (snapshot) in
            self.companies.append(Company(snapshot: snapshot, childChanged: completion))
            completion()
        }
    }

}
