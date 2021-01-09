//
//  MyTableViewCell.swift
//  Space Security
//
//  Created by Stanislav Danilov on 20.10.2020.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var Accept: UIButton!
    @IBOutlet weak var ip: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func SendRequest(_ sender: Any) {
        let status = "true"
        var ipAccess:String = ip.text!
        let url = URL(string: "http://b26cfe3a04ac.ngrok.io/requestiphone?ip=\(ipAccess)&status=\(status)")!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }

        task.resume()
    
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
