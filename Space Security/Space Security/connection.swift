//
//  connection.swift
//  Space Security
//
//  Created by Stanislav Danilov on 20.10.2020.
//

import UIKit

class Connection: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let idCell = "MyCEll"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewConnection.delegate = self
        tableViewConnection.dataSource = self
        tableViewConnection.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: idCell)
        json{
            self.tableViewConnection.reloadData()
        }
       // Accept.layer.cornerRadius = 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell) as! MyTableViewCell
        cell.ip?.text = userData[indexPath.row].ip?.capitalized
        
        return cell
    }
    
    
    var userData = [user]()
    
    @IBOutlet weak var tableViewConnection: UITableView!
    struct user: Decodable {
        var ip: String?
        var status: String?
    }
    @IBAction func reload(_ sender: Any) {
        viewDidLoad()
    }
    func json(completed: @escaping () -> ()){
        let urlRequest = URL(string: "http://1204bce2f969.ngrok.io/alertconnetion")
        URLSession.shared.dataTask(with: urlRequest!) { (data, response, error) in
            if error == nil{
                do{
                    self.userData = try JSONDecoder().decode([user].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch {
                    print("Error")
                }
            }

        }.resume()

    }
}
