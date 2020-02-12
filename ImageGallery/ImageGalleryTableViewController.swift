//
//  ImageGalleryTableViewController.swift
//  ImageGallery
//
//  Created by JiyeonKim on 2019/10/21.
//  Copyright © 2019 JiyeonKim. All rights reserved.
//

import UIKit

class ImageGalleryTableViewController: UITableViewController{
    
    var imageGalleryDocument: [ImageGallery] = [ImageGallery]()
    
    var deleteGalleryDocument = [ImageGallery]()
    
    /// 테이블 뷰의 섹션
    var sections = ["", ""]
    
    /// "Untitled" 뒤에 붙을 숫자
    var uniqueNameNumber = 1
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.tableView.reloadData()
        
        // MARK: 여기서 section 0에 있는 모든 애들의 textField.resignFirstResponder() 해줘야 함.
        if let sectionZero = tableView.indexPathsForVisibleRows {
            print("sectionZero = \(sectionZero.count)")
            
            for cell in sectionZero {
                if let cell = tableView.cellForRow(at: cell), let currentCell = cell as? ImageGalleryTableViewCell {
                    currentCell.textField.resignFirstResponder()
                    currentCell.textField.isUserInteractionEnabled = false
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hint 17번 (detail의 위쪽에 < 버튼을 더해서, table view를 스와이프로 없애는 대신 버튼을 눌러 없앨 수도 있음.)
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        
        let documentCell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath) as! ImageGalleryTableViewCell
        let deletedCell = tableView.dequeueReusableCell(withIdentifier: "DeletedCell", for: indexPath)
        
        if indexPath.section == 0 {
            documentCell.textField.text = imageGalleryDocument[indexPath.row].galleryName
            documentCell.tapSetting()
            return documentCell
        } else {
            deletedCell.textLabel?.text = deleteGalleryDocument[indexPath.row].galleryName
            return deletedCell
        }
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectRow = tableView.cellForRow(at: indexPath)
        
        if let selectCell = selectRow as? ImageGalleryTableViewCell {
            selectCell.textField.isUserInteractionEnabled = true
        }
    }
    
    override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        let deSelectRow = tableView.cellForRow(at: indexPath)
        
        if let deSelectCell = deSelectRow as? ImageGalleryTableViewCell {
            deSelectCell.textField.resignFirstResponder()
            deSelectCell.textField.isUserInteractionEnabled = false
        }
        
        return indexPath
    }
    
    @IBAction func newImageGallery(_ sender: UIBarButtonItem) {
        let newGallery = ImageGallery()
        
        newGallery.galleryName = "Untitled" + String(uniqueNameNumber)
        imageGalleryDocument.append(newGallery)
        
        uniqueNameNumber += 1
        
        //tableView.reloadData()
        tableView.beginUpdates()
        
        let animateIndex = IndexPath(row: (self.imageGalleryDocument.count - 1), section: 0)
        tableView.insertRows(at: [animateIndex], with: .fade)
        tableView.endUpdates()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // master에 해당하는 table view가 항상 떠있는게 아니라, 스와이프하면 집어넣고, 다시 꺼내는 것도 가능하게 함.
        if splitViewController?.preferredDisplayMode != .primaryOverlay {
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let galleryView = segue.destination.contents as? ImageGalleryViewController {
            // 사용자가 section 0에서 보고자하는 gallery를 선택했을 때.
            if let selectGalleryName = (sender as? ImageGalleryTableViewCell)?.textField.text {
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
    // 이 함수가 prepare(for segue:, sender:)보다 먼저 호출된다.
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        // ImageGalleryTableViewCell에 있는 핸들러로, textfield 수정 후 엔터치면 여기가 수행됨.
        (sender as? ImageGalleryTableViewCell)?.resignationHandler = { newName in
            
            if let cellIndex = self.tableView.indexPathForSelectedRow?.row {
                self.imageGalleryDocument[cellIndex].galleryName = newName
            }
            self.performSegue(withIdentifier: "SelectDocument", sender: sender)
        }
        
        // 일반적으로 사용자가 table cell을 직접 눌렀을 때, 실햄됨.
        if identifier == "SelectDocument"{
            return true
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
