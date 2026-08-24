//
//  Array+Extensions.swift
//  ImageFeed
//
//  Created by Sabrina Mavlyanova on 24/08/26.
//

extension Array {
    func withReplaced(itemAt index: Int, newValue: Element) -> [Element] {
        var newArray = self
        newArray[index] = newValue
        return newArray
    }
}
