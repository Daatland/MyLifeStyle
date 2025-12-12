//
//  Nutrition.swift
//  MyLifeStyle
//
//  Created by Marcus Olsen Daatland on 01/10/2025.
//

import Foundation
import SwiftData

@Model

class Nutrition {
    var category: NutritionCategory
    var food: String
    var calories: Int
    var date: Date
    
    init(
        category: NutritionCategory,
        food: String,
        calories: Int,
        date: Date = Date()
    ) {
        
        self.category = category
        self.food = food
        self.calories = calories
        self.date = date
    }
}
    
    
    

