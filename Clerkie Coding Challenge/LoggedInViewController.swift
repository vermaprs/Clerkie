//
//  LoggedInViewController.swift
//  Clerkie Coding Challenge
//
//  Created by Prashant Verma on 8/31/18.
//  Copyright © 2018 Prashant Verma. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ApiAI
import JSQMessagesViewController
import Photos

struct User {
    
    let id: String
    let name: String
    
}

class LoggedInViewController: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    var lastSelectedIndexPath = IndexPath(row: 0, section: 0)

    let user1 = User(id: "1", name: "Guest")
    let user2 = User(id: "2", name: PFUser.current()?.username as! String)
    var currentUser: User { return user2 }
    
    let picker = UIImagePickerController()
        // all messages of users1, users2
    
    var messages = [JSQMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.topViewController?.title = PFUser.current()?.username
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        // tell JSQMessagesViewController
        
        // who is the current user
        self.senderId = currentUser.id
        self.senderDisplayName = currentUser.name
        self.messages = getMessages()
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        picker.allowsEditing = true
        picker.delegate = self

    }
    
    func loadLoginScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
        self.present(viewController, animated: true, completion: nil)
    }
    
    func displayErrorMessage(message:String) {
        let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
    }
    
    
    
    @IBAction func logoutAction(_ sender: Any) {
        let sv = LoggedInViewController.displaySpinner(onView: self.view)
        PFUser.logOutInBackground { (error: Error?) in
            LoggedInViewController.removeSpinner(spinner: sv)
            if (error == nil){
                self.loadLoginScreen()
            }else{
                if let descrip = error?.localizedDescription{
                    self.displayErrorMessage(message: descrip)
                }else{
                    self.displayErrorMessage(message: "error logging out")
                }
                
            }
        }
        
    }
    
    @IBAction func goToDashboard(_ sender: Any) {
        performSegue(withIdentifier: "chatToDashboard", sender: LoggedInViewController.self)
    }
    
    
}

extension LoggedInViewController{
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
        
        finishSendingMessage()
        
        messages.append(message!)
        
        botResponse(text)
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        self.finishSendingMessage()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let picture = info[UIImagePickerControllerEditedImage] as? UIImage
        
        if (info[UIImagePickerControllerEditedImage] as? UIImage) != nil
        {
            let mediaItem = JSQPhotoMediaItem(image: nil)
            mediaItem?.appliesMediaViewMaskAsOutgoing = true
            mediaItem?.image = UIImage(data: UIImageJPEGRepresentation(picture!, 0.5)!)
            let sendMessage = JSQMessage(senderId: senderId, displayName: PFUser.current()?.username, media: mediaItem)
            self.messages.append(sendMessage!)
            self.finishSendingMessage()
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        
        let message = messages[indexPath.row]
        
        let messageUsername = message.senderDisplayName
        return NSAttributedString(string: messageUsername!)
        
    }
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        
        return 15
        
    }
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        return nil
        
    }
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        let message = messages[indexPath.row]
        let botColor = UIColor(red: 255/255.0, green: 153/255.0, blue: 51/255.0, alpha: 0.839)
        if currentUser.id == message.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: botColor)
        }
        
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    func getMessages() -> [JSQMessage] {
        var messages = [JSQMessage]()
        let message1 = JSQMessage(senderId: "1", displayName: "Guest", text: "Hi..")
        messages.append(message1!)
        return messages
        
    }
    
    
    
    func botResponse(_ chatMessage: String) {
        
        if chatMessage != "" {
            
            //initiate APIAI
            let request: AITextRequest? = ApiAI.shared().textRequest()
            request?.query = chatMessage

            request?.setMappedCompletionBlockSuccess({(request, response) in
                
                let response  = response as! AIResponse
                let responseMessage = JSQMessage(senderId: "1", displayName: "Guest", text: response.result.fulfillment.speech)
                
                self.messages.append(responseMessage!)
                self.finishReceivingMessage()
                
            }, failure: {(request, error) in
                let alertView = UIAlertController(title: "Error!", message: (error?.localizedDescription)!, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                }
                alertView.addAction(OKAction)                
                self.present(alertView, animated: true, completion:nil)
                
            })
            
            ApiAI.shared().enqueue(request)
            
        }
        
    }
    
}
