//
//  SetGameModel.swift
//  SetGame
//
//  Created by Chaoxin Zhang on 2021/1/11.
//

import Foundation

struct SetGameModel<CardContent: Equatable>{
    private(set) var cards: Array<Card>
    private(set) var score: Int = 0
    private var chosenCardsIndex = Array<Int>()

    init(numbersOfCardContent: Int, cardContentFactory: (Int) -> CardContent) {
        self.cards = Array<Card>()
        var cardIndex = 0
        for index in 0..<numbersOfCardContent{
            let content = cardContentFactory(index)
            for color in 0..<3{
                for number in 0..<3{
                    self.cards.append(Card(id: cardIndex*3+number, isChosen: false, isMatched: false, isDeleted: false, content: content, contentId: index, colorId: color, amountOfContent: 1+number))
                }
                cardIndex += 1
            }
        }
        cards.shuffle()
    }
    
    mutating func choose(card: Card) {
        //not nil, these code will be executed
        if let chosenIndex = cards.firstIndex(matching: card),!cards[chosenIndex].isMatched{
            if chosenCardsIndex.firstIndex(of: chosenIndex) == nil{
                cards[chosenIndex].isChosen = true
                chosenCardsIndex.append(chosenIndex)
                if chosenCardsIndex.count == 3 {
                    var sumOfNumbersOfContent = 0
                    var sumOfColorId = 0
                    var sumOfContentId = 0
                    for index in chosenCardsIndex.indices{
                        sumOfNumbersOfContent += cards[chosenCardsIndex[index]].numbersOfContent
                        sumOfColorId += cards[chosenCardsIndex[index]].colorId
                        sumOfContentId += cards[chosenCardsIndex[index]].contentId
                    }
                    
                    if (sumOfContentId % 3 == 0) && (sumOfNumbersOfContent % 3 == 0) && (sumOfColorId % 3 == 0) {
                        for index in chosenCardsIndex{
                            cards[index].isMatched = true
                        }
                        score += 2
                    }else{
                        //不匹配, 删掉(伪)
                        for index in chosenCardsIndex{
                            cards[index].isDeleted = true
                        }
                        if score != 0 {
                            score -= 1
                        }
                    }
                    chosenCardsIndex.removeAll()
                }
            }else{
                //取消选定
                cards[chosenIndex].isChosen = false
                chosenCardsIndex.remove(at: chosenCardsIndex.firstIndex(of: chosenIndex)!)
            }
        }
    }
    
struct Card:Identifiable {
        var id:Int
        var isChosen:Bool
        var isMatched:Bool
        var isDeleted: Bool
        var content: CardContent //I don't care the type
        var contentId: Int
        var colorId: Int
        var numbersOfContent: Int

//MAR: - Bonus Time

// this could give matching bonus points
// if the user matches the card
// before a certain amount of time passes during which the card is face up

// can be zero which means  "no bonus avaiable" for this card
    var bonusTimeLimit: TimeInterval = 6

    //how long this card has ever been face up
    private var faceUpTime: TimeInterval{
        if let lastFaceUpDate = self.lastFaceUpDate{
            return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
        } else{
            return pastFaceUpTime
        }
    }

    //the last time
    var lastFaceUpDate: Date?
    //the accumulated time this card has been face up in the past
    // (i.e. not including the current time it's been face up if it is currently so)
    var pastFaceUpTime: TimeInterval = 0
     
    //how much time left before the bonus opportunity runs out
    var bonusTimeRemaining: TimeInterval {
        max(0, bonusTimeLimit - faceUpTime)
    }
    //percentage of the bonus time remaining
    var bonusRemaining: Double {
        (bonusTimeLimit > 0 && self.bonusTimeRemaining > 0 ) ? bonusTimeRemaining/bonusTimeLimit : 0
    }

    //whether the card was matched during the bonus time period
    var hasEarnedBonus: Bool {
        isMatched && bonusTimeRemaining > 0
    }
    //whether we are currently face up, unmatched and have not yet used up the bonus window
    var isConsumingBonusTime: Bool {
        isChosen && !isMatched && bonusTimeRemaining > 0
    }
    //called when the card transtions to face up state
    private mutating func startUsingBonusTime(){
        if isConsumingBonusTime, lastFaceUpDate == nil {
            lastFaceUpDate = Date()
        }
    }
    //called when the card goes back face down (or gets matched)
    private mutating func stopUsingBonusTime(){
        pastFaceUpTime = faceUpTime
        self.lastFaceUpDate = nil
    }
}
}
