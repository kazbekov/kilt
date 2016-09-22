//
//  RequestsViewModel.swift
//  Kilt
//
//  Created by Dias Dosymbaev on 9/20/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit

final class RequestsViewModel {
    var requests = [Request]()

    func fetchRequests(completion: ()-> Void) {
        Request.fetchRequests { (snapshot) in
            if Request(snapshot: snapshot, childChanged:  completion).companyIsVerified == true {
                self.requests.append(Request(snapshot: snapshot, childChanged: completion))
            }
            completion()
        }
    }
}
