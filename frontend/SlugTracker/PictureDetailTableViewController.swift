//
//  PictureDetailTableViewController.swift
//  slugMapsTest01
//
//  Created by Daniel Carrera on 1/4/21.
//

import UIKit
import CoreLocation

class PictureDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var speciesField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    var species: String!
    var date: Date!
    var note: String!
    var userImage: UIImage!
    var animalType: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set imageView var
        if userImage != nil {
            imageView.image = userImage
        }
   }
    
    // send picture details back to a view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        species = speciesField.text
        date = datePicker.date
        note = noteView.text
        userImage = imageView.image
    }
    
    // Dismiss modal after pressing cancel
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
