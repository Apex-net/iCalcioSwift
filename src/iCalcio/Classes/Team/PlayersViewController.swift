//
//  PlayersViewController.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 25/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import UIKit
import Alamofire

class PlayersViewController: UITableViewController {
    
    private var playersList : [(role: Roles, players: Array<Player>)] = []
    
    private enum Roles: String {
        case Portiere = "Portiere", Difensore = "Difensore", Centrocampista = "Centrocampista", Attaccante = "Attaccante", Indefinito = "Indefinito"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // title
        self.navigationItem.title = NSLocalizedString("Squadra", comment: "")
        
        // init refresh control
        let refreshControl:UIRefreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull to refresh", comment: ""))
        refreshControl.addTarget(self, action: "refreshAction:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        // refresh data
        self.refreshData()

        // GA tracking
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.trackScreen("/Players")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Get Data for Table view
    
    private func refreshData() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let endpointUrl = appDelegate.apiBaseUrl + "/Players.txt"
        
        // reset temp array
        playersList.removeAll()
        
        Alamofire.request(.GET, endpointUrl)
            .responseJSON {request, response, result in
                switch result {
                case .Success(let JSON):
                    //print("Success with JSON: \(JSON)")
                    if let JsonArray:AnyObject = JSON.valueForKeyPath("data"), parsedDicts = JsonArray as? [AnyObject] {
                        //println(parsedDicts)
                        for item in parsedDicts{
                            var itemRole:Roles = Roles.Indefinito
                            if let role:String = item.valueForKeyPath("role") as? String{
                                switch role {
                                case Roles.Portiere.rawValue:
                                    itemRole = Roles.Portiere
                                case Roles.Difensore.rawValue:
                                    itemRole = Roles.Difensore
                                case Roles.Centrocampista.rawValue:
                                    itemRole = Roles.Centrocampista
                                case Roles.Attaccante.rawValue:
                                    itemRole = Roles.Attaccante
                                default:
                                    break
                                }
                            }
                            var itemPlayers: Array<Player> = []
                            if let players:[AnyObject] = item.valueForKeyPath("players") as? [AnyObject] {
                                itemPlayers = players.map({ obj in Player(attributes: obj) })
                            }
                            let newData = (role: itemRole, players:itemPlayers)
                            self.playersList.append(newData)
                        }
                        // tableview reloading
                        self.tableView.reloadData()
                    }
                case .Failure(let data, let error):
                    print("Request failed with error: \(error)")
                    if let dataFailure = data {
                        print("Response data: \(NSString(data: dataFailure, encoding: NSUTF8StringEncoding)!)")
                    }
                }
                // end refreshing
                if self.refreshControl?.refreshing == true {
                    self.refreshControl?.endRefreshing()
                }
            }

    }
    
    // RefreshControl selector
    func refreshAction(sender:AnyObject) {
        self.refreshData()
    }

    // MARK: - Utilities
    func formatPlayerName(playerName: String) -> String {
        
        let stringToSearch = "\t"
        let dirtystring = playerName
        var startIndex = dirtystring.startIndex
        var endIndex = dirtystring.endIndex
        if dirtystring.rangeOfString(stringToSearch) != nil {
            startIndex = startIndex.advancedBy(1)
            endIndex = endIndex.advancedBy(-1)
        }
        let range = startIndex..<endIndex
        let cleanString = dirtystring.substringWithRange( range )
        
        return cleanString
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        let sections = self.playersList.count
        return sections
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        let sectionTupla = self.playersList[section]
        let players = sectionTupla.players
        
        return players.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Player", forIndexPath: indexPath)

        // Configure the cell...
        
        let player = self.playersList[indexPath.section].players[indexPath.row]
        
        // set texts
        cell.textLabel?.text = self.formatPlayerName(player.name)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = String()
        if self.playersList.count > 0 {
            let titleSection: Roles = self.playersList[section].role
            title = titleSection.rawValue
        }
        return title
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        let indexPath:NSIndexPath = self.tableView.indexPathForSelectedRow!
        let player = self.playersList[indexPath.section].players[indexPath.row]
        if segue.identifier == "toDetailMatch" {
            let vc = segue.destinationViewController as! DetailPlayerViewController
            vc.player = player
        }
        
    }

}
