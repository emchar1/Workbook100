//
//  ImagePicker.swift
//  Workbook100
//
//  Created by Eddie Char on 5/15/22.
//

import UIKit

protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?)
}

class ImagePicker: NSObject {
    private let pickerController = UIImagePickerController()
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
    }
    
    func present(from sourceView: UIView) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = action(for: .camera, title: "Take Photo") {
            alertController.addAction(action)
        }
        if let action = action(for: .savedPhotosAlbum, title: "Camera Roll") {
            alertController.addAction(action)
        }
        if let action = action(for: .photoLibrary, title: "Photo Library") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        presentationController?.present(alertController, animated: true)
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else { return nil }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            pickerController.sourceType = type
            presentationController?.present(pickerController, animated: true)
        }
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickerController(picker, didSelect: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return pickerController(picker, didSelect: nil)
        }
        
        pickerController(picker, didSelect: image)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        
        delegate?.didSelect(image: image)
    }
}


extension ImagePicker: UINavigationControllerDelegate {
    
}
