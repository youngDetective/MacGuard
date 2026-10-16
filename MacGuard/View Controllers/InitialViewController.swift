//
//  InitialViewController.swift
//  totpVerifier
//
//  Created by Jithin Renny Mathew on 22/03/26.
//

import Cocoa

class InitialViewController: NSViewController {

    @IBOutlet weak var userIcon: NSImageView!
    @IBOutlet weak var username: NSTextField!
    @IBOutlet weak var emailId: NSTextField!
    @IBOutlet weak var dashboardList: NSTableView!
    
    var userInfo: UserInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        userIcon.wantsLayer = true
        userIcon.layer?.cornerRadius = 25
        if let userInfo = FirebaseAuthManager.getUserInfo() {
            setupUser(user: userInfo)
        }
        dashboardList.delegate = self
        dashboardList.dataSource = self
       
    }
    
    override func viewDidAppear() {
        self.performSegue(withIdentifier: DashboardInfo.dashboard.viewControllerSegue, sender: self)
    }
    
    func setupUser(user: UserInfo) {
        self.userInfo = user
        self.userIcon.image = user.icon
        self.username.stringValue = user.name
        self.emailId.stringValue = user.email
    }
    
    
    @IBAction func signOutUser(_ sender: Any) {
        do {
            try userInfo?.signOut()
            self.performSegue(withIdentifier: "loginVCSegue", sender: self)
        } catch {
            let logoutAlert = NSAlert()
            logoutAlert.messageText = "Error Logging Out"
            logoutAlert.informativeText = error.localizedDescription
            logoutAlert.runModal()
        }
    }
}

extension InitialViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return DashboardInfo.allCases.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellIdentifier = NSUserInterfaceItemIdentifier("dataCell")
            
            guard let cell = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else {
                return nil
            }
        cell.textField?.stringValue = DashboardInfo.allCases[row].rawValue
        cell.imageView?.image = NSImage(named: "NSTouchBarUserTemplate")
    
//        button.title = DashboardInfo.allCases[row].rawValue
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let uiRow = dashboardList.selectedRow
        let element = DashboardInfo.allCases[uiRow]
        guard let splitViewController = self.parent as? NSSplitViewController else {
            return
        }
        let newVC = self.storyboard?.instantiateController(withIdentifier: element.viewControllerSegue) as! NSViewController
        let newItem = NSSplitViewItem(contentListWithViewController: newVC)
        splitViewController.removeChild(at: 1)
        splitViewController.addSplitViewItem(newItem)
    }
}


class ReplaceSegue: NSStoryboardSegue {
    override func perform() {
        if let sourceVC = self.sourceController as? NSViewController,
           let destinationVC = self.destinationController as? NSViewController,
           let window = sourceVC.view.window {
            // Set the new view controller as the window's content
            window.contentViewController = destinationVC
        }
    }
}
