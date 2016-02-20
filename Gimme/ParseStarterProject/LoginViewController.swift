//
//  LoginViewController
//  Gimme
//
//  Created by Stanislav Gutev on 9/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginWithFacebook(sender: AnyObject) {
        let permissions = ["public_profile", "email", "user_friends"]
        let ref = Firebase(url: "https://gimmeproject.firebaseio.com")
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logInWithReadPermissions(permissions, handler: {
            (facebookResult, facebookError) -> Void in
            if facebookError != nil {
                NSLog("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled {
                NSLog("Facebook login was cancelled.")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                ref.authWithOAuthProvider("facebook", token: accessToken,
                    withCompletionBlock: { error, authData in
                        if error != nil {
                            NSLog("Login failed. \(error)")
                        } else {
                            NSLog("Logged in! \(authData)")
                        }
                })
            }
        })

//        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: {
//                (user: PFUser?, error: NSError?) -> Void in
//            
//                if let error = error {
//                    NSLog("Error: \(error)")
//                } else {
//                    if let user = user {
//                        if user.isNew {
//                            NSLog("New user \(user)")
//                            let fbRequest = FBSDKGraphRequest(graphPath:"/me", parameters: ["fields":"id,email,name,first_name,last_name"] );
//                            fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
//                                if error == nil {
//                                    if let result = result {
//                                        
//                                        user["facebookId"] = result["id"] as? String
//                                        user["firstName"] = result["first_name"] as? String ?? result["name"] as? String
//                                        user["lastName"] = result["last_name"] as? String ?? ""
//                                        
//                                        let facebookId = result["id"] as? String
//                                        let pictureURL = "https://graph.facebook.com/\(facebookId!)/picture?width=300&height=300"
//                                        let urlRequest = NSURL(string: pictureURL)
//                                        let urlRequestNeeded = NSURLRequest(URL: urlRequest!)
//                                        
//                                        NSURLConnection.sendAsynchronousRequest(urlRequestNeeded, queue: NSOperationQueue.mainQueue(), completionHandler: {
//                                            (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
//                                            if error == nil {
//                                                let picture = PFFile(data: data!)
//                                                picture.saveInBackgroundWithBlock( {
//                                                    (succeeded, error) -> Void in
//                                                    
//                                                    if error == nil {
//                                                        user["profilePicture"] = picture
//                                                    } else {
//                                                        user["profilePicture"] = NSNull()
//                                                        NSLog("Error saving image in Parse: \(error?.localizedDescription)")
//                                                    }
//                                                    user.saveInBackground()
//                                                    
//                                                    NSLog("User logged in through Facebook with a profile picture!")
//                                                    self.performSegueWithIdentifier(SeguesIdentifiers.WishlistsViewSegue, sender: self)                                                    
//                                                })
//                                            } else {
//                                                NSLog("Error getting profile picture: \(error?.localizedDescription)")
//                                                user["picture"] = NSNull()
//                                                user.saveInBackground()
//                                                
//                                                NSLog("User logged in through Facebook without a profile picture!")
//                                                self.performSegueWithIdentifier(SeguesIdentifiers.WishlistsViewSegue, sender: self)
//                                            }
//                                        })
//                                    }
//                                } else {
//                                    NSLog("Error retrieving user: \(error?.localizedDescription)")
//                                }
//                            }
//                        }
////                        NSLog("User logged in through Facebook!")
////                        self.performSegueWithIdentifier(SeguesIdentifiers.WishlistsViewSegue, sender: self)
//                    }
//                }
//            })
    }
    
    override func viewDidAppear(animated: Bool) {
//        if PFUser.currentUser()?.username != nil {
//            NSLog("User logged in")
//            self.performSegueWithIdentifier(SeguesIdentifiers.WishlistsViewSegue, sender: self)
//        }
    }
}
