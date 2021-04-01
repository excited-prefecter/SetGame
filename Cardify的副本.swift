//
//  Cardify.swift
//
//
//  Created by Chaoxin Zhang on 2021/1/6.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    var rotation: Double
    
    var isChosen: Bool{
        rotation < 90
    }
    
    init(isChosen: Bool) {
        rotation = isChosen ? 0 : 180
    }
    
    var animatableData: Double{
        get{return rotation}
        set{rotation = newValue}
    }
    
    func body(content: Content) -> some View{
        ZStack{
            Group{
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                content
            }
                .opacity(1)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0,1,0))
    }
    
    private let cornerRadius: CGFloat = 10.0
    private let edgeLineWidth: CGFloat = 3

}

extension View{
    func cardify(isChosen: Bool) -> some View {
        return self.modifier(Cardify(isChosen: isChosen))
    }
    
    func cardify(color: Int!) -> some View {
        if color > 2 || color < 0 {
            return self.foregroundColor(Color(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)))
        }else{
            let colors:[UIColor] = [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)]
            return self.foregroundColor(Color(colors[color]))
        }
    }
}
