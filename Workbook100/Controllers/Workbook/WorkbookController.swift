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
//                          UICollectionViewDragDelegate,
//                          UICollectionViewDropDelegate,
                          UIPopoverPresentationControllerDelegate,
                          ProductListControllerDelegate,
                          ImagePickerDelegate,
                          TextEntryControllerDelegate
{
    
    // MARK: - Properties
    
    @IBOutlet weak var loadSaveButton: UIBarButtonItem!
    @IBOutlet weak var addSectionButton: UIBarButtonItem!
    
    let workbookName = "SP23 Apparel"
    var collectionView: UICollectionView!
    var imagePicker: ImagePicker!
    var workbookSections: [SectionModel]!
    var selectedIndexPath: IndexPath?
    
    // FIXME: - Can't delete this for now because it's used in drag/drop
//    var dataColors: [[UIColor]] = [[.red, .orange, .systemPink, .yellow, .green, .cyan, .systemIndigo, .purple, .magenta],
//                                   [.yellow, .green, .cyan],
//                                   [.cyan, .blue, .purple],
//                                   [.purple, .magenta, .systemPink]]
    
    //Firebase
    var collectionRef: CollectionReference!
    var listener: ListenerRegistration!
    var docRef: DocumentReference!
    var docData: [String: Any]!
    var workbookList = [String]()
    
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = ImagePicker(presentationController: self, delegate: self)

        initializeFirestore()
        initializeCollectionView()
        loadWorkbook()
        addLoadSaveMenu()
        
        collectionView.layoutSubviews()
        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(orientationDidChange(_:)),
//                                               name: UIDevice.orientationDidChangeNotification,
//                                               object: nil)
    }
    
    private func initializeFirestore() {
        collectionRef = Firestore.firestore().collection(FIRManager.FIRWorkbooks.collection)
        docRef = Firestore.firestore().collection(FIRManager.FIRWorkbooks.collection).document(workbookName)
        docData = [:]
        
        listener = collectionRef.addSnapshotListener { snapshot, error in
            guard error == nil else { return print("Error getting workbook list: \(error!)") }
            
            self.workbookList = []
            
            for document in snapshot!.documents {
                self.workbookList.append(document.documentID)
            }
        }
    }
    
    private func initializeCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: makeLayout())

        collectionView.backgroundColor = UIColor(white: 0.1, alpha: 1.0)

        //Did this in lieu of viewDidLayoutSubviews() because this seems more elegant...
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.dragDelegate = self
//        collectionView.dropDelegate = self
//        collectionView.dragInteractionEnabled = false

        //Register the various Collection View cells
        collectionView.register(CollectionCellPage.self, forCellWithReuseIdentifier: CollectionCellPage.reuseID)
        collectionView.register(CollectionCellBlank.self, forCellWithReuseIdentifier: CollectionCellBlank.reuseID)
        collectionView.register(CollectionCellImage.self, forCellWithReuseIdentifier: CollectionCellImage.reuseID)
        collectionView.register(CollectionCellText.self, forCellWithReuseIdentifier: CollectionCellText.reuseID)
        collectionView.register(CollectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: CollectionHeaderView.reuseID)
        collectionView.register(UINib(nibName: CollectionCell.reuseID, bundle: nil),
                                forCellWithReuseIdentifier: CollectionCell.reuseID)
        collectionView.register(UINib(nibName: CollectionCellGloves.reuseID, bundle: nil),
                                forCellWithReuseIdentifier: CollectionCellGloves.reuseID)
        collectionView.collectionViewLayout.register(BackgroundSupplementaryView.self,
                                                     forDecorationViewOfKind: BackgroundSupplementaryView.reuseID)

        //Finally, add the collectionView to the subview
        view.addSubview(collectionView)
    }
        
    private func loadWorkbook() {
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
                
                self.loadWorkbookHelper(sectionFIR: sectionFIR)
            }
            catch {
                print("Error dowloading Section Firestore data. Creating new workbook of size_1x1: \(error)")
                self.workbookSections = [SectionModel(id: 0, type: .size_1x1)]
                self.collectionView.reloadData()
            }
        }
    }
    
    private func loadWorkbookHelper(sectionFIR: SectionFIR) {
        for (index, sectionData) in sectionFIR.sections.enumerated() {
            let section = SectionModel(id: index, type: SectionType(rawValue: sectionData.type) ?? .size_1x1, data: sectionData.data)
            
            //This function seems sloppy, but it works!
            section.convertData(section.data, completion: { newSectionData in
                section.data = newSectionData
                self.workbookSections.append(section)
                
                //Need to sort because order of appending depends on if it's an image or not...
                self.workbookSections.sort { $0.id < $1.id }
                
                self.collectionView.reloadData()
                self.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            })
        }
    }
    
    
    //    @objc private func orientationDidChange(_ notification: NSNotification) {
////        for workbookSection in workbookSections {
////            for comparisonValue in workbookSection.data {
////                guard let model = comparisonValue as? CollectionModel else { continue }
////
////
////            }
////        }
//
//        for cell in collectionView.visibleCells {
//            if let cell = cell as? CollectionCell {
//
////                collectionView.collectionViewLayout = makeLayout()
//                cell.calculateScaleTransform(cellSize: getCellSize(widthCount: 6, heightCount: 3))
//            }
//        }
//
//        collectionView.reloadData()
//        print("rotated")
//    }
    
    
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
    
    private func addLoadSaveMenu() {
        let menuItems: [UIAction] = [
            UIAction(title: "New", image: nil,  handler: { action in
                self.newMenuSelected()
            }),
            
            UIAction(title: "Load", image: nil, handler: { action in
                self.loadMenuSelected()
            }),
            
            UIAction(title: "Save", image: nil, handler: { action in
                self.saveMenuSelected()
            })
        ]
        
        loadSaveButton.menu = UIMenu(title: "Create Workbook", image: nil, options: .displayInline, children: menuItems)
    }
    
    private func newMenuSelected() {
        
    }
    
    private func loadMenuSelected() {
        let alert = UIAlertController(title: "Load Workbook", message: "Select a Workbook to load", preferredStyle: .alert)
        
        for workbook in self.workbookList {
            alert.addAction(UIAlertAction(title: workbook, style: .default, handler: { action in
                self.docRef = Firestore.firestore().collection(FIRManager.FIRWorkbooks.collection).document(workbook)
                self.loadWorkbook()
                self.showHUD(label: "Loading Workbook...")
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func saveMenuSelected() {
        let alert = UIAlertController(title: "Save Workbook", message: "Save changes to \(docRef.documentID)?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            var sectionData: [Any] = []
            
            for (iindex, section) in self.workbookSections.enumerated() {
                var dataData: [Any] = []

                for (jindex, datum) in section.data.enumerated() {
                    switch datum {
                    case is SectionPlaceholder:
                        dataData.append(SectionModel.sectionSectionPlaceholder + "\((datum as! SectionPlaceholder).rawValue)")
                    case is UIImage:
                        let imageString = UUID().uuidString + ".png"
                        let imageRef = Storage.storage().reference().child("\((datum as! UIImage).pngData()!)")
                        
                        imageRef.getData(maxSize: SectionModel.maxImageSize * SectionModel.mb) { (data, error) in
                            if error == nil {
                                print("Image already found!")
                            }
                            else {
                                self.putInStorage(withData: (datum as! UIImage).pngData(), forFilename: imageString, contentType: "image/png")
                                print("Image not found!!")
                            }
                        }

                        dataData.append(SectionModel.sectionImage + imageString)
                    case is SectionText:
                        let datumText = datum as! SectionText
                        dataData.append(SectionModel.sectionText + datumText.title + "|" + datumText.description)
                    case is CollectionModel:
                        dataData.append(SectionModel.sectionItem + (self.workbookSections[iindex].data[jindex] as! CollectionModel).skuCode)
                    default:
                        print("Unknown datum")
                    }
                }
                
                sectionData.append([SectionNaming.type: section.type.rawValue, SectionNaming.data: dataData])
            }
            
            self.docData[SectionNaming.sections] = sectionData
            self.docRef.setData(self.docData)
            
            self.showHUD(label: "Saving Workbook...")
        }))
        
        alert.addAction(UIAlertAction(title: "Don't Save", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showHUD(label: String) {
        let hudLabel = UILabel()
        hudLabel.text = label
        hudLabel.textAlignment = .center
        hudLabel.textColor = .white
        hudLabel.numberOfLines = 0
        hudLabel.font = UIFont.workbookNoimg
        hudLabel.backgroundColor = .black
        hudLabel.alpha = 1.0
        hudLabel.layer.cornerRadius = 8
        hudLabel.clipsToBounds = true
        hudLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(hudLabel)
        NSLayoutConstraint.activate([hudLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                     hudLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                                     hudLabel.widthAnchor.constraint(equalToConstant: 200),
                                     hudLabel.heightAnchor.constraint(equalToConstant: 100)])
        
        let spinner = ActivitySpinner()
        spinner.startSpinner(in: self.view)
        
        UIView.animate(withDuration: 0.5, delay: 2.0, options: [], animations: {
            hudLabel.alpha = 0
            
        }, completion: { _ in
            spinner.stopSpinner()
            hudLabel.removeFromSuperview()
        })
    }
    
    //I had to unlink this because adding an action to the button will prevent tapping to show the UIMenu.
    @IBAction func loadSavePressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func addSectionPressed(_ sender: UIBarButtonItem) {
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
        
        alertController.addAction(UIAlertAction(title: "Two by (Three by Three)", style: .default, handler: { _ in
            if let highestSection = (self.workbookSections.max { first, second in first.id < second.id }) {
                self.didAddSection(id: highestSection.id, type: .size_2x3x3)
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
    private func putInStorage(withData data: Data?, forFilename filename: String, contentType metadataContentType: String) {
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
        
        switch comparisonValue {
        case is SectionPlaceholder:
            let comparisonValue = comparisonValue as! SectionPlaceholder
            
            switch comparisonValue {
            case .photo:
                imagePicker.present(from: collectionView)
            case .text:
                let vc = TextEntryController()
                vc.view.backgroundColor = .white
                vc.delegate = self
                present(vc, animated: true)
            case .item:
                let vc = ProductListController()
                vc.delegate = self
                present(vc, animated: true)
            }
        case is CollectionModel:
            let vc = ProductListController()
            vc.delegate = self
            present(vc, animated: true)
        case is UIImage:
            imagePicker.present(from: collectionView)
        case is SectionText:
            let comparisonValue = comparisonValue as! SectionText
            
            let vc = TextEntryController()
            vc.view.backgroundColor = .white
            vc.delegate = self
            vc.titleTF.text = comparisonValue.title
            vc.descriptionTF.text = comparisonValue.description
            
            present(vc, animated: true)
        default:
            print("Unknown cell type!")
        }

        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let comparisonValue = workbookSections[indexPath.section].data[indexPath.row]
        
        if let placeholder = comparisonValue as? SectionPlaceholder {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellBlank.reuseID, for: indexPath) as? CollectionCellBlank else { fatalError("Unknown collectionView cell returned!") }
            
            switch placeholder {
            case .photo:
                cell.contentView.backgroundColor = .systemGray4
            case .text:
                cell.contentView.backgroundColor = .systemGray5
            case .item:
                cell.contentView.backgroundColor = .systemGray6
            }
            
            return cell
        }

        if let model = comparisonValue as? CollectionModel {
            
            switch model.productCategory {
            case "Gloves":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellGloves.reuseID, for: indexPath) as! CollectionCellGloves
                cell.setViews(with: model)
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.reuseID, for: indexPath) as! CollectionCell
                cell.setViews(with: model)
//                cell.calculateScaleTransform(cellSize: getCellSize(widthCount: 6, heightCount: 3))
                return cell
            }
        }
                
        if let img = comparisonValue as? UIImage {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellImage.reuseID, for: indexPath) as? CollectionCellImage else { fatalError("Unknown collectionView cell returned!") }
            
            cell.imageView.image = img

            return cell
        }
        
        if let text = comparisonValue as? SectionText {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellText.reuseID, for: indexPath) as? CollectionCellText else { fatalError("Unknown collectionView cell returned!") }
            
            cell.titleLabel.text = text.title
            cell.descriptionLabel.text = text.description
            
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
            case .size_2x3x3: return self.layoutSectionWithSub(reversed: true)
            }
        }
        
        return layout
    }
    
    private func layoutSection(widthCount: Int, heightCount: Int, sectionType: SectionType, padding: CGFloat = 8) -> NSCollectionLayoutSection {

        // FIXME: - Trying to get CollectionCell dimensions to be a specific size
//        var layoutItemSize: NSCollectionLayoutSize
//        switch sectionType {
//        case .size_2x1, .size_2x1reversed:
//            layoutItemSize = NSCollectionLayoutSize(widthDimension: .absolute(1028), heightDimension: .absolute(800))
//        case .size_3x3x2:
//            layoutItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//        case .size_6x3:
//            layoutItemSize = NSCollectionLayoutSize(widthDimension: .absolute(CollectionCell.collectionCellWidth), heightDimension: .absolute(CollectionCell.collectionCellHeight))
//
//            print("collectionCellWidth: \(CollectionCell.collectionCellWidth), collectionCellHeight: \(CollectionCell.collectionCellHeight)")
//        default:
//            layoutItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//        }
        
        
        let layoutItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: layoutItemSize)
        layoutItem.contentInsets = setContentInsets(padding: padding)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .fractionalWidth(SectionModel.aspectRatio / CGFloat(heightCount)))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitem: layoutItem, count: widthCount)
        
        let section = NSCollectionLayoutSection(group: layoutGroup)
        section.contentInsets = setContentInsets(padding: SectionModel.backgroundPadding + 0)
        section.decorationItems = setBackgroundItem(padding: SectionModel.backgroundPadding)
        
//        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
//        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: CollectionHeaderView.reuseID, alignment: .bottom)
//        section.boundarySupplementaryItems = [headerItem]

        return section
    }
    
    private func layoutSectionWithSub(reversed: Bool = false, padding: CGFloat = 8) -> NSCollectionLayoutSection {
        
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
        let layoutMainGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutMainGroupSize, subitems: reversed ? [layoutMainItem, layoutGroup] : [layoutGroup, layoutMainItem])

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
    
//    private func getCellSize(widthCount: Int, heightCount: Int, padding: CGFloat = 8) -> CGSize {
//        func totalPaddingFor(_ count: Int) -> CGFloat {
//            return 2 * padding - 2 * padding * (CGFloat(count) - 1)
//        }
//
//        let cellWidth = (view.frame.width - 2 * SectionModel.backgroundPadding - totalPaddingFor(widthCount)) / CGFloat(widthCount)
//        let cellHeight = ((view.frame.width - 2 * SectionModel.backgroundPadding) * SectionModel.aspectRatio - totalPaddingFor(heightCount)) / CGFloat(heightCount)
//
//        print(CGSize(width: cellWidth, height: cellHeight))
//
//        return CGSize(width: cellWidth, height: cellHeight)
//    }
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
