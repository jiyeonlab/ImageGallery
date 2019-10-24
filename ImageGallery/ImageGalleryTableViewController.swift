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
    
    var sections = ["", ""]
    
    var uniqueNameNumber = 1
    
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
        
        newGallery.galleryName = "Untitled"+String(uniqueNameNumber)
        //newGallery.galleryName = "Untitled".madeUnique(withRespectTo: imageGalleryDocument)
        imageGalleryDocument.append(newGallery)
        
        uniqueNameNumber += 1
        //print("newImageGallery 누른 후 Document count = \(imageGalleryDocument.count)")
        
        //tableView.reloadData()
        tableView.beginUpdates()
        let animateIndex = IndexPath(row: (self.imageGalleryDocument.count - 1), section: 0)
        tableView.insertRows(at: [animateIndex], with: .fade)
        tableView.endUpdates()
    }
    override func viewWillLayoutSubviews() {
        //print("layout subview")
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let galleryView = segue.destination.contents as? ImageGalleryViewController {
            // 사용자가 section 0에서 보고자하는 gallery를 선택했을 때.
            if let selectGalleryName = (sender as? UITableViewCell)?.textLabel?.text {
                galleryView.navigationItem.title = selectGalleryName
                
                // 여기서 imageGalleryDocument 내에 selectGalleryName을 가진 인스턴스를 찾아서, collection view에게 줘야함.
                if let selectNumber = imageGalleryDocument.firstIndex(where: {$0.galleryName == selectGalleryName}) {
                    galleryView.imageGallery = imageGalleryDocument[selectNumber]
                }
            }
            // 사용자가 section 0에서 gallery를 삭제하면 그 삭제된 gallery의 하나 앞의 gallery를 detail view에 보여주기 위한 코드.
            else if let afterDeleteSetting = (sender as? ImageGallery) {
                galleryView.navigationItem.title = afterDeleteSetting.galleryName
                
                galleryView.imageGallery = afterDeleteSetting
            }
        }
        
    }
    
    // section 1에 있는 cell들은 segue 하는 것을 막기 위해 추가.
    // 이 함수가 prepare(for segue, sender)보다 먼저 호출된다.
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "SelectDocument" {
            if let selectCell = (sender as? UITableViewCell) {
                if let selectSection = self.tableView.indexPath(for: selectCell)?.section, selectSection == 1 {
                    return false
                }else {
                    return true
                }
            }
        }
        
        return false
        
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
                
                // section 0에서 gallery를 삭제하면, 그 gallery가 detail view에 안뜨게 하기 위해 추가.
                if self.imageGalleryDocument.count != 0 {
                    if indexPath.row != 0 {
                        self.performSegue(withIdentifier: "SelectDocument", sender: self.imageGalleryDocument[indexPath.row - 1])
                    } else {
                        self.performSegue(withIdentifier: "SelectDocument", sender: self.imageGalleryDocument[indexPath.row])
                    }
                }
                
                if self.deleteGalleryDocument.count == 1 {
                    self.sections[1] = String("Recently Deleted")
                    tableView.reloadSections([1], with: .none)
                }
            }
            return UISwipeActionsConfiguration(actions: [deleteToRecentlyDelete])
        }else {
            // Recently Delete에서 영구 삭제하기.
            let deletePermanently = UIContextualAction(style: .destructive, title: "삭제") { (_, _, success) in
                
                tableView.performBatchUpdates({
                    self.deleteGalleryDocument.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadData()
                    
                    if self.deleteGalleryDocument.count == 0 {
                        self.sections[1] = String("")
                        tableView.reloadSections([1], with: .none)
                    }
                })
                
            }
            
            return UISwipeActionsConfiguration(actions: [deletePermanently])
        }
    }
    
    //section 1 에서 다시 section 0으로 복구하고 싶을 때.
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 1 {
            let undelete = UIContextualAction(style: .normal, title: "복구") { (_, _, success) in
                
                tableView.performBatchUpdates({
                    let recoverGallery = self.deleteGalleryDocument[indexPath.row]
                    
                    self.deleteGalleryDocument.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    
                    self.imageGalleryDocument.append(recoverGallery)
                    //tableView.reloadData()
                    tableView.beginUpdates()
                    let animateIndex = IndexPath(row: (self.imageGalleryDocument.count - 1), section: 0)
                    tableView.insertRows(at: [animateIndex], with: .fade)
                    tableView.endUpdates()
                    
                    if self.deleteGalleryDocument.count == 0 {
                        self.sections[1] = String("")
                        tableView.reloadSections([1], with: .none)
                    }
                })
            }
            return UISwipeActionsConfiguration(actions: [undelete])
        }else {
            return UISwipeActionsConfiguration()
        }
        
    }
}
