//
//  PeopleSectionView.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/3/24.
//

import Foundation
import SwiftUI

struct PeopleSectionView: View {
    @ObservedObject var rviewModel: ReceiptViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("People")
                .padding(EdgeInsets(top: 25, leading: 0, bottom: -1, trailing: 0))
                .fontWeight(.bold)
                .font(.title)
            
            ForEach(rviewModel.receipt.people ?? [], id: \.id) { person in
                BillDetailsPersonView(rviewModel: rviewModel, person: person, isSelected: rviewModel.selectedPerson?.id == person.id)
                    .onTapGesture {
                        rviewModel.selectPerson(person)
                    }
            }
        }
    }
}

