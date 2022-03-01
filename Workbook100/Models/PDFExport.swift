//
//  PDFExport.swift
//  Workbook100
//
//  Created by Eddie Char on 2/18/22.
//

import UIKit

extension UIView {
    typealias PDFOutput = (pdfFilePath: String, pdfData: NSMutableData?)

    /**
     Exports the PDF from save PDF in directory and returns PDF file path.
     - returns: PDF file path
     */
    func exportAsPDFFromView() -> PDFOutput {
        let pdfPageFrame = self.frame
        let pdfData = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
        
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return ("", nil) }
        
        self.layer.render(in: pdfContext)

        UIGraphicsEndPDFContext()
        
        return self.saveViewPDF(data: pdfData)
    }
    
    /**
     Saves the PDF file in document directory.
     */
    func saveViewPDF(data: NSMutableData) -> PDFOutput {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectoryPath = paths[0]
        let pdfPath = docDirectoryPath.appendingPathComponent("viewPDF.pdf")
        
        if data.write(to: pdfPath, atomically: true) {
            return (pdfPath.path, data)
        }
        else {
            return ("", nil)
        }
    }
    
}


extension UICollectionView {
    typealias PDFOutput = (pdfFilePath: String, pdfData: NSMutableData?)

    /**
     Exports the PDF from save PDF in directory and returns PDF file path.
     - returns: A tuple containing a PDF file path and the PDF data
     */
    func exportAsPDFFromCollectionView() -> PDFOutput {
        let originalBounds = self.bounds
        self.bounds = CGRect(x: originalBounds.origin.x, y: originalBounds.origin.y, width: self.contentSize.width, height: self.contentSize.height)

        let pdfPageFrame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        let pdfData = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
        
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return ("", nil) }
        self.layer.render(in: pdfContext)

        UIGraphicsEndPDFContext()
        
        return self.saveCollectionViewPDF(data: pdfData)
    }
    
    /**
     Saves the PDF file in document directory.
     - returns: A tuple containing a PDF file path and the PDF data
     */
    func saveCollectionViewPDF(data: NSMutableData) -> PDFOutput {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectoryPath = paths[0]
        let pdfPath = docDirectoryPath.appendingPathComponent("viewPDF.pdf")
        
        if data.write(to: pdfPath, atomically: true) {
            return (pdfPath.path, data)
        }
        else {
            return ("", nil)
        }
    }
    
}
