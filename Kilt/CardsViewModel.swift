//
//  CardsViewModel.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/25/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit

final class CardsViewModel {
    
    var cards = [Card]()
    
    func fetchCards(completion: (card: Card) -> Void) {
        Card.fetchCards { card in
            self.cards.append(card)
            completion(card: card)
        }
    }
    
}
