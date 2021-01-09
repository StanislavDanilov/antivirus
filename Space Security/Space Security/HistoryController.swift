//
//  HistoryController.swift
//  Space Security
//
//  Created by Stanislav Danilov on 20.10.2020.
//

import UIKit

class HistoryController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var TableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    @IBAction func update(_ sender: Any) {
        viewDidLoad()
    }
    let urlSpace : String = "http://ff16a29e36e6.ngrok.io"

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell) as! History
        cell.name?.text = userData[indexPath.row].filename?.capitalized
        cell.resault?.text = userData[indexPath.row].result?.capitalized
        var rez = cell.resault?.text
        if rez == "No Virus"{
            cell.back.backgroundColor = .green
        }else{
            cell.back.backgroundColor = .red
        }
        return cell
    }
    
    let idCell = "MeCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.delegate = self
        TableView.dataSource = self
        TableView.register(UINib(nibName: "History", bundle: nil), forCellReuseIdentifier: idCell)
        json{
            self.tableViewConnection.reloadData()
        }
    }
    
    var userData = [user]()
    
    @IBOutlet weak var tableViewConnection: UITableView!
    struct user: Decodable {
        var filename: String?
        var result: String?
    }
    @IBAction func reload(_ sender: Any) {
        viewDidLoad()
    }
    func json(completed: @escaping () -> ()){
        let urlRequest = URL(string: "http://ff16a29e36e6.ngrok.io/history")
        URLSession.shared.dataTask(with: urlRequest!) { (data, response, error) in
            if error == nil{
                do{
                    self.userData = try JSONDecoder().decode([user].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                        print(self.userData)
                    }
                }catch {
                    print("Error")
                }
            }

        }.resume()

    }

   

}
