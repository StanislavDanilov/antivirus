//
//  History.swift
//  Space Security
//
//  Created by Stanislav Danilov on 20.10.2020.
//

import UIKit

class History: UITableViewCell {
    @IBOutlet weak var back: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var resault: UILabel!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
