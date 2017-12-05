//
//  ViewController.swift
//  PrintPDFTest
//
//  Created by Zion Perez on 12/4/17.
//  Copyright © 2017 Zion Perez. All rights reserved.
//

import UIKit
import WebKit

class MyViewController: UIViewController, WKUIDelegate {
    
    var tableHeight: Int = 745
    
    var webView: WKWebView!
    var htmlResource: String = "sample"
    
    var viewState: ViewState = ViewState.html
    var colorState: ColorState = ColorState.green
    var alignState: AlignState = AlignState.left
    
    enum ViewState {
        case html, portrait, landscape
    }
    enum ColorState: String {
        case green = "lightgreen"
        case red = "coral"
    }
    enum AlignState: String {
        case center = "center"
        case left = "left"
    }
    
    // US Letter paper size
    // https://stackoverflow.com/a/11809377/2179970
    // 612 x 792 points = 8.5 x 11 inch = 215.9 mm x 279.4 mm
    let USLetterWidth: CGFloat = 612
    let USLetterHeight: CGFloat = 792
    
    // WKUIDelegate function
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.isToolbarHidden = false
        htmlButtonPressed(self)
        self.title = "HTML Page " + tableHeight.description
    }
    
    func refreshView() {
        switch viewState {
        case ViewState.html:
            htmlButtonPressed(self)
        case ViewState.portrait:
            pdf1ButtonPressed(self)
        case ViewState.landscape:
            pdf2ButtonPressed(self)
        }
    }
    
    func getHTML() -> String? {
        let htmlPath: String? = Bundle.main.path(forResource: htmlResource, ofType: "html")
        guard let path = htmlPath else { return nil }
        do {
            // Load the HTML template code into a String variable.
            var html = try String(contentsOfFile: path)
            html = html.replacingOccurrences(of: "#HEIGHT#", with: tableHeight.description)
            html = html.replacingOccurrences(of: "#COLOR#", with: colorState.rawValue)
            html = html.replacingOccurrences(of: "#ALIGN#", with: alignState.rawValue)
            return html
        } catch {
            print("Error: " + error.localizedDescription)
        }
        return nil
    }
    
    func loadErrorPage() {
        let myURL = URL(string: "https://www.apple.com/5y33326")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        self.navigationController?.title = "Error"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    @IBAction func rewindPressed(_ sender: Any) {
        tableHeight = tableHeight-10
        refreshView()
    }
    
    @IBAction func forwardPressed(_ sender: Any) {
        tableHeight = tableHeight+10
        refreshView()
    }
    
    @IBAction func htmlButtonPressed(_ sender: Any) {
        if let html = getHTML() {
            webView.loadHTMLString(html, baseURL: nil)
            self.title = "HTML Page " + tableHeight.description
            viewState = ViewState.html
        } else {
            loadErrorPage()
        }
    }
    
    // Portrait PDF Button
    @IBAction func pdf1ButtonPressed(_ sender: Any) {
        if let html = getHTML() {
            let frame = CGRect(x: 0.0, y: 0.0, width: USLetterWidth, height: USLetterHeight)
            let data = PDFBuilder.exportHTMLToPDF(html: html, frame: frame)
            var baseURL: URL = URL(fileURLWithPath: Bundle.main.path(forResource: htmlResource, ofType: "html")!)
            baseURL.deleteLastPathComponent()
            webView.load(data, mimeType: "application/pdf", characterEncodingName:"", baseURL: baseURL)
            self.title = "PDF Portrait " + tableHeight.description
            viewState = ViewState.portrait
        } else {
            loadErrorPage()
        }
    }
    
    // Landscape PDF Button
    @IBAction func pdf2ButtonPressed(_ sender: Any) {
        if let html = getHTML() {
            let frame = CGRect(x: 0.0, y: 0.0, width: USLetterHeight, height: USLetterWidth)
            let data = PDFBuilder.exportHTMLToPDF(html: html, frame: frame)
            var baseURL: URL = URL(fileURLWithPath: Bundle.main.path(forResource: htmlResource, ofType: "html")!)
            baseURL.deleteLastPathComponent()
            webView.load(data, mimeType: "application/pdf", characterEncodingName:"", baseURL: baseURL)
            self.title = "PDF Landscape " + tableHeight.description
            viewState = ViewState.landscape
        } else {
            loadErrorPage()
        }
    }
    
    // Green Button
    @IBAction func greenButtonPressed(_ sender: Any) {
        colorState = ColorState.green
        alignState = AlignState.left
        refreshView()
    }
    
    // Red Button
    @IBAction func redButtonPressed(_ sender: Any) {
        colorState = ColorState.red
        alignState = AlignState.center
        refreshView()
    }
}

