//
//  TransactionModel.swift
//  mc3-team8clip
//
//  Created by Davin Djayadi on 03/08/21.
//

import Foundation

class TransactionModel {
    static var AIRTABLE_URL: String { // ex: https://api.airtable.com/v0/jassDK12DDsda
        ProcessInfo.processInfo.environment["AIRTABLE_URL"]!
    }
    static var AIRTABLE_API_KEY: String { // ex: keys7A1poLWvQm10A
        ProcessInfo.processInfo.environment["AIRTABLE_API_KEY"]!
    }
    
    static func updateReviewInsert(transactionId:String,
                                   review:String,
                                   ratingPrice:Int,
                                   ratingService:Int,
                                   ratingProduct:Int,
                                   response: @escaping (Bool)->Void ) {
        let json = [
            "fields": [
                "status": 2,
                "RatingPrice": ratingPrice,
                "RatingService": ratingService,
                "RatingProduk": ratingProduct,
                "Review": review
            ]
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        let urlString = "\(AIRTABLE_URL)/Transaksi/\(transactionId)?api_key=\(AIRTABLE_API_KEY)"
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        // insert json data to the request
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard data != nil else {
                print("fail1")
                return
            }
            do {
                DispatchQueue.main.async {
                    response(true)
                }
            }
            
        }
        task.resume()
    }
}
