//
//  ViewController+TableView.swift
//  BLEDemo
//
//  Created by apple on 7/30/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import UIKit

extension ChatMessageController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deviceData?.messages.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configureChatMessageCellFor(indexPath: indexPath)
    }
    
    //MARK:- FlowLayoutDelegate Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return configureSizeForItemAt(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    //MARK:- Cell Size Methods
    func configureSizeForItemAt(indexPath: IndexPath) -> CGSize {
        if let text = deviceData?.messages[indexPath.row].message{
            let height = estimatedFrameFor(text: text).size.height + 20
            return CGSize(width: view.frame.size.width, height: height)
        }
        return CGSize.zero
    }
    
    func estimatedFrameFor(text: String) -> CGRect {
        let size = CGSize(width: 200, height: CGFloat.greatestFiniteMagnitude)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
    
    //MARK:- Cell Configuration Methods
    func configureChatMessageCellFor(indexPath: IndexPath) -> ChatMessageCollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.chatMessagesCellID.rawValue, for: indexPath) as? ChatMessageCollectionViewCell{
            if let message = deviceData?.messages[indexPath.row].message {
                cell.messageTextView.text = message
                cell.bubbleViewWidthAnchor?.constant = estimatedFrameFor(text: message).size.width + 32
                cell.bubbleViewRightAnchor?.isActive = !(deviceData?.messages[indexPath.row].isReply ?? true)
                cell.bubbleViewLeftAnchor?.isActive = deviceData?.messages[indexPath.row].isReply ?? true
                cell.bubbleView.backgroundColor = (deviceData?.messages[indexPath.row].isReply ?? true) ? UIColor.sentBubbleColor : .white
                cell.messageTextView.textColor = (deviceData?.messages[indexPath.row].isReply ?? true) ? .white : .black
                cell.profileImageView.isHidden = (deviceData?.messages[indexPath.row].isReply ?? true) ? false : true
            }
      
            return cell
        }
        fatalError("Chat Message cell not found")
    }
  
}

