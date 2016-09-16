//
//  CardsViewModel.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/25/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit

final class CardsViewModel {
    
    var cards = [Card]() {
        didSet{
            noDataLabel.hidden = true
        }
    }
    
    var noDataLabel: UILabel = UILabel()

    
    
    func fetchCards(completion: () -> Void) {
        Card.fetchCards({ 
            completion()
            }) { (card) in
                self.cards.append(card)
                completion()
        }
        
    }
    
}
