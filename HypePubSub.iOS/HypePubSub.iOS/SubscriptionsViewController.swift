
import Foundation
import UIKit
import NotificationCenter


class SubscriptionsViewController: UITableViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let nc = NotificationCenter.default // Note that default is now a property, not a method call
        nc.addObserver(forName:Notification.Name(rawValue:"refreshSubscriptionsViewController"),
                       object:nil, queue:nil) {
                        notification in
                        self.refreshSubscriptions()
        }
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HypePubSub.getInstance().ownSubscriptions.count()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let subscription = HypePubSub.getInstance().ownSubscriptions.get(indexPath.row)
        cell.textLabel?.text = subscription?.serviceName
        return cell
    }
    
    func refreshSubscriptions()
    {
        self.tableView.reloadData()
    }
    
}
