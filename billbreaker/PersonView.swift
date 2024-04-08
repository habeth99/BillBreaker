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
        .frame(width: 360, height: 175)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 1)
    }
}
