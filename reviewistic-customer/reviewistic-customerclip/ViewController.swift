//
//  ViewController.swift
//  mc3-team8clip
//
//  Created by Davin Djayadi on 30/07/21.
//

import UIKit

enum RatingType{
    case price
    case product
    case service
}

class ViewController: UIViewController {
    @IBOutlet var priceBtn1: UIButton!
    @IBOutlet var priceBtn2: UIButton!
    @IBOutlet var priceBtn3: UIButton!
    @IBOutlet var priceBtn4: UIButton!
    @IBOutlet var priceBtn5: UIButton!
    @IBOutlet var productBtn1: UIButton!
    @IBOutlet var productBtn2: UIButton!
    @IBOutlet var productBtn3: UIButton!
    @IBOutlet var productBtn4: UIButton!
    @IBOutlet var productBtn5: UIButton!
    @IBOutlet var serviceBtn1: UIButton!
    @IBOutlet var serviceBtn2: UIButton!
    @IBOutlet var serviceBtn3: UIButton!
    @IBOutlet var serviceBtn4: UIButton!
    @IBOutlet var serviceBtn5: UIButton!
    @IBOutlet var kritikTextField: UITextField!
    @IBOutlet var submitBtn: UIButton!
    
    var transactionId: String!
    
    var priceRate: Int = 0
    var productRate: Int = 0
    var serviceRate: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func priceBtnTapped(_ sender: UIButton) {
        updateRating(sender: sender, ratingType: .price)
    }
    @IBAction func productBtnTapped(_ sender: UIButton) {
        updateRating(sender: sender, ratingType: .product)
    }
    @IBAction func serviceBtnTapped(_ sender: UIButton) {
        updateRating(sender: sender, ratingType: .service)
    }
    
    func updateRating(sender: UIButton, ratingType: RatingType){
        var btnList = [UIButton]()
        if ratingType == .price{
            btnList += [priceBtn1, priceBtn2, priceBtn3, priceBtn4, priceBtn5]
        }else if ratingType == .product{
            btnList += [productBtn1, productBtn2, productBtn3, productBtn4, productBtn5]
        }else if ratingType == .service{
            btnList += [serviceBtn1, serviceBtn2, serviceBtn3, serviceBtn4, serviceBtn5]
        }
        let rating = btnList.firstIndex(of: sender)! + 1
        
        if ratingType == .price{
            priceRate = rating  
        }else if ratingType == .product{
            productRate = rating
        }else if ratingType == .service{
            serviceRate = rating
        }
        btnList.enumerated().forEach{
            let image = UIImage(systemName: $0.offset < rating ? "star.fill" : "star")
            $0.element.setBackgroundImage(image, for: .normal)
        }
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        let isRateValid = priceRate * productRate * serviceRate > 0
        let isKritikValid = !kritikTextField.text!.isEmpty
        
        if !isRateValid{
            showAlert(title: "Empty rating!", message: "Please give a rating to each category")
            return
        }
        
        if !isKritikValid{
            showAlert(title: "Empty feedback!", message: "Please fill feedback section")
            return
        }
        
        let airTableId: String = self.transactionId
        
        TransactionModel.updateReviewInsert(transactionId: airTableId,
                                            review: kritikTextField.text!,
                                            ratingPrice: priceRate,
                                            ratingService: serviceRate,
                                            ratingProduct: productRate)
        { [self] isSuccess in
            if isSuccess{
                showSuccessAlert(title: "Success", message: "Voucher will be sent to your email!"){
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "succ")
                    self.present(vc, animated: true)
                }
            }else{
                showAlert(title: "Unknown Error!", message: "Please try again!")
            }
        }
        
    }
    
    func showAlert(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(ac, animated: true)
    }
    
    func showSuccessAlert(title: String, message: String, callback: @escaping (()->Void) = {}){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Done", style: .default){ _ in
            callback()
        })
        self.present(ac, animated: true)
    }
}

