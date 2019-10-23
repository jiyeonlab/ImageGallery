//
//  ImageGalleryTableViewController.swift
//  ImageGallery
//
//  Created by JiyeonKim on 2019/10/21.
//  Copyright © 2019 JiyeonKim. All rights reserved.
//

import UIKit

class ImageGalleryTableViewController: UITableViewController{
    
    var imageGalleryDocument : [ImageGallery] = {
        var newDocument = [ImageGallery]()
        var document1 = ImageGallery()
        document1.galleryName = "Document1"
        newDocument.append(document1)
        
        return newDocument
    }()
    
    var deleteGalleryDocument = [ImageGallery]()
    
    let sections = ["", "Recently Deleted"]
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return imageGalleryDocument.count
        } else {
            return deleteGalleryDocument.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)
        
        // Configure the cell...
        if indexPath.section == 0 {
            //cell.textLabel?.text = imageGalleryDocument[indexPath.row]
            cell.textLabel?.text = imageGalleryDocument[indexPath.row].galleryName
        } else {
            cell.textLabel?.text = deleteGalleryDocument[indexPath.row].galleryName
        }
        return cell
    }
    
    @IBAction func newImageGallery(_ sender: UIBarButtonItem) {
        let newGallery = ImageGallery()
        newGallery.galleryName = "Untitled"
        imageGalleryDocument.append(newGallery)
        
        print("newImageGallery 누른 후 Document count = \(imageGalleryDocument.count)")
        
        //imageGalleryDocument += ["Untitled".madeUnique(withRespectTo: imageGalleryDocument)]
        tableView.reloadData()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // master에 해당하는 table view가 항상 떠있는게 아니라, 스와이프하면 집어넣고, 다시 꺼내는 것도 가능하게 함.
        if splitViewController?.preferredDisplayMode != .primaryOverlay {
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//
//            if indexPath.section == 0 {
//                print("0")
//                let deleteTitle = imageGalleryDocument[indexPath.row].galleryName
//
//                imageGalleryDocument.remove(at: indexPath.row)
//                tableView.deleteRows(at: [indexPath], with: .fade)
//                deleteGalleryDocument += [deleteTitle]
//                tableView.reloadData()
//            }else {
//                print("1")
//                deleteGalleryDocument.remove(at: indexPath.row)
//                tableView.deleteRows(at: [indexPath], with: .fade)
//            }
//
//
//
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//
//        }
//    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("눌린 row index = \(indexPath.row)")
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let galleryView = segue.destination.contents as? ImageGalleryViewController {
            if let selectGalleryName = (sender as? UITableViewCell)?.textLabel?.text {
                galleryView.navigationItem.title = selectGalleryName
                
                // 여기서 imageGalleryDocument 내에 selectGalleryName을 가진 인스턴스를 찾아서, collection view에게 줘야함.
                if let selectNumber = imageGalleryDocument.firstIndex(where: {$0.galleryName == selectGalleryName}) {
                    galleryView.imageGallery = imageGalleryDocument[selectNumber]
                }
            }
           
            
        }
    }
    
    // tableCell의 왼쪽에 삭제가 뜨도록.
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0 {
            let deleteToRecentlyDelete = UIContextualAction(style: .destructive, title: "삭제") { (_, _, success) in
                let deleteGallery = self.imageGalleryDocument[indexPath.row]
                
                self.imageGalleryDocument.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                //self.deleteGalleryDocument += [deleteTitle]
                
                self.deleteGalleryDocument.append(deleteGallery)
                //tableView.reloadData()
                tableView.beginUpdates()
                let animateIndex = IndexPath(row: (self.deleteGalleryDocument.count - 1), section: 1)
                tableView.insertRows(at: [animateIndex], with: .fade)
                tableView.endUpdates()
            }
            return UISwipeActionsConfiguration(actions: [deleteToRecentlyDelete])
        }else {
            // Recently Delete에서 영구 삭제하기.
            let deletePermanently = UIContextualAction(style: .destructive, title: "삭제") { (_, _, success) in
                
                //success(true)
                self.deleteGalleryDocument.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }

            return UISwipeActionsConfiguration(actions: [deletePermanently])
        }
    }
    
    //section 1 에서 다시 section 0으로 복구하고 싶을 때.
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 1 {
            let undelete = UIContextualAction(style: .normal, title: "복구") { (_, _, success) in
                let recoverGallery = self.deleteGalleryDocument[indexPath.row]
                
                self.deleteGalleryDocument.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                self.imageGalleryDocument.append(recoverGallery)
                //tableView.reloadData()
                tableView.beginUpdates()
                let animateIndex = IndexPath(row: (self.imageGalleryDocument.count - 1), section: 0)
                tableView.insertRows(at: [animateIndex], with: .fade)
                tableView.endUpdates()
                
            }
            return UISwipeActionsConfiguration(actions: [undelete])
        }else {
            return UISwipeActionsConfiguration()
        }
        
    }
}
