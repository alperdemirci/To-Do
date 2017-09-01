//
//  FirebaseDataAdapter.swift
//  To Do
//
//  Created by alper on 5/11/17.
//  Copyright © 2017 alper. All rights reserved.
//

import UIKit
import Firebase

typealias AuthBlock = (_ user: User?, _ error: NSError?) -> ()
typealias ListStreamBlock = (DataSnapshot!) -> ()

enum FirebaseError: Error {
    case userIdNotFound
}

enum AuthProvider {
    case authEmail
    case authAnonymous
    case authFacebook
    case authGoogle
    case authTwitter
    case authCustom
}
enum todoImage {
    case image
}

class FirebaseDataAdapter {
    var firebaseRef: DatabaseReference
    var imageRef: StorageReference
    
    init() {
        firebaseRef = Database.database().reference()
        imageRef = Storage.storage().reference().child("user_images")
        Auth.auth().addStateDidChangeListener() { (auth, user) in
            if user != nil {
                // User is signed in.
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                UserDefaults.standard.synchronize()
            } else {
                print("alper lost connections")
                // No user is signed in.
            }
        }
    }

    func CreateUserAccount(_ email: String, password: String, userName: String?, completionBlock: AuthBlock? ) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            completionBlock!(user, error as NSError?)
            if error != nil {
                return
            }
            guard let uid = user?.uid else {
                return
            }
            let userReferences = self.firebaseRef.child("Users").child(uid)
            //initial DB data
            let value = ["username": userName!,
                         "email": email,
                         "todo": ""]
            userReferences.updateChildValues(value, withCompletionBlock: { (err, ref) in
                if err != nil {
                    return
                }
                //blah blah blah
            })
        })
    }
    
    func writeTodoIntoDB(image: UIImage?, value: String, date: String ,sharedEmail: String ,onAddCompletionBlock: @escaping (_ completed: Bool) -> ()) {
        let uuid = UUID().uuidString
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        var locationAdded = "false"
        if image != nil {
            locationAdded = "true"
            guard let userID = Auth.auth().currentUser?.uid else {
                return
            }
            let storageRef = Storage.storage().reference().child("\(userID)/\(uuid).png")
            if let uploadData = UIImagePNGRepresentation(image!) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error ?? "something happend while uploading the image to the DB")
                    } else {
                        print(metadata ?? " ")
                    }
                })
            }
        }
        let refPath = firebaseRef.child("Users").child("\(userID)/todo/").childByAutoId()
        let valueWithTimestamp = ["value":value,
                                  "sharedEmail":sharedEmail,
                                "timestampcurrent": date,  //Date.dateFromISOString(date),
                                "timestampfuture":"",
                                "uniqueID": uuid,
                                "locationAdded": locationAdded] as [String : Any]
        refPath.setValue(valueWithTimestamp) { (error, ref) -> Void in
            if error != nil {
                print(error ?? "error")
            } else {
                print(ref)
                onAddCompletionBlock(true)
            }
        }
    }
    
    // MARK: - Profile Methods
    func userSignIn(_ email: String, password: String, completionBlock: AuthBlock? ) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            completionBlock!(user, error as NSError!)
        })
    }
    
    // MARK: Fetching data for the current user from Firebase and pass it with onDemand block
    @discardableResult func getTodoList(onDemand: @escaping ListStreamBlock) -> DatabaseHandle? {
        if let userID = Auth.auth().currentUser?.uid {
            let chatRef = self.firebaseRef.child("Users").child("\(userID)/todo/")
            let messagesQuery = chatRef.queryLimited(toLast: 25)
            return messagesQuery.observe(.childAdded, with: onDemand)
        }
        return nil
    }
    
    // MARK: Image/Screenshot handler
//    func saveSnapshotMapForImageStorage(image: UIImage, uuid: String?) {
//        guard let userID = Auth.auth().currentUser?.uid else {
//            return
//        }
//        let storageRef = Storage.storage().reference().child("\(userID)/myimage.png")
//        if let uploadData = UIImagePNGRepresentation(image) {
//            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
//                if error != nil {
//                    print(error ?? "something happend while uploading the image to the DB")
//                } else {
//                    print(metadata ?? " ")
//                }
//            })
//        }
//        
//    }

    func retriveScreenshotOfMapview(uuid: String?, onDownloadCompletionBlock: @escaping (_ completed: UIImage) -> ()) {
        guard let uniqueID = uuid else {
            return
        }
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        let islandRef = Storage.storage().reference().child("\(userID)/\(uniqueID).png")
        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                let image = UIImage(data: data!)
                onDownloadCompletionBlock(image!)
            }
        }
    }
    
}








