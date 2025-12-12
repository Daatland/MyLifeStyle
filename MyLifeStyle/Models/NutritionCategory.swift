//
//  NutritionCategory.swift
//  MyLifeStyle
//
//  Created by Marcus Olsen Daatland on 01/10/2025.
//

import Foundation

enum NutritionCategory: String, CaseIterable, Identifiable, Codable {
    case frokost = "Frokost"
    case lunsj = "Lunsj"
    case middag = "Middag"
    case kvelds = "Kvelds"
    case snakcs = "snacks"
    
    var id: String { self.rawValue }
}
