import Foundation
import SwiftData

@Model
class Exercise {
    var name: String
    var minutes: Int
    var intensity: Int
    var date = Date()
    var duration: Int {
        get { minutes }
        set { minutes = newValue }
    }

    
    
    var categoryRaw: String = ExerciseCategory.strength.rawValue
    
    var category: ExerciseCategory {
        get { ExerciseCategory(rawValue: categoryRaw) ?? .strength }
        set { categoryRaw = newValue.rawValue }
    }
    
    init(name: String, minutes: Int, intensity: Int, category: ExerciseCategory, date: Date) {
        self.name = name
        self.minutes = minutes
        self.intensity = intensity
        self.categoryRaw = category.rawValue
        self.date = date
    }
}
