//
//  ImagePopoverViewController.swift
//  Assignment2
//
//  Created by Anam on 07/04/2019.
//  Copyright © 2019 Anam Khan. All rights reserved.
//

import UIKit

class ImagePopoverViewController: UIViewController {
    var url : String! = nil
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    
    func showActivityIndicator (show : Bool){
        if show {
            ActivityIndicator.startAnimating()
        }
        else{
            ActivityIndicator.stopAnimating()
            ActivityIndicator.hidesWhenStopped = true
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.layer.cornerRadius = 20
        showActivityIndicator(show: true)
        let sharedSession = URLSession.shared
        if let url = URL(string: url) {
            // Create Request
            if (url != nil){
                let request = URLRequest(url: url)
                let dataTask = sharedSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.imageView.image = image
                            self.showActivityIndicator(show: false)
                        }
                    }
                })
                dataTask.resume()
            }
            else{
                self.imageView.image = UIImage(named: "defaultImage")
                showActivityIndicator(show: false)
            }
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
