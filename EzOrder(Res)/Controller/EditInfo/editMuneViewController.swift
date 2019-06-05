//
//  editMuneViewController.swift
//  EzOrder(Res)
//
//  Created by 劉十六 on 2019/6/4.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase

class editMuneViewController: UIViewController {
    var photoURL : URL?
    var DID = ""
    var Dids = ""
    var photos = [QueryDocumentSnapshot]()
    @IBOutlet weak var editMoney: UITextField!
    @IBOutlet weak var editName: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func add(_ sender: Any) {
        updaPhoto()
        upda()
        
        
    }
    
    @IBAction func backMune(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func updaPhoto() {
        imageView.startAnimating()
        let db = Firestore.firestore()
        var photoReference : DocumentReference?
        
        //        (error) in
        //        guard error == nil  else {
        //            self.imageView.startAnimating()
        //            return
        //        }
        
        let storageReference = Storage.storage().reference()
        let fileReference = storageReference.child(UUID().uuidString + ".jpg")
        let imageuser : [String:Any] = [Dids:fileReference]
        print(imageuser)
        let image =  self.imageView.image
        let size = CGSize(width: 640, height:
            (image?.size.height)! * 640 / (image?.size.width)!)
        UIGraphicsBeginImageContext(size)
        image?.draw(in: CGRect(origin: .zero, size: size))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let data = resizeImage?.jpegData(compressionQuality: 0.8)
        { fileReference.putData(data,metadata: nil) {(metadate , error) in
            guard let _ = metadate, error == nil else {
                self.imageView.stopAnimating()
                return
            }
            fileReference.downloadURL(completion: { (url, error) in
                guard let downloadURL = url else {
                    self.imageView.stopAnimating()
                    
                    return
                }
                photoReference?.updateData(["photoUrl": downloadURL.absoluteString])
                self.photoURL = downloadURL
                print("1",self.photoURL)
                
                print(downloadURL)
            }
            )}
        }
        
        
    }
    func upda() {
        let foodName = editName.text  ?? ""
        let foodMoney = editMoney.text ?? ""
        print("10",photoURL ?? "")
        let db = Firestore.firestore()
        let dats: [String:Any] = ["Name" : foodName,"Money":foodMoney,"photoUrl": photoURL ?? ""]
        db.collection("photo").document(Dids).collection("Munes")
            .document(DID).updateData(dats){
                (error) in
                guard error == nil  else {
                    
                    return
                }
                db.collection("photo").document(self.Dids).collection("Munes")
                    .getDocuments(completion: { (photo, error) in
                        if let photo = photo{
                            for a in photo.documents{
                                if let documentID = a.data()["documentID"] as? String{
                                    if documentID == self.DID{
                                        if let photoUrl = a.data()["photoUrl"] as? String{
                                            if photoUrl.isEmpty == false{
                                                
                                                self.dismiss(animated: true, completion: nil)
                                                break
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        }
                    })
                self.dismiss(animated: true, completion: nil)
        }
    }
}



