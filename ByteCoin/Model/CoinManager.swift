//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(coin: CoinModel)
    func didFailWithError(error: Error)
}
struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    //    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    //    let apiKey = "YOUR_API_KEY_HERE"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice (for currency: String) {
        
        let urlString = "https://rest.coinapi.io/v1/exchangerate/BTC/\(currency)?apikey=13D9445E-DEF1-4C39-9468-45CEF5E44ECA"
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let coin = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCoin (coin: coin)
                        
                    }
                }
            }
            
            task.resume()
        }
    }
    
    
    func parseJSON(_ coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let assetIdQuote = decodedData.assetIdQuote
            let rate = decodedData.rate
            
            let coin = CoinModel(assetIdQuote: assetIdQuote, rate: rate)
            print(coin.rate)
            return coin
            
        } catch {
            print(error)
            //                    delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}

