//
//  CameraViewController.swift
//  slugMapsTest01
//
//  Created by Daniel Carrera on 1/4/21.
//

import UIKit
import CoreLocation

class CameraViewController: UIViewController{
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var button: UIButton!
    
    // data retrieved after user takes a picture
    var species: String!
    var note: String!
    var date: Date!
    var userImage: UIImage!
    var encodedImage: String!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // load MapViewController when app starts up
        // CameraViewController is initially presented by default
        
        self.tabBarController?.selectedIndex = 1
    }
    
    // Activating camera
    @IBAction func didTapButton(){
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    // send user's Image capture over to PictureDetailTable View Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if userImage != nil{
            
            // access child view
            let nav = segue.destination as! UINavigationController
            let svc = nav.topViewController as! PictureDetailTableViewController
            
            // set the image var at the destination controller
            svc.userImage = userImage
        }
    }
    
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as?
                UIImage else {
            return
        }
        
        imageView.image = image
        userImage = image
        
        // go to PictureDetail view controller to enter picture details
        picker.dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "pictureDetail", sender: self)
            
        })
    }
}
