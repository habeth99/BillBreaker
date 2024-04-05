//
//  User.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/25/24.
//

import Foundation
import SwiftUI
// class to create user objects and store their data
struct Person: Identifiable, Hashable {
    let id = UUID() // Unique identifier for each person
    let name: String
    // Add other properties here, such as duration and calories
}
