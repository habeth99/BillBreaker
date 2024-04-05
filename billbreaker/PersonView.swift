//
//  PersonView.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/5/24.
//

import Foundation
import SwiftUI

struct PersonView: View {
    let person: Person

    var body: some View {
        VStack(alignment: .leading) {
            Text(person.name).font(.headline)
        }
        .frame(width: 346, height: 175)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 1)
    }
}
