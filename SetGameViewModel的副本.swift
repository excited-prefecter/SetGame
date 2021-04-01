//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by Chaoxin Zhang on 2021/1/11.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    @Published private var model:SetGameModel = SetGameViewModel.creatSetGame()
    
    private static func creatSetGame() -> SetGameModel<String> {
        let shapes: [String] = ["☐","❖","❃"]
        return SetGameModel<String>(amountOfContent: shapes.count, cardContentFactory:  {index in shapes[index]})
    }
    
    var showingCards: Array<SetGameModel<String>.Card> {
        return model.cards.filter({!$0.isDeleted && !$0.isMatched}).count > 12 ? Array(model.cards.filter({!$0.isDeleted && !$0.isMatched}).prefix(upTo: 12)): Array(model.cards.filter({!$0.isDeleted && !$0.isMatched}))
    }
    
    func newGame(){
        self.model = SetGameViewModel.creatSetGame()
    }
    
    func choose(card: SetGameModel<String>.Card){
        model.choose(card: card)
    }
    
    func showScore() -> Int {
        return model.score
    }
}
