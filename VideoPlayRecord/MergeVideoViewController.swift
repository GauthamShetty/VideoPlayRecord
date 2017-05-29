//
//  MergeVideoViewController.swift
//  VideoPlayRecord
//
//  Created by Gautham S Shetty on 5/25/17.
//  Copyright © 2017 Gautham S Shetty. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia
import Photos
import AssetsLibrary
import MobileCoreServices
import MediaPlayer



class MergeVideoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,MPMediaPickerControllerDelegate {
    
    var isSelectingAssetOne:Bool!
    var firstAsset:AVAsset!
    var secondAsset:AVAsset!
    var audioAsset:AVAsset!
    @IBOutlet var activityView:UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func loadAsset1(_ sender: Any) {
        if ((UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)) != nil)
        {
            isSelectingAssetOne = true
            
            startMediaBrowserFromViewController(viewController: self, usingDelegate: self)
            
        }
        else{
            let alert = UIAlertController(title: "Error", message: "No Saved Album Found", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func loadAssetTwo(_ sender: Any) {
        if ((UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)) != nil)
        {
            isSelectingAssetOne = false
            
            startMediaBrowserFromViewController(viewController: self, usingDelegate: self)
            
        }
        else{
            let alert = UIAlertController(title: "Error", message: "No Saved Album Found", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func loadAudio(_ sender: Any) {
        let mediaPicker = MPMediaPickerController(mediaTypes: MPMediaType.anyAudio)
        mediaPicker.delegate = self
        mediaPicker.prompt = "Select Audio"
        present(mediaPicker, animated: true, completion: {})
    }
    
    @IBAction func mergeAndSaveVideo(_ sender: Any) {
        
        //        if (firstAsset !=nil && secondAsset !=nil)
        //        {
        //activityView.startAnimating()
        
        //        }
        //        else{
        let mixComposition:AVMutableComposition =  AVMutableComposition()
        let videoTrack: AVMutableCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        let audioTrack :AVMutableCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)

        
        do {
            try
                
                videoTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, firstAsset.duration), of: (firstAsset.tracks(withMediaType:AVMediaTypeVideo)).first!, at: kCMTimeZero)

        } catch
        {
            NSLog("Error while creating Video Track!")
        }
        
        do {
            try
                
        videoTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, secondAsset.duration), of: (secondAsset.tracks(withMediaType:AVMediaTypeVideo)).first!, at: kCMTimeZero)
        } catch
        {
            NSLog("Error while creating Video Track!")
        }

        do {
            try

        audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, CMTimeAdd(firstAsset.duration, secondAsset.duration)), of: audioAsset.tracks(withMediaType: AVMediaTypeAudio).first!, at: kCMTimeZero)

       // audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, firstAsset.duration), of: audioAsset.tracks(withMediaType: AVMediaTypeAudio).first!, at: kCMTimeZero)
            
        } catch
        {
            NSLog("Error while creating Audio Track!")
        }

//        do {
//            try
//                audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, secondAsset.duration), of: secondAsset.tracks(withMediaType: AVMediaTypeAudio).first!, at: kCMTimeZero)
//
//        } catch  {
//            NSLog("Error while creating Audio Track!")
//        }

        // 4 - Get path
        let paths:[String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths.first
        let fileName:String = String.init(format: "/mergeVideo-%d.mov", arc4random()%1000)
        let myPathDocs:String = (documentsDirectory?.appending(fileName))!
        let fileURL:URL = URL.init(fileURLWithPath: myPathDocs)
        
        
        
        // 5 - Create exporter
        let exporter:AVAssetExportSession =  AVAssetExportSession.init(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)!
        exporter.outputURL=fileURL
        exporter.shouldOptimizeForNetworkUse = true
        exporter.outputFileType = AVFileTypeQuickTimeMovie
        exporter.exportAsynchronously(completionHandler: {

            DispatchQueue.main.async {
                self.exportDidFinish(session: exporter)
            }
        })
        
    }
    
    func startMediaBrowserFromViewController(viewController: UIViewController, usingDelegate delegate: UINavigationControllerDelegate & UIImagePickerControllerDelegate) {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) == false {
            return
        }
        
        // 2
        let mediaUI = UIImagePickerController()
        mediaUI.sourceType = .savedPhotosAlbum
        mediaUI.mediaTypes = [kUTTypeMovie as NSString as String]
        mediaUI.allowsEditing = false
        mediaUI.delegate = delegate
        
        // 3
        present(mediaUI, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let mediaType:String = info[UIImagePickerControllerMediaType] as! String
        
        
        dismiss(animated: false, completion: nil)
        
        if (mediaType == kUTTypeMovie as String)
        {
            let url:URL = info[UIImagePickerControllerMediaURL] as! URL
            
            if(isSelectingAssetOne == true)
            {
                let alert = UIAlertController(title: "Asset Loaded", message: "Video 1 Loaded", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                firstAsset = AVAsset.init(url: url)
            }
            else{
                let alert = UIAlertController(title: "Asset Loaded", message: "Video 2 Loaded", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                secondAsset = AVAsset.init(url: url)
            }
        }
    }
    
    func exportDidFinish(session:AVAssetExportSession)
    {
        
        if (session.status == AVAssetExportSessionStatus.completed)
        {
            let outputURL = session.outputURL
            
            PHPhotoLibrary.shared().performChanges({
                
                var createChangeRequest: PHAssetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL!)!
                
            }, completionHandler: { (success, error) in
                if ((error) != nil)
                {
                    let alert = UIAlertController(title: "Error", message: "Video Saving Failed", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    let alert = UIAlertController(title: "Video Saved", message: "Saved To Photo Album", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: false, completion: {})
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        let selectedSongs = mediaItemCollection.items
        mediaPicker.dismiss(animated: false, completion: {})
        
        if (selectedSongs.count > 0)
        {
            let songItem : MPMediaItem = selectedSongs.first!
            let songURL:URL = songItem.assetURL!
            audioAsset = AVAsset.init(url: songURL)
            let alert = UIAlertController(title: "Asset Loaded", message: "Audio Asset Loaded", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
