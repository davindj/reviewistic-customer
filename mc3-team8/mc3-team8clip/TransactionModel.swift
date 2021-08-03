//
//  TransactionModel.swift
//  mc3-team8clip
//
//  Created by Davin Djayadi on 03/08/21.
//

import Foundation

class TransactionModel {
    static func updateReviewInsert(airtableid:String,
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
        let url = URL(string: "https://api.airtable.com/v0/appP7dMHeW4puOorW/Review/"+airtableid+"?api_key=keys9Q3knWNrVr89B")!
        
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
