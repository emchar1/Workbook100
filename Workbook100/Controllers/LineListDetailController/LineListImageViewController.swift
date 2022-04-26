//
//  LineListImageViewController.swift
//  Workbook100
//
//  Created by Eddie Char on 3/22/22.
//

import UIKit

class LineListImageViewController: UIViewController, UIScrollViewDelegate {
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    var dismissButton: UIButton!
    var spinner = ActivitySpinner()
//    var imageArray: [String] = []
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up views
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 12.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        
        dismissButton = UIButton()
        dismissButton.setImage(UIImage(systemName: "multiply"), for: .normal)
        dismissButton.backgroundColor = .white
        dismissButton.tintColor = .black
        dismissButton.layer.cornerRadius = 12
        dismissButton.contentHorizontalAlignment = .center
        dismissButton.contentVerticalAlignment = .center
        dismissButton.addTarget(self, action: #selector(closeTapped(_:)), for: .touchUpInside)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dismissButton)
        
//        print(imageArray)
//        setupImages()
        
        //Set up constraints
        NSLayoutConstraint.activate([scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                                     view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)])
        
        NSLayoutConstraint.activate([imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                                     imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                                     imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
                                     imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)])
        
        NSLayoutConstraint.activate([dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                                     dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                     dismissButton.widthAnchor.constraint(equalToConstant: 24),
                                     dismissButton.heightAnchor.constraint(equalToConstant: 24)])
        
        
        //Double-tap to zoom
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapRecognizer)
        
        //Swipe to dismiss
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panRecognizer)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
//    private func setupImages() {
//        for i in 0..<imageArray.count {
//            imageView = UIImageView()
//            imageView.backgroundColor = .cyan
//            imageView.contentMode = .scaleAspectFit
//            imageView.translatesAutoresizingMaskIntoConstraints = false
//
////            let xPosition = UIScreen.main.bounds.width * CGFloat(i)
////            imageView.frame = CGRect(x: xPosition, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//            scrollView.contentSize.width = UIScreen.main.bounds.width * CGFloat(i + 1)
//            scrollView.addSubview(imageView)
//
//            NSLayoutConstraint.activate([imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//                                         imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
//                                         imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
//                                         imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)])
//
//            if let url = URL(string: imageArray[i]) {
//                self.spinner.startSpinner(in: imageView)
//                imageView.loadImage(at: url, completion: { self.spinner.stopSpinner() })
//            }
//        }
//    }
    
    @objc func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.maximumZoomScale / 4, animated: true)
        }
        else {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: view)
            
            if abs(viewTranslation.x) < abs(viewTranslation.y) {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                })
            }
        case .ended:
            if abs(viewTranslation.y) < 50 || abs(sender.velocity(in: view).y / 60) < 8 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = .identity
                })
            }
            else {
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    @objc func closeTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
