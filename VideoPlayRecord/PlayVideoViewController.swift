//
//  PlayVideoViewController.swift
//  VideoPlayRecord
//
//  Created by Gautham S Shetty on 5/25/17.
//  Copyright © 2017 Gautham S Shetty. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreMedia

class PlayVideoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playVideo(_ sender: Any) {
        startMediaBrowserFromViewController(viewController: self, usingDelegate: self)
    }

    
    func startMediaBrowserFromViewController(viewController: UIViewController, usingDelegate delegate: UINavigationControllerDelegate & UIImagePickerControllerDelegate) -> Bool {
        // 1
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) == false {
            return false
        }
        
        // 2
        let mediaUI = UIImagePickerController()
        mediaUI.sourceType = .savedPhotosAlbum
        mediaUI.mediaTypes = [kUTTypeMovie as NSString as String]
        mediaUI.allowsEditing = false
        mediaUI.delegate = delegate
        
        // 3
        present(mediaUI, animated: true, completion: nil)
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let mediaType:String = info[UIImagePickerControllerMediaType] as! String


        dismiss(animated: false, completion: nil)
        
        if (mediaType == kUTTypeMovie as String)
        {
            let url:URL = info[UIImagePickerControllerMediaURL] as! URL

            print("URL : \(url)")
            
            
            let fileURL:URL = grabFileURL(fileName: url.lastPathComponent)
            do
            {
                try FileManager.default.moveItem(at: url, to: fileURL)
            }
            catch
            {
                print(error)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func grabFileURL(fileName:String) -> URL {
        
        var fileURL:URL!
        if let documentsURL:URL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last
        {
            fileURL = documentsURL.appendingPathComponent(fileName)
        }
        return fileURL
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

// MARK: - UIImagePickerControllerDelegate
extension PlayVideoViewController: UIImagePickerControllerDelegate {
}

// MARK: - UINavigationControllerDelegate
extension PlayVideoViewController: UINavigationControllerDelegate {
}
