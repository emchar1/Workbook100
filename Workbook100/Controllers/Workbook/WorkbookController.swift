//
//  WorkbookController.swift
//  Workbook100
//
//  Created by Eddie Char on 4/25/22.
//

import MessageUI
import UIKit
import Firebase
import FirebaseFirestoreSwift

class WorkbookController: UIViewController,
                          UICollectionViewDelegate,
                          UICollectionViewDataSource,
                          UICollectionViewDragDelegate,
                          UICollectionViewDropDelegate,
                          UIPopoverPresentationControllerDelegate,
                          ProductListControllerDelegate,
                          ImagePickerDelegate,
                          TextEntryControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var addSectionButton: UIBarButtonItem!
    
    let workbookName = "SP23 Apparel"
    var collectionView: UICollectionView!
    var imagePicker: ImagePicker!
    var workbookSections: [SectionModel]!
    var selectedIndexPath: IndexPath?
    
    // FIXME: - Can't delete this for now because it's used in drag/drop
    var dataColors: [[UIColor]] = [[.red, .orange, .systemPink, .yellow, .green, .cyan, .systemIndigo, .purple, .magenta],
                                   [.yellow, .green, .cyan],
                                   [.cyan, .blue, .purple],
                                   [.purple, .magenta, .systemPink]]
    
    //Firebase
    var docRef: DocumentReference!
    var docData: [String: Any]!
    
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = ImagePicker(presentationController: self, delegate: self)

        initializeFirestore()
        initializeCollectionView()
        initializeSections()
        
        collectionView.layoutSubviews()
    }
    
    private func initializeFirestore() {
        docRef = Firestore.firestore().collection(FIRManager.FIRWorkbooks.collection).document(workbookName)
        docData = [:]
    }
    
    private func initializeCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: makeLayout())

        collectionView.backgroundColor = UIColor(white: 0.1, alpha: 1.0)

        //Did this in lieu of viewDidLayoutSubviews() because this seems more elegant...
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = false

        //Register the various Collection View cells
        collectionView.collectionViewLayout.register(BackgroundSupplementaryView.self, forDecorationViewOfKind: BackgroundSupplementaryView.reuseID)
        collectionView.register(UINib(nibName: CollectionCell.reuseID, bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionView.register(UINib(nibName: CollectionCellGloves.reuseID, bundle: nil), forCellWithReuseIdentifier: CollectionCellGloves.reuseID)
        collectionView.register(CollectionCellPage.self, forCellWithReuseIdentifier: CollectionCellPage.reuseID)
        collectionView.register(CollectionCellBlank.self, forCellWithReuseIdentifier: CollectionCellBlank.reuseID)
        collectionView.register(CollectionCellImage.self, forCellWithReuseIdentifier: CollectionCellImage.reuseID)
        collectionView.register(CollectionCellText.self, forCellWithReuseIdentifier: CollectionCellText.reuseID)
        collectionView.register(CollectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: CollectionHeaderView.reuseID)
        
        //Finally, add the collectionView to the subview
        view.addSubview(collectionView)
    }
        
    private func initializeSections() {
        //Prevents crash while Firestore is loading the doc...
        workbookSections = []
        
        docRef.getDocument { (snapshot, error) in
            guard error == nil else {
                print("Error getting Section document: \(error!.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else { return }
            
            do {
                let sectionFIR: SectionFIR = try snapshot.data(as: SectionFIR.self)
                
                self.initializeSectionsHelper(sectionFIR: sectionFIR)
            }
            catch {
                print("Error dowloading Section Firestore data. Creating new workbook of size_1x1: \(error)")
                self.workbookSections = [SectionModel(id: 0, type: .size_1x1)]
                self.collectionView.reloadData()
            }
        }
    }
    
    private func initializeSectionsHelper(sectionFIR: SectionFIR) {
        for (index, sectionData) in sectionFIR.sections.enumerated() {
            let section = SectionModel(id: index, type: SectionType(rawValue: sectionData.type) ?? .size_1x1, data: sectionData.data)
            
            //This function seems sloppy, but it works!
            section.convertData(section.data, completion: { newSectionData in
                section.data = newSectionData
                self.workbookSections.append(section)
                
                //Need to sort because order of appending depends on if it's an image or not...
                self.workbookSections.sort { $0.id < $1.id }
                
                self.collectionView.reloadData()
            })
        }
    }
    
    
//    //This is replaced by collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        print("WorkbookController.viewDidLayoutSubviews()")
//
//        collectionView.frame = view.frame
//        collectionView.collectionViewLayout.invalidateLayout()
//    }
    
    
    
    // MARK: - UI Bar Button Items
    
    @IBAction func saveWorkbook(_ sender: UIBarButtonItem) {
        var sectionData: [Any] = []
        
        for (iindex, section) in workbookSections.enumerated() {
            var dataData: [Any] = []

            for (jindex, datum) in section.data.enumerated() {
                switch datum {
                case is SectionPlaceholder:
                    dataData.append(SectionModel.sectionSectionPlaceholder + "\((datum as! SectionPlaceholder).rawValue)")
                case is UIImage:
                    // FIXME: - Reuse image if it exists! - I think this can be deleted??? 6/19/22
//                    let imageString = UUID().uuidString + ".png"
//
//                    dataData.append(SectionModel.sectionImage + imageString)
//
//                    putInStorage(withData: (datum as! UIImage).pngData(), forFilename: imageString, contentType: "image/png")

                    
                    
                    let imageString = UUID().uuidString + ".png"
                    let imageRef = Storage.storage().reference().child("\((datum as! UIImage).pngData()!)")
                    
                    imageRef.getData(maxSize: SectionModel.maxImageSize * SectionModel.mb) { (data, error) in
                        if error == nil {
//                            dataData.append(SectionModel.sectionImage + /*This isn't right... --->*/"\(datum as! UIImage)")
                            print("Image already found!")
                        }
                        else {
//                            dataData.append(SectionModel.sectionImage + imageString)
                            
                            self.putInStorage(withData: (datum as! UIImage).pngData(), forFilename: imageString, contentType: "image/png")
                            print("Image not found!!")
                        }
                    }

                    dataData.append(SectionModel.sectionImage + imageString)
                case is SectionText:
                    let datumText = datum as! SectionText
                    dataData.append(SectionModel.sectionText + datumText.title + "|" + datumText.description)
                case is CollectionModel:
                    dataData.append(SectionModel.sectionItem + (workbookSections[iindex].data[jindex] as! CollectionModel).skuCode)
                default:
                    print("Unknown datum")
                }
            }
            
            sectionData.append([SectionNaming.type: section.type.rawValue, SectionNaming.data: dataData])
        }
        
        docData[SectionNaming.sections] = sectionData
        docRef.setData(docData)
        
        print("Workbook saved!")
    }
    
    @IBAction func addSection(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Section", message: "Select a Section to Add:", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "One by One", style: .default, handler: { _ in
            if let highestSection = (self.workbookSections.max { first, second in first.id < second.id }) {
                self.didAddSection(id: highestSection.id, type: .size_1x1)
            }
        }))
                                  
        alertController.addAction(UIAlertAction(title: "Two by One", style: .default, handler: { _ in
            if let highestSection = (self.workbookSections.max { first, second in first.id < second.id }) {
                self.didAddSection(id: highestSection.id, type: .size_2x1)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Two by One Reversed", style: .default, handler: { _ in
            if let highestSection = (self.workbookSections.max { first, second in first.id < second.id }) {
                self.didAddSection(id: highestSection.id, type: .size_2x1reversed)
            }
        }))

        alertController.addAction(UIAlertAction(title: "Six by Three", style: .default, handler: { _ in
            if let highestSection = (self.workbookSections.max { first, second in first.id < second.id }) {
                self.didAddSection(id: highestSection.id, type: .size_6x3)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "(Three by Three) by Two", style: .default, handler: { _ in
            if let highestSection = (self.workbookSections.max { first, second in first.id < second.id }) {
                self.didAddSection(id: highestSection.id, type: .size_3x3x2)
            }
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alertController, animated: true, completion: nil)
    }
    
    private func didAddSection(id: Int, type: SectionType) {
        self.workbookSections.append(SectionModel(id: id + 1, type: type))
        self.collectionView.reloadData()
        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: self.workbookSections.count - 1), at: .top, animated: true)
    }
    
    /**
     Saves the image to Firebase Storage.
     */
    private func putInStorage(withData data: Data?,
                              forFilename filename: String,
                              contentType metadataContentType: String) {
        guard let data = data else {
            print("Error creating data file.")
            return
        }
                
        let storageRef = Storage.storage().reference().child(filename)
        let metadata = StorageMetadata()
        metadata.contentType = metadataContentType
        
        let uploadTask = storageRef.putData(data, metadata: metadata) { (storageMetadata, error) in
            guard error == nil else {
                print("   Error uploading data to Firebase Storage: \(error!.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { (url, error) in
                guard let uploadURL = url else {
                    print("   Error with the uploadURL: \(error!.localizedDescription)")
                    return
                }
                
                print("   File uploaded: \(uploadURL)")
            }
        }
        
        //Do I need to capture all these???
//        uploadTask.observe(.resume) { (snapshot) in print("Upload resumed.....") }
//        uploadTask.observe(.pause) { (snapshot) in print("Upload paused.....") }
//        uploadTask.observe(.progress) { (snapshot) in print("Upload progress event.....") }
        uploadTask.observe(.success) { (snapshot) in print("Data upload SUCCESSFUL!") }
        uploadTask.observe(.failure) { (snapshot) in print("Data upload FAILED!") }
    }
}


// MARK: - Collection View Delegate and DataSource

extension WorkbookController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return workbookSections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workbookSections[section].data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        print("selectedIndexPath: \(selectedIndexPath!)")
        
        let comparisonValue = workbookSections[indexPath.section].data[indexPath.row]
        
        if comparisonValue is CollectionModel {
            performSegue(withIdentifier: "showDetailsTVC2", sender: nil)
        }
        else if let comparisonValue = comparisonValue as? SectionPlaceholder {
            if comparisonValue == .photo {
                imagePicker.present(from: collectionView)
            }
            else if comparisonValue == .text {
                let vc = TextEntryController()
                vc.view.backgroundColor = .white
                vc.delegate = self
                present(vc, animated: true)
            }
            else {
                let vc = ProductListController()
                vc.delegate = self
                present(vc, animated: true)
            }
        }

        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let comparisonValue = workbookSections[indexPath.section].data[indexPath.row]
        
        // FIXME: - Testing out CGAffineTransform
//        let itemScale: CGFloat = 0.5
        
        if let comparisonValue = comparisonValue as? SectionPlaceholder {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellBlank.reuseID, for: indexPath) as? CollectionCellBlank else { fatalError("Unknown collectionView cell returned!") }
            
            switch comparisonValue {
            case .photo:
                cell.contentView.backgroundColor = .systemGray4
            case .text:
                cell.contentView.backgroundColor = .systemGray5
                
//                cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            case .item:
                cell.contentView.backgroundColor = .systemGray6

//                cell.transform = CGAffineTransform(scaleX: itemScale, y: itemScale)
            }
            
            return cell
        }

        if let comparisonValue = comparisonValue as? CollectionModel {
            
            switch comparisonValue.productCategory {
            case "Gloves":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellGloves.reuseID, for: indexPath) as! CollectionCellGloves
                cell.setViews(with: comparisonValue)
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
                cell.setViews(with: comparisonValue)
                return cell
            }
            
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionCell else {
//                fatalError("Unknown collectionView cell returned!")
//            }
//
//            cell.setViews(with: comparisonValue)
//
//            // FIXME: - Testing out CGAffineTransform
////            cell.transform = CGAffineTransform(scaleX: itemScale, y: itemScale)
//
//            return cell
        }
                
        if let comparisonValue = comparisonValue as? UIImage {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellImage.reuseID, for: indexPath) as? CollectionCellImage else { fatalError("Unknown collectionView cell returned!") }
            
            cell.imageView.image = comparisonValue
            // FIXME: - Testing out CGAffineTransform
//            cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

            return cell
        }
        
        if let comparisonValue = comparisonValue as? SectionText {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellText.reuseID, for: indexPath) as? CollectionCellText else { fatalError("Unknown collectionView cell returned!") }
            
            cell.titleLabel.text = comparisonValue.title
            cell.descriptionLabel.text = comparisonValue.description
            // FIXME: - Testing out CGAffineTransform
//            cell.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)

            
            return cell
        }

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellBlank.reuseID, for: indexPath) as? CollectionCellBlank else { fatalError("Unknown collectionView cell returned!") }
        cell.contentView.backgroundColor = .lightGray
        return cell
    }
    
    // FIXME: - Footer not working
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderView.reuseID, for: indexPath) as? CollectionHeaderView else {
            fatalError("Could not dequeue SectionHeader")
        }
        
        headerView.label.text = "kj;lkj;l\(indexPath.section)"
        
        return headerView
    }
}
    
    
// MARK: - Collection View Compositional Layout
    
extension WorkbookController {
    private func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (section: Int,
                                                            environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            switch self.workbookSections[section].type {
            case .size_1x1: return self.layoutSection(widthCount: 1, heightCount: 1, sectionType: .size_1x1, padding: 0)
            case .size_2x1: return self.layoutSection(widthCount: 2, heightCount: 1, sectionType: .size_2x1, padding: 0)
            case .size_2x1reversed: return self.layoutSection(widthCount: 2, heightCount: 1, sectionType: .size_2x1reversed, padding: 0)
            case .size_6x3: return self.layoutSection(widthCount: 6, heightCount: 3, sectionType: .size_6x3)
            case .size_3x3x2: return self.layoutSectionWithSub()
            }
        }
        
        return layout
    }
    
    private func layoutSection(widthCount: Int, heightCount: Int, sectionType: SectionType, padding: CGFloat = 8) -> NSCollectionLayoutSection {
        var layoutItemSize: NSCollectionLayoutSize
        
        // FIXME: - Trying to get CollectionCell dimensions to be a specific size
        switch sectionType {
//        case .size_2x1, .size_2x1reversed:
//            layoutItemSize = NSCollectionLayoutSize(widthDimension: .absolute(1028), heightDimension: .absolute(800))
//        case .size_3x3x2:
//            layoutItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//        case .size_6x3:
//            layoutItemSize = NSCollectionLayoutSize(widthDimension: .absolute(CollectionCell.collectionCellWidth), heightDimension: .absolute(CollectionCell.collectionCellHeight))
//
//            print("collectionCellWidth: \(CollectionCell.collectionCellWidth), collectionCellHeight: \(CollectionCell.collectionCellHeight)")
        default:
            layoutItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        }
        
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: layoutItemSize)
        layoutItem.contentInsets = setContentInsets(padding: padding)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .fractionalWidth(SectionModel.aspectRatio / CGFloat(heightCount)))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitem: layoutItem, count: widthCount)
        
        let section = NSCollectionLayoutSection(group: layoutGroup)
        section.contentInsets = setContentInsets(padding: SectionModel.backgroundPadding + padding)
        section.decorationItems = setBackgroundItem(padding: SectionModel.backgroundPadding)
        
//        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
//        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: CollectionHeaderView.reuseID, alignment: .bottom)
//        section.boundarySupplementaryItems = [headerItem]

        return section
    }
    
    private func layoutSectionWithSub(padding: CGFloat = 8) -> NSCollectionLayoutSection {
        
        let layoutMainItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 2), heightDimension: .fractionalHeight(1))
        let layoutMainItem = NSCollectionLayoutItem(layoutSize: layoutMainItemSize)
        layoutMainItem.contentInsets = setContentInsets(padding: 0)

        let layoutSubItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 3), heightDimension: .fractionalHeight(1))
        let layoutSubItem = NSCollectionLayoutItem(layoutSize: layoutSubItemSize)
        layoutSubItem.contentInsets = setContentInsets(padding: padding)

        let layoutSubGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1 / 3))
        let layoutSubGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSubGroupSize, subitem: layoutSubItem, count: 3)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 2), heightDimension: .fractionalHeight(1))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitem: layoutSubGroup, count: 3)
        
        let layoutMainGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(SectionModel.aspectRatio))
        let layoutMainGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutMainGroupSize, subitems: [layoutGroup, layoutMainItem])

        let section = NSCollectionLayoutSection(group: layoutMainGroup)
        section.contentInsets = setContentInsets(padding: SectionModel.backgroundPadding + 0)
        section.decorationItems = setBackgroundItem(padding: SectionModel.backgroundPadding)
        
        return section
    }
    
    private func setContentInsets(padding: CGFloat) -> NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
    }
    
    private func setBackgroundItem(padding: CGFloat) -> [NSCollectionLayoutDecorationItem] {
        let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundSupplementaryView.reuseID)
        backgroundItem.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        
        return [backgroundItem]
    }
}


extension WorkbookController {
    // MARK: - Product List Controller Delegate

    func didSelect(item: CollectionModel) {
        guard let selectedIndexPath = selectedIndexPath else { return }
        
        workbookSections[selectedIndexPath.section].data[selectedIndexPath.row] = item
        collectionView.reloadData()
    }

    
    // MARK: - Image Picker Delegate

    func didSelect(image: UIImage?) {
        guard let image = image, let selectedIndexPath = selectedIndexPath else { return }
        
        workbookSections[selectedIndexPath.section].data[selectedIndexPath.row] = image
        collectionView.reloadData()
    }
    
    
    // MARK: - TextEntryController Delegate

    func saveText(text: SectionText) {
        guard let selectedIndexPath = selectedIndexPath else { return }
        
        workbookSections[selectedIndexPath.section].data[selectedIndexPath.row] = text
        collectionView.reloadData()
    }
}
