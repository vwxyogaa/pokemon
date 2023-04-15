//
//  Collection+Ext.swift
//  pokemon
//
//  Created by yxgg on 15/04/23.
//

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
