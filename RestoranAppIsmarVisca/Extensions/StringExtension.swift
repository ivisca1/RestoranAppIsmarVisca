//
//  StringExtension.swift
//  RestoranAppIsmarVisca
//
//  Created by User on 7. 6. 2023..
//

import Foundation

extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}
