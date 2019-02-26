//
//  EntryDetailViewController.swift
//  JournalCloudKit
//
//  Created by Deniz Tutuncu on 2/25/19.
//  Copyright © 2019 Deniz Tutuncu. All rights reserved.
//

import UIKit
import CloudKit

class EntryDetailViewController: UIViewController {
    
    private let entryController = EntryController()
    
    private func updateViews() {
        guard let entry = entry, isViewLoaded  else { return }
        
        titleTextField.text = entry.title
        entryTextView.text = entry.bodyText
    }
    
    var entry: Entry? {
        didSet {
            DispatchQueue.main.async {
                self.updateViews()
                self.loadViewIfNeeded()
            }
        }
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, !title.isEmpty, let bodyText = entryTextView.text, !bodyText.isEmpty else { return }
        
        if let entry = entry {
            // Update Entry
        } else {
            // Add new Entry
            self.entryController.addEntryWith(title: title, bodyText: bodyText, completion: { (success) in
                if success {
                    print("Success adding new entry")
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            })
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        titleTextField.text = ""
        entryTextView.text = ""
    }
}

extension EntryDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
