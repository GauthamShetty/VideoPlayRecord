//
//  RecordVideoViewController.swift
//  VideoPlayRecord
//
//  Created by Gautham S Shetty on 5/25/17.
//  Copyright © 2017 Gautham S Shetty. All rights reserved.
//

import UIKit
import AssetsLibrary
import MobileCoreServices
import MediaPlayer

class RecordVideoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordAndPlay(_ sender: Any) {
    
    _ = startCameraControllerFrom(viewController: self, usingDelegate: self)
        
    }

    func startCameraControllerFrom(viewController: UIViewController, usingDelegate: NSObject) -> Bool {
        
        if ((UIImagePickerController.availableMediaTypes(for: .camera)) != nil)
        {
            let pickerController = UIImagePickerController();
            pickerController.sourceType = .camera
            pickerController.mediaTypes = [kUTTypeMovie as String]
            pickerController.allowsEditing = false
            pickerController.delegate = self
            
            present(pickerController, animated: true, completion: nil)

            return true;
        }
        

        return false;
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType:String = info[UIImagePickerControllerMediaType] as! String
        
        picker.dismiss(animated: false, completion: nil)
        
        if (mediaType == kUTTypeMovie as String)
        {
            let moviePathURL:URL = info[UIImagePickerControllerMediaURL] as! URL
            let moviePath:String = moviePathURL.path
            
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath))
            {
                UISaveVideoAtPathToSavedPhotosAlbum(moviePath, self,#selector(self.videoDidFinishSaving(videoPath:error:info:)), nil)
            }
        }
    }
    
    func videoDidFinishSaving(videoPath:NSString, error:NSError, info:[String : Any]) -> Void {
        
        if (error.domain == nil)
        {
            let alert = UIAlertController(title: "Error", message: error.localizedFailureReason, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Video Saved", message: String.init("File Saved with Name:\(videoPath.lastPathComponent)"), preferredStyle: UIAlertControllerStyle.alert)
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
