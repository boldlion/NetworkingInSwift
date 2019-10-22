//
//  ViewController.swift
//  NetworkingInSwift
//
//  Created by Bold Lion on 21.10.19.
//  Copyright © 2019 Bold Lion. All rights reserved.
//

import UIKit

class RequestVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNetworkingRequest()
    }
    
    func setNetworkingRequest() {
        // Construct a URL by assigning its parts to a URLComponents value
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/users/boldlion"
        
        // This gives us the constructed URL
        guard let url = components.url else { fatalError() }
        
        // Use the constructed URL to perform a network request
        let _ = URLSession.shared.dataTask(with: url) { data, response, error in
            
            /* The URLSession will send 3 arguments:
             1. data = this will contain the bytes that were downloaded OR it will be nil if an error occurred
             2. response = a representation of the response that was received (contains information like MIME type and encoding of the downloaded data, can be type casted to HTTPURLResponse if we'd like to get more specific info like the status code)
             3. error = any error that might have occurred OR its nil if there's no erro
             */
            
            DispatchQueue.main.async { [unowned self] in
                if let data = data {
                    do {
                        if  let jsonResponseDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            let user = UserModel.transformJson(dict: jsonResponseDict)
                            self.updateUI(user: user)
                        }
                    }
                    catch let parsingError {
                        self.showAlert(message: parsingError.localizedDescription)
                    }
                }
                else {
                    guard let dataError = error else { return }
                    self.showAlert(message: dataError.localizedDescription)
                }
            }
        }.resume()
    }
    
    func updateUI(user: UserModel) {
        guard let name = user.name else { return }
        guard let username = user.login else { return }
        guard let bio = user.bio else { return }
        guard let location = user.location else { return }
        guard let avatarStringUrl = user.avatar_url else { return }
        
        nameLabel.text = name
        usernameLabel.text = username
        locationLabel.text = location
        bioLabel.text = bio
        
        if let url = URL(string: avatarStringUrl) {
            do {
                let imageData = try Data(contentsOf: url)
                imageView.image = UIImage(data: imageData)
            }
            catch let error {
                showAlert(message: error.localizedDescription)
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
}

