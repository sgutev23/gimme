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

let ref = Firebase(url: "https://gimmeproject.firebaseio.com")
var currentUser: User? = nil

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
                            ref.childByAppendingPath("users")
                                .queryOrderedByChild("facebookID")
                                .queryEqualToValue(authData.uid)
                                .observeSingleEventOfType(.Value, withBlock: { snapshot in
                                    if snapshot.value is NSNull {
                                        let fbRequest = FBSDKGraphRequest(graphPath:"/me", parameters: ["fields":"id,email,name,first_name,last_name"] );
                                        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                                            if error == nil {
                                                if let result = result {
                                                    var newUserCredentials = [String : String]()
                                                    newUserCredentials["facebookId"] = result["id"] as? String
                                                    newUserCredentials["firstName"] = result["first_name"] as? String ?? result["name"] as? String
                                                    newUserCredentials["lastName"] = result["last_name"] as? String ?? ""
                                                    
                                                    let facebookId = result["id"] as? String
                                                    let pictureURL = "https://graph.facebook.com/\(facebookId!)/picture?width=300&height=300"
                                                    let urlRequest = NSURL(string: pictureURL)
                                                    let urlRequestNeeded = NSURLRequest(URL: urlRequest!)
                                                    
                                                    NSURLConnection.sendAsynchronousRequest(urlRequestNeeded, queue: NSOperationQueue.mainQueue(), completionHandler: {
                                                        (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                                                        if error == nil {
                                                            
                                                            let base64String = data!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)

                                                            let newUser = [
                                                                "provider": authData.provider,
                                                                "firstName": newUserCredentials["firstName"],
                                                                "lastName": newUserCredentials["lastName"],
                                                                "email" : authData.providerData["email"] as? NSString as? String,
                                                                "profilePic" : base64String,
                                                                "identifier" : authData.uid,
                                                                "birthdate" : ""
                                                            ]
                                                            
                                                            NSLog("data to store: \(newUser)")
                                                            ref.childByAppendingPath("users").childByAppendingPath(authData.uid).setValue(newUser)
                                                            
                                                            currentUser = User(
                                                                identifier: authData.uid,
                                                                firstName: newUserCredentials["firstName"]!,
                                                                lastName: newUserCredentials["lastName"]!,
                                                                birthdate: nil,
                                                                profilePic: UIImage(data: data!))
                                                            
                                                            self.performSegueWithIdentifier(SeguesIdentifiers.WishlistsViewSegue, sender: authData)
                                                        }
                                                    })
                                                }
                                            }
                                        }
                                    } else {
                                        self.handleLoggedInUser(authData)
                                    }
                                })
                        }
                    }
                )
            }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        if let authData = ref.authData {
            NSLog("User logged in, retrieving details")
            handleLoggedInUser(authData)
        } else {
            NSLog("User not logged in")
        }
    }
    
    func handleLoggedInUser(authData : FAuthData) {
        ref.childByAppendingPath("users")
            .queryOrderedByChild("facebookID")
            .queryEqualToValue(authData.uid)
            .observeSingleEventOfType(.Value, withBlock: { snapshot in
                if snapshot.value is NSNull {
                    NSLog ("Something terrible happened")
                } else {
                    let user = snapshot.value[authData.uid]!
                    let firstName = user!["firstName"]
                    let formatter = NSDateFormatter()
                    
                    formatter.dateStyle = NSDateFormatterStyle.LongStyle
                    
                    NSLog("Logged in: \(firstName)")
                    NSLog("Logged in: \(snapshot)")
                    
                    currentUser = User(
                        identifier: authData.uid,
                        firstName: (user!["firstName"] as? String)!,
                        lastName: (user!["lastName"] as? String)!,
                        birthdate: nil,
                        profilePic: nil)
                    
                    self.performSegueWithIdentifier(SeguesIdentifiers.WishlistsViewSegue, sender: self)
                }
            })

    }
}
