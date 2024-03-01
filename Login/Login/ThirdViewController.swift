//
//  ThirdViewController.swift
//  Login
//
//  Created by Droadmin on 12/09/23.
//

import UIKit
import FacebookLogin
import GoogleSignIn
class ThirdViewController: UIViewController {

    var objModel: [JsonModel] = []
    @IBOutlet weak var movieCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home Page"
        logOut()
        fetchApi(URL: "https://my-json-server.typicode.com/horizon-code-academy/fake-movies-api/movies") { result in
            print(result)
            self.objModel = result
            DispatchQueue.main.async {
                self.movieCollectionView.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    func logOut(){
//        let loginManager = LoginManager()
//        loginManager.logOut()
        GIDSignIn.sharedInstance.signOut()
        let logOutBtn = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(logOutPress))
        navigationItem.rightBarButtonItem = logOutBtn
        
    }
    @objc func logOutPress(){
        
        UserDefaults.standard.set(false, forKey: "login")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func fetchApi(URL url:String, completion: @escaping([JsonModel])-> Void){
        let url = URL(string: url)
        let session = URLSession.shared.dataTask(with: url!) {data,response,error in
            
            do{
                if let jsonData = data{
                    if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                        for item in jsonDict{
                            if let title = item["Title"] as? String, let img = item["Poster"] as? String, let year = item["Year"] as? String {
                                let toDoItem = JsonModel(title: title, year: year, image: img)
                                self.objModel.append(toDoItem)
                            }
                        }
                            completion(self.objModel)
                    }
                }
            }catch{
                print("error\(error)")
            }
        }
        session.resume()
    }
    
}
extension UIImageView{
    private static var imageCache = NSCache<NSString, UIImage>()
   
    
    func downloadImage(from url: URL) {
        DispatchQueue.main.async {
            self.image = nil
        }
        
        
        
        if let cachedImage = UIImageView.imageCache.object(forKey: url.absoluteString as NSString)  {
            DispatchQueue.main.async {
                self.image = cachedImage
            }
            
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpRosponse = response as? HTTPURLResponse,httpRosponse.statusCode == 200,let mimeType = response?.mimeType,mimeType.hasPrefix("image"),let data = data,
                  let image = UIImage(data: data),
                  error == nil else {
                //multipurpose internet mail extensions
                return
            }
            UIImageView.imageCache.setObject(image, forKey: url.absoluteString as NSString)
            DispatchQueue.main.async {
                
                self.image = image
            }
        }
        dataTask.resume()
    }
}
extension ThirdViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as! MyCollectionViewCell
        cell.movieNameLbl.text = objModel[indexPath.row].title
        cell.movieYearLbl.text = objModel[indexPath.row].year
        if let imageUrlString = objModel[indexPath.row].image,
           let imageUrl = URL(string: imageUrlString){
            DispatchQueue.global().async {
                cell.movieImage.downloadImage(from: imageUrl)
                
            }
        }
        return cell
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
