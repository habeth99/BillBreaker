//
//  Bill.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/25/24.
//

import Foundation

// class to represent a bill and store its data
// each bill needs a unique sharecode so other people can join a bill to be broken up

class Bill: ObservableObject{
    var shareCode: Int = 0
}
