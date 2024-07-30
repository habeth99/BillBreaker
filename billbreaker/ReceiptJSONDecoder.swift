//
//  ReceiptJSONDecoder.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/29/24.
//

import Foundation

extension JSONDecoder {
    func decodeReceipt(from data: Data) -> Receipt? {
        if let apiReceipt = try? self.decode(APIReceipt.self, from: data) {
            return Receipt.from(apiReceipt: apiReceipt)
        } else if let receipt = try? self.decode(Receipt.self, from: data) {
            return receipt
        }
        return nil
    }
}
