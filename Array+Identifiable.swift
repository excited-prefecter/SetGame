//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by *** on 2020/9/25.
//

import Foundation

extension Array where Element: Identifiable{
    func firstIndex(matching : Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        return nil
    }
    func secondIndex(matching : Element) -> Int? {
        var temp:Int = 0
        for index in 0..<self.count {
            if self[index].id == matching.id {
                temp += 1
                if temp == 2{
                    return index
                }
            }
        }
        return nil
    }
}
