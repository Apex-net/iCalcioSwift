//
//  PlayVideoViewController.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 17/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import UIKit

import youtube_ios_player_helper

class PlayVideoViewController: UIViewController, YTPlayerViewDelegate {
    
    var youtubeVideo: YoutubeVideo!
    
    @IBOutlet weak var playerView: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /*
        // only for test
        let playerView1: YTPlayerView = YTPlayerView()
        let returnValue1 = playerView1.loadWithVideoId("BuB95_FfsSs")
        println("retun \(returnValue1) ")
        */
        
        // title
        self.navigationItem.title = self.youtubeVideo.title
        
        // setup player
        let playerVars = ["showinfo": 0, "modestbranding": 1]
        let VideoId = youtubeVideo.idVideo
        self.playerView.delegate = self
        // load video on player
        self.playerView.loadWithVideoId(VideoId, playerVars: playerVars)
        
        // GA tracking
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.trackScreen("/VideoDetail")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - YTPlayerView Delegate
    func playerView(playerView: YTPlayerView!, didChangeToState state: YTPlayerState) {
        let i: Int = state.rawValue
        print("playerView didChangeToState YTPlayerState: \(i)", terminator: "\n")
    }

    func playerView(playerView: YTPlayerView!, receivedError error: YTPlayerError) {
        let i: Int = error.rawValue
        print("playerView error YTPlayerError: \(i)", terminator: "\n")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
