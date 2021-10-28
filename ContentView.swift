//
//  ContentView.swift
//  SetGame
//
//  Created by Chaoxin Zhang on 2021/1/10.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: SetGameViewModel
    @State var showRule: Bool = false
    
    var body: some View {
        HStack {
            Spacer()
            Text("得分: \(self.viewModel.showScore())").font(.title).fontWeight(.bold)
            Spacer()
            Button(action: {
                self.showRule = true
            }, label: {Image(systemName: "pause.fill")})
            Spacer()
        }
        Grid(viewModel.showingCards){ card in
            CardView(card: card)
                .onTapGesture{
                    withAnimation(.linear(duration: 0.75)){
                        self.viewModel.choose(card: card)
                    }
                }
            .padding(5)
        }
        .sheet(isPresented: $showRule, content:{
            ScrollView(content: {
                Text("规则").font(.title)
                Divider()
                Text("三个卡牌为一组, 元素(形状、颜色、数量)分别全部相同或者全部不同\n\n☐ + ☐ + ☐ = ✅\n☐ + ❖ + ❃ = ✅\n☐ + ☐ + ❃ = ❌\n\n1 + 1 + 1 = ✅\n1 + 2 + 3 = ✅\n1 + 1 + 2 = ❌\n\n红 + 红 + 红 = ✅\n红 + 绿 + 蓝 = ✅\n红 + 红 + 蓝 = ❌\n\n☐ + ☐☐ + ☐☐☐ = ✅\n☐ + ❖❖ + ❃❃❃ = ✅\n☐ + ❖❖ + ❖❖❖ = ❌").font(.body).fontWeight(.light).multilineTextAlignment(.center).foregroundColor(.black)
            })
            .frame(height: 500)
            .onTapGesture {
                self.showRule = false
            }
        })
        .padding()
        .foregroundColor(Color.orange)
        .font(Font.largeTitle)
        HStack{
            Button(action: {
                    withAnimation(.easeInOut(duration: 2) , {
                            self.viewModel.newGame()
                    })
            }, label: {Text("重新开始游戏")})
        }
    }
}

struct CardView: View{
    var card: SetGameModel<String>.Card

    var body: some View {
        GeometryReader{geometry in
            self.body(for: geometry.size)
        }
    }
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startedBonusTimeAnimation(){
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)){
            animatedBonusRemaining = 0
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View{
        let mixContent = String.init(repeating: card.content, count: card.amountOfContent)
        if !card.isDeleted && !card.isMatched{
            ZStack{
                Group{
                    if card.isConsumingBonusTime{
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90)).colorInvert().padding(5).opacity(0.4)
                            .onAppear{
                                self.startedBonusTimeAnimation()
                            }
                    }else{
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90)).padding(5).opacity(0.4)
                    }
                }
                .padding(5).opacity(0.4)
                .transition(.scale)
                Text(mixContent)
                    .font(Font.system(size: fontSize(for: size)))
                    .cardify(color: card.colorId)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0 ))
                    .animation(card.isChosen ? Animation.linear(duration: 0.5).repeatForever(autoreverses: false) : .default)
            }
            .cardify(isChosen: card.isChosen)
            .transition(AnyTransition.scale(scale: 0))
        }
    }
    //MATK: -Drawing Constants
    
    private let fontScaleFactor: CGFloat = 0.4
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height)*self.fontScaleFactor
    }
}







