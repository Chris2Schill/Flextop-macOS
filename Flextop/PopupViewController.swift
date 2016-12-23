//
//  PopupViewController.swift
//  Flextop
//
//  Created by Chris Schilling on 12/20/16.
//  Copyright © 2016 Chris Schilling. All rights reserved.
//

import Cocoa

class PopupViewController: NSViewController {

    var button : NSButton!
    var listview : NSTextView!
    var scrollview : NSScrollView!
    var workspaces : [String]!
    
    @IBAction func deleteButton(_ sender: NSButton) {
        var buttonPosition = sender.convert(NSPoint(0,0), to: self.tableView)
    }
    
    @IBOutlet var tableView: NSTableView!
    
    init(){
        super.init(nibName: nil, bundle: nil)!
        workspaces = [String]()
        let workspaceData = UserDefaults.standard.object(forKey: "workspaces") as? NSData
        
        if let workspaceData = workspaceData {
            let workspacesList = NSKeyedUnarchiver.unarchiveObject(with: workspaceData as Data) as? [String]
            //print("workspaces: \(workspacesList)")
            for item in workspacesList!{
                workspaces.append(item)
                print(item)
            }
        }else{
            print("There is an issue")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    @IBAction func OnNewWorkspaceClicked(_ sender: NSButton) {
        AppDelegate.closePopover()
        let dialogOutput = openFile()
        let modalResponse = dialogOutput.0
        let chosenDirectory = dialogOutput.1
        
        if (modalResponse == NSModalResponseOK){
            changeDesktopToDir(directory: chosenDirectory)
            
            workspaces.append(chosenDirectory)
            
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: workspaces)
            UserDefaults.standard.set(encodedData, forKey: "workspaces")
            tableView.reloadData()
        }
    }
    
    func changeDesktopToDir(directory: String){
        BashShell.executeAndPrint(launchPath: "/bin/rm", arguments: ["/Users/chris/Desktop"])
        BashShell.executeAndPrint(launchPath: "/bin/ln", arguments: ["-s", directory, "/Users/chris/Desktop"])
        BashShell.executeAndPrint(launchPath: "/usr/bin/killall", arguments: ["Finder"])
    }
    
        
    func openFile() -> (Int, String) {
        
        let myFileDialog = NSOpenPanel()
        myFileDialog.canChooseFiles = false
        myFileDialog.canChooseDirectories = true
        let selection = myFileDialog.runModal()
        
        
        
        // Get the path to the file chosen in the NSOpenPanel
        let path = myFileDialog.url?.path
        
        // Make sure that a path was chosen
        if (path != nil) {
            let err = NSError(domain: "Workspace Button", code: 1)
            let text = String(err.localizedDescription)
            NSLog(text!)
        }
        return (selection, path!)
    }
    
}

extension PopupViewController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let WorkspaceCell = "WorkspaceCellID"
        //static let DeleteButton = "DeleteButtonID"

    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let row = tableView.selectedRow
        if (row >= 0 && row < workspaces.count){
            changeDesktopToDir(directory: workspaces[row])
            AppDelegate.closePopover()
        }
        
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text: String = ""
        var cellIdentifier: String = ""
        //tableView.intercellSpacing = CGSize(dictionaryRepresentation: 10)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        
        // Make sure we have at least one item
        guard let item = workspaces?[row] else {
            return nil
        }
        
        //
        if tableColumn == tableView.tableColumns[0] {
            text = item
            cellIdentifier = CellIdentifiers.WorkspaceCell
        }
        
        // 3
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as?NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
    
}

extension PopupViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return workspaces?.count ?? 0
    }
    
}


