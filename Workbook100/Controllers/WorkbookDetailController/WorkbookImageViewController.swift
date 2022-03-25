//
//  WorkbookImageViewController.swift
//  Workbook100
//
//  Created by Eddie Char on 3/22/22.
//

import UIKit

class WorkbookImageViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var imageViewTop: NSLayoutConstraint!
    var imageViewLeading: NSLayoutConstraint!
    var imageViewTrailing: NSLayoutConstraint!
    var imageViewBottom: NSLayoutConstraint!

    var spinner = ActivitySpinner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 12.0
        
        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewTop = imageView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        imageViewLeading = imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
        imageViewTrailing = scrollView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        imageViewBottom = scrollView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        
//        addImageConstraints()

    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        if scrollView.zoomScale == scrollView.minimumZoomScale {
//            addImageConstraints()
//        }
//        else {
//            removeImageConstraints()
//        }
        return imageView
    }
    
    func addImageConstraints() {
        print("adding constraints")
        NSLayoutConstraint.activate([imageViewTop, imageViewLeading, imageViewTrailing, imageViewBottom])
    }
    
    func removeImageConstraints() {
        print("removing constraints")
        NSLayoutConstraint.deactivate([imageViewTop, imageViewLeading, imageViewTrailing, imageViewBottom])
    }
    
    
    @IBAction func doneTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
