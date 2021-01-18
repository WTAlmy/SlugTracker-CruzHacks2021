//
//  DiscoverViewController.swift
//  SlugTracker
//
//  Created by Daniel Carrera on 1/17/21.
//

import UIKit

class DiscoverViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // Structure for a user observation
    struct Observation{
        var species: String?
        var note: String?
        var date: String?
        var userImage: UIImage?
        var animalType: Int?
    }
    
    var observations = [Observation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Struct to store json fields
        struct DecodeObservation: Decodable {
            let species_desc: String
            let species_enum: Int
            let image_desc: String
            let date_swift: String
            let latitude: Double
            let longitude: Double
            let image_url: String
            let username: String
        }

        if let url = URL(string: "https://playground-298804.wl.r.appspot.com/list_all") {
            URLSession.shared.dataTask(with: url) { [self] data, response, error in
              if let data = data {
                  do {
                    let res: [DecodeObservation] = try JSONDecoder().decode([DecodeObservation].self, from: data)
                    for json in res {
                        print(json.image_url)
                        
                        let imageUrl = URL(string: json.image_url)
                        let imageData = try? Data(contentsOf: imageUrl!)
                        let image = UIImage(data: imageData!)
                        //print(testDate!)

                        addObservation(species: json.species_desc, note: json.image_desc, date: json.date_swift, userImage: image!, animalType: json.species_enum)
                    }
                    
                  } catch let error {
                     print(error)
                  }
               }
           }.resume()
        }
        
        func addObservation(species: String, note: String, date: String, userImage: UIImage, animalType: Int){
            
            observations.append(Observation(species: species, note: note, date: date, userImage: userImage, animalType: animalType))
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
