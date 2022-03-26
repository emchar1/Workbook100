//
//  WorkbookImageViewController.swift
//  Workbook100
//
//  Created by Eddie Char on 3/22/22.
//

import UIKit

class WorkbookImageViewController: UIViewController, UIScrollViewDelegate {
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    
    var spinner = ActivitySpinner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up views
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 12.0
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        
        //Set up constraints
        NSLayoutConstraint.activate([scrollView.topAnchor.constraint(equalTo: view.topAnchor),
                                     scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                                     view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)])
        
        NSLayoutConstraint.activate([imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                                     imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                                     imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
                                     imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)])
        
        
        //Double-tap to zoom
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapRecognizer)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @objc func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.maximumZoomScale / 4, animated: true)
        }
        else {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }
    
    @IBAction func doneTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
