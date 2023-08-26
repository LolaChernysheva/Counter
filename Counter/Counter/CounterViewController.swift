//
//  CounterViewController.swift
//  Counter
//
//  Created by Лолита Чернышева on 26.08.2023.
//

import UIKit

class CounterViewController: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var resetCounterButton: UIButton!
    @IBOutlet weak var historyTextView: UITextView!
    
    //MARK: - Properties
    
    private var counterValue: Int = 0 {
        didSet {
            if counterValue < 0 {
                counterValue = 0
            }
            configureLabel()
        }
    }

    //MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        historyTextView.delegate = self
    }
    
    //MARK: - IBActions
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        counterValue = 0
        let currentTime = getCurrentTime()
        let newLine = "[\(currentTime)]: значение сброшено \n"
        appendNew(line: newLine)
    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        counterValue += 1
        let currentTime = getCurrentTime()
        let newLine = "[\(currentTime)]: cчетчик увеличен на 1 \n"
        appendNew(line: newLine)
    }
    
    @IBAction func minusButtonTapped(_ sender: Any) {
        counterValue -= 1
        let currentTime = getCurrentTime()
        let newLine = "[\(currentTime)]: cчетчик уменьшен на 1 \n"
        appendNew(line: newLine)
    }
    
    //MARK: - Private methods
    
    private func configureLabel() {
        counterLabel.text = "Значение счетчика: \(counterValue)"
    }
    
    private func configureView() {
        configureLabel()
        plusButton.layer.cornerRadius = 10
        minusButton.layer.cornerRadius = 10
    }
    
    private func getCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
    
    private func scrollToBottom() {
        let range = NSRange(location: historyTextView.text.count, length: 0)
        historyTextView.scrollRangeToVisible(range)
    }
    
    private func appendNew(line text: String) {
        historyTextView.text.append(text)
        scrollToBottom()
    }
}

extension CounterViewController:  UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        scrollToBottom()
    }
}

