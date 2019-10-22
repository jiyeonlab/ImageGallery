//
//  ImageGalleryTableViewController.swift
//  ImageGallery
//
//  Created by JiyeonKim on 2019/10/21.
//  Copyright © 2019 JiyeonKim. All rights reserved.
//

import UIKit

class ImageGalleryTableViewController: UITableViewController {
    
    var imageGalleryDocument = ["MyFirstGallery"]
    var deleteGalleryDocument = [String]()
    
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
            cell.textLabel?.text = imageGalleryDocument[indexPath.row]
        } else {
            cell.textLabel?.text = deleteGalleryDocument[indexPath.row]
        }
        return cell
    }
    
    @IBAction func newImageGallery(_ sender: UIBarButtonItem) {
        imageGalleryDocument += ["Untitled".madeUnique(withRespectTo: imageGalleryDocument)]
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            if indexPath.section == 0 {
                let deleteTitle = imageGalleryDocument[indexPath.row]
                
                imageGalleryDocument.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                deleteGalleryDocument += [deleteTitle]
                tableView.reloadData()
            }else {
                deleteGalleryDocument.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            
        }
    }
    
    
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let galleryView = segue.destination.contents as? ImageGalleryViewController {
            galleryView.navigationItem.title = (sender as? UITableViewCell)?.textLabel?.text
            //galleryView.
            print("model count ? = \(galleryView.images.count)")
        }
    }
    
    
}