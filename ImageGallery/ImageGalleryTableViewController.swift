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
            //cell.textLabel?.text = imageGalleryDocument[indexPath.row]
            cell.textLabel?.text = imageGalleryDocument[indexPath.row].galleryName
        } else {
            cell.textLabel?.text = deleteGalleryDocument[indexPath.row]
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            if indexPath.section == 0 {
                let deleteTitle = imageGalleryDocument[indexPath.row].galleryName
                
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
}
