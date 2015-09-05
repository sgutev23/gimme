//
//  LoginViewController
//  Gimme
//
//  Created by Stanislav Gutev on 9/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit

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
        if let accessToken: FBSDKAccessToken = FBSDKAccessToken.currentAccessToken() {
            PFFacebookUtils.logInInBackgroundWithAccessToken(accessToken, block: {
                (user: PFUser?, error: NSError?) -> Void in
                if let user = user {
                    NSLog("User logged in through Facebook!")
                    self.performSegueWithIdentifier(SeguesIdentifiers.WishlistsViewSegue, sender: self)
                } else {
                    NSLog("Uh oh. There was an error logging in.")
                }
            })
        } else {
            PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: {
            
                (user: PFUser?, error: NSError?) -> Void in
            
                if let error = error {
                    NSLog("Error: \(error)")
                } else {
                    if let user = user {
                        NSLog("User logged in through Facebook!")
                        self.performSegueWithIdentifier(SeguesIdentifiers.WishlistsViewSegue, sender: self)
                    }
                }
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser()?.username != nil {
            NSLog("User logged in")
            self.performSegueWithIdentifier(SeguesIdentifiers.WishlistsViewSegue, sender: self)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
