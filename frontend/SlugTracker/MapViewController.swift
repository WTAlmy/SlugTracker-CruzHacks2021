//
//  MapViewController.swift
//  slugMapsTest01
//
//  Created by Daniel Carrera on 1/4/21.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController, GMSMapViewDelegate{
    
    // Vars for Map
    var locationManager = CLLocationManager()
    var mapView = GMSMapView()
    var postImage = false
    
    // Structure for a user observation
    struct Observation{
        var species: String?
        var note: String?
        var date: String?
        var coordinates: (lat: CLLocationDegrees, lng: CLLocationDegrees)?
        var userImage: UIImage?
        var animalType: Int?
    }
    
    // Array for observations
    var observations = [Observation]()
    
    // Array for markers
    var markers = [GMSMarker]()
    
    // Array for marker icons
    var markerIcons = [UIImage]()

    
    // Add an observation struct to observation struct array
    func addObservation(species: String, note: String, date: String, lat: Double, lng: Double, userImage: UIImage, animalType: Int){
        
        observations.append(Observation(species: species, note: note, date: date, coordinates: (lat: lat, lng: lng), userImage: userImage, animalType: animalType))
    }
    
    // plot markers from marker array
    func addMarkers(){
        markers.removeAll()
        
        // index all markers
        for (index, discovery) in observations.enumerated(){
            let marker = GMSMarker()
            print("got here")
            marker.position = CLLocationCoordinate2D(latitude: discovery.coordinates!.lat, longitude: discovery.coordinates!.lng)
            
            // set unique identifyier for marker
            marker.accessibilityLabel = String(index)
            marker.title = discovery.species
            marker.snippet = discovery.note
            //marker.icon markerIcons[discovery.animalType!]
            marker.icon = markerIcons[discovery.animalType!]
            
            marker.icon = UIGraphicsImageRenderer(size: .init(width: 40.0, height: 40.0)).image { context in
                markerIcons[0].draw(in: .init(origin: .zero, size: context.format.bounds.size))
            }
            marker.map = mapView
            markers.append(marker)
        }
    }
    
    // Populating icons array for map icons
    func addIcons(){
        markerIcons.append(UIImage(named: "slugIcon")!)
        markerIcons.append(UIImage(named:"turkeyIcon")!)
        markerIcons.append(UIImage(named:"deerIcon")!)
        markerIcons.append(UIImage(named:"squirrelIcon")!)
        markerIcons.append(UIImage(named:"rabbitIcon")!)
        markerIcons.append(UIImage(named:"raccoonIcon")!)
        markerIcons.append(UIImage(named:"coyoteIcon")!)
        markerIcons.append(UIImage(named:"birdIcon")!)
        markerIcons.append(UIImage(named:"rareIcon")!)
        markerIcons.append(UIImage(named:"otherIcon")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // Setting up location manager
        GoogleMapsHelper.initLocationManager(locationManager, delegate: self)
        
        // Creating a map
        let camera = GMSCameraPosition.camera(withLatitude: 36.9881, longitude: -122.0582, zoom: 14.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.mapType = .satellite
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view = mapView
        
        addIcons()
        
        // Printing GMaps License
        //print(GMSServices.openSourceLicenseInfo())

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

                        addObservation(species: json.species_desc, note: json.image_desc, date: json.date_swift, lat: json.latitude, lng: json.longitude, userImage: image!, animalType: json.species_enum)
                    }
                    addMarkers()
                  } catch let error {
                     print(error)
                  }
               }
           }.resume()
        }
    }
    
    
    
    func createRequest(params: [String : String]) throws -> URLRequest {
        let parameters = params

        let boundary = generateBoundaryString()

        let url = URL(string: "https://playground-298804.wl.r.appspot.com/insert")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try createBody(with: parameters, boundary: boundary)

        return request
        
    }
    
    private func createBody(with parameters: [String: String]?, boundary: String) throws -> Data {
        var body = Data()
        var filename = "image1"

        parameters?.forEach { (key, value) in
            body.append(Data("--\(boundary)\r\n".utf8))
            body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
            body.append(Data("\(value)\r\n".utf8))
        }
        
        let url = URL(string:"https://i1.wp.com/friendsofedgewood.org/wp-content/uploads/ew_mv_banana-slug.jpg")
        let data = try? Data(contentsOf: url!)
        let slugImage = UIImage(data: data!)
        let imageData = slugImage?.pngData()
        
        let mimetype = "image/png"

        body.append(Data("--\(boundary)\r\n".utf8))
        body.append(Data("Content-Disposition: form-data; name=\"image\"; filename=\"\(filename)\"\r\n".utf8))
        body.append(Data("Content-Type: \(mimetype)\r\n\r\n".utf8))
        body.append(imageData!)
        body.append(Data("\r\n".utf8))

        body.append(Data("--\(boundary)--\r\n".utf8))
        return body
    }
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    
    
    //retrieving data from PictureDetail view controller
    @IBAction func unwindFromPictureDetail(segue: UIStoryboardSegue){
        
        let source = segue.source as! PictureDetailTableViewController
        
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        // Create an observation with user data and place into observations array
        observations.append(Observation(species: source.species, note: source.note, date: df.string(from: source.date), coordinates: (lat: locationManager.location?.coordinate.latitude, lng: locationManager.location?.coordinate.longitude) as? (lat: CLLocationDegrees, lng: CLLocationDegrees), userImage: source.userImage))
        
        // place marker
        let marker = GMSMarker()
        marker.title = source.species
        marker.snippet = source.note
        //marker.icon markerIcons[discovery.animalType!]
        marker.icon = markerIcons[1]
        
        marker.icon = UIGraphicsImageRenderer(size: .init(width: 40.0, height: 40.0)).image { context in
            markerIcons[1].draw(in: .init(origin: .zero, size: context.format.bounds.size))
        }
        marker.map = mapView
        markers.append(marker)
        
        let params: [String : String]! = [
            "username"     : "jessica",
            "species_enum" : "0",
            "species_desc" : source.species,
            "latitude"     : String(locationManager.location?.coordinate.latitude ?? 36.9881),
            "longitude"     : String(locationManager.location?.coordinate.longitude ?? -122.0582),
            "image_desc"     : source.note,
            "date_swift"     : df.string(from: source.date),
        ]
        
        let request: URLRequest

        do {
            request = try createRequest(params: params)
        } catch {
            print(error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                // handle error here
                print(error ?? "Unknown error")
                return
            }
            print("PRINTING RESPONSE: \(response!)")

        }
        task.resume()
   }
}

extension MapViewController: CLLocationManagerDelegate {

    // Handle incoming location events
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        GoogleMapsHelper.didUpdateLocations(locations, locationManager: locationManager, mapView: mapView)
    }

    //Handle authorization for the location manager
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        GoogleMapsHelper.handle(manager, didChangeAuthorization: status)
    }

    // Handle location manager errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}


