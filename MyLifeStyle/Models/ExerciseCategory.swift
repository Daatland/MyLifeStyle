//
//  ExerciseCategory.swift
//  MyLifeStyle
//
//  Created by Marcus Olsen Daatland on 25/09/2025.
//

import Foundation

enum ExerciseCategory: String, CaseIterable, Identifiable {
    case strength = "Styrke"
    case cardio = "Kardio"
    case yoga = "Yoga"
    case mobility = "Mobilität"
    case swimming = "Svømming"
    
    
    var id: String {self.rawValue}
}
