//
//  APIService.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/29/24.
//

import Foundation

class APIService {
    static let shared = APIService()
    private init() {}
    
    func sendExtractedTextToAPI(extractedText: String) async throws -> APIReceipt {
        guard let url = URL(string: "https://fatcheck.vmgm.xyz/process-receipt") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["text": extractedText]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await URLSession.shared.data(for: request)
        
        let jsonDecoder = JSONDecoder()
        let apiReceipt = try jsonDecoder.decode(APIReceipt.self, from: data)
        
        return apiReceipt
    }
}
