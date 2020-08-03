import UIKit
import Alamofire
import SwiftyJSON

public class ListViewController: UIViewController {
    var cellname = "cell"
    var tableData:[ListModel] = [ListModel]()
    @IBOutlet weak var table: UITableView!
    
    
    public override func viewDidLoad() {
        table.delegate = self
        table.dataSource = self
        tableData = [ListModel]()
        let userlist = "https://api.github.com/users?page=1&per_page=100"
        do{
            try Alamofire.request(userlist.asURL()).responseJSON(completionHandler: { (response) in
                if response.result.isSuccess{
                    if let result = response.value{
                        //print(result)
                        if let a = result as? [[String: Any]] {
                            for index in 0..<a.count{
                                let model = ListModel()
                                if let login = a[index]["login"] as? String,
                                    let avatar_url = a[index]["avatar_url"] as? String,
                                    let site_admin = a[index]["site_admin"] as? Int32{
                                    let model = ListModel()
                                    model.username = login
                                    model.userimageurl = avatar_url
                                    model.staff = site_admin == 1 ? true : false
                                    self.tableData.append(model)
                                }
                            }
                        }
                    }

                }else{

                }
                DispatchQueue.main.async() {
                    self.table.reloadData()
                }
            })
        } catch (let writeError) {

        }
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: cellname, for: indexPath) as! ListViewCell
        let index = indexPath.section
        cell.username.text = tableData[index].username
        if let nsurl = NSURL(string: tableData[index].userimageurl),
            let url = nsurl.absoluteURL{
            cell.userimage.download(url: url)
        }else{
            cell.userimage.isHidden = true
        }
        
        cell.staff.isHidden = !tableData[index].staff
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        nil
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }
}
