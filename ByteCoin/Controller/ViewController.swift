//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CoinManagerDelegate {
    
    
    var coinManager = CoinManager()
    let row = 0
 
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        coinManager.delegate = self

    }


    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        currencyLabel.text = selectedCurrency
        coinManager.getCoinPrice(for: selectedCurrency)
    
    }
    func didUpdateCoin(coin: CoinModel) {
        DispatchQueue.main.async {
            let string = String(format: "%.2f", coin.rate)
            self.bitcoinLabel.text = string
        }
    }
    
    func didFailWithError(error: any Error) {
        print(error.localizedDescription)
    }
    
    func setupUI() {
        bitcoinLabel.adjustsFontSizeToFitWidth = true
        bitcoinLabel.translatesAutoresizingMaskIntoConstraints = false
        
    }
}


