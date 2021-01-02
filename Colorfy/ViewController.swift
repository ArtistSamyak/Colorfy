//
//  ViewController.swift
//  Colorfy
//
//  Created by Samyak Pawar on 02/01/21.
//

import UIKit
import Firebase
import FirebaseStorage
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var choosePic: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var downloadbtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    
    var imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageView.alpha = 0
        clearBtn.alpha = 0
        downloadbtn.alpha = 0
        
        downloadbtn.layer.cornerRadius = 20
        clearBtn.layer.cornerRadius = 20
        
        
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    @IBAction func choosePic(_ sender: UIButton) {
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            let imagedata = image.jpegData(compressionQuality: 80)
            let storage = Storage.storage()
            let Bref = storage.reference()
            let BimageRef = Bref.child("image.jpg")
            BimageRef.putData(imagedata!)
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t1) in
                BimageRef.getData(maxSize: 10 * 1024 * 1024) { (d, e) in
                    if e != nil {
                        
                    }else{
                        self.imageView.image = UIImage(data: d!)
                        self.imageView.alpha = 1
                        t1.invalidate()
                    }
                }
            }
            
            let Cref = storage.reference()
            let CimageRef = Cref.child("image.png")
            CimageRef.delete { (derror) in
                if derror == nil{
                    
                }
            }
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (t2) in
                
                 //To get the colored image..
                
                
                CimageRef.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
                    if error != nil{
                        //print(error?.localizedDescription ?? "Error Occered")
                        
                    }else{
                        self.imageView.image = UIImage(data: data!)
                        self.imageView.alpha = 1
                        self.downloadbtn.alpha = 1
                        self.clearBtn.alpha = 1
                        t2.invalidate()
                        BimageRef.delete { (derror) in
                            if derror == nil{
                                
                            }
                        }
                        
                    }
                }
                
            }
            
        }
    }
    
    
    
    @IBAction func downloadTapped(_ sender: UIButton) {
        UIGraphicsBeginImageContext(imageView.frame.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    @IBAction func clearTapped(_ sender: UIButton) {
        self.imageView.alpha = 0
        self.downloadbtn.alpha = 0
        self.clearBtn.alpha = 0
    }
    

}



