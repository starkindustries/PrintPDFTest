//
//  PDFBuilder.swift
//  PrintPDFTest
//
//  Created by Zion Perez on 12/4/17.
//  Copyright © 2017 Zion Perez. All rights reserved.
//

import Foundation
import UIKit

struct PDFBuilder {
    
    static func exportHTMLToPDF(html: String, frame: CGRect) -> Data {                
        // Print2PDF from AppCoda
        // https://www.appcoda.com/pdf-generation-ios/
        
        // Set a printable frame and inset
        // This pageFrame var is the size of the page desired. Set this appropriately for landscape or portrait.
        // let pageFrame = CGRect(x: 0.0, y: 0.0, width: USLetterWidth, height: USLetterHeight)
        let pageFrame = frame
        let insetRect = pageFrame.insetBy(dx: 10.0, dy: 10.0)
        
        // Create a UIPrintPageRenderer and set the paperRect and printableRect using above values.
        // PaperRect is the area on the page that will be used for the print (paper size).
        // PrintableRect is the printable area.
        let pageRenderer = UIPrintPageRenderer()
        pageRenderer.setValue(pageFrame, forKey: "paperRect")
        pageRenderer.setValue(insetRect, forKey: "printableRect")
        
        // Create a printFormatter and pass the HTML code as a string.
        let printFormatter = UIMarkupTextPrintFormatter(markupText: html)
        
        // Add the printFormatter to the pageRenderer
        pageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        
        // This data var is where the PDF will be stored once created.
        let data = NSMutableData()
        
        // This is where the PDF gets drawn.
        UIGraphicsBeginPDFContextToData(data, pageFrame, nil)
        UIGraphicsBeginPDFPage()
        pageRenderer.drawPage(at: 0, in: UIGraphicsGetPDFContextBounds())
        print("bounds: " + UIGraphicsGetPDFContextBounds().debugDescription)        
        UIGraphicsEndPDFContext()
        
        return data as Data
    }
}
