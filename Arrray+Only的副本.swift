//
//  Arrray+Only.swift
//  Memorize
//
//  Created by Chaoxin Zhang on 2020/9/26.
//

import Foundation

extension Array{
    var only: Element?{
        count == 1 ? first : nil
    }
    
}
