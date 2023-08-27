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
            setMinusButtonEnabled()
        }
    }

    //MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        historyTextView.delegate = self
        setMinusButtonEnabled()
    }
    
    //MARK: - IBActions
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        updateCounter(by: -counterValue, with: "значение сброшено")
    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        updateCounter(by: 1, with: "cчетчик увеличен на")
        addScaleAnimation(into: plusButton)
    }
    
    @IBAction func minusButtonTapped(_ sender: Any) {
        updateCounter(by: -1, with: "cчетчик уменьшен на")
        addScaleAnimation(into: minusButton)

    }
    
    //MARK: - Private methods
    
    private func configureLabel() {
        counterLabel.text = "Значение счетчика: \(counterValue)"
    }
    
    private func setMinusButtonEnabled(){
        minusButton.isUserInteractionEnabled = counterValue <= 0 ? false : true
    }
    
    private func configureView() {
        configureLabel()
        plusButton.layer.cornerRadius = Metrics.cornerRadiusValue
        minusButton.layer.cornerRadius = Metrics.cornerRadiusValue
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
    
    private func updateCounter(by value: Int, with message: String) {
        counterValue += value
        let currentTime = getCurrentTime()
        let newLine = "[\(currentTime)]: \(message) \(value)\n"
        appendNew(line: newLine)
    }
    
    private func addScaleAnimation(into button: UIButton) {
        UIView.animate(withDuration: Metrics.duration, animations: {
            button.transform = CGAffineTransform(scaleX: Metrics.scale, y: Metrics.scale)
        }) { _ in
            UIView.animate(withDuration: Metrics.duration) {
                button.transform = .identity
            }
        }
    }
}

extension CounterViewController:  UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        scrollToBottom()
    }
}

fileprivate struct Metrics {
    static let cornerRadiusValue: CGFloat = 10
    static let duration = 0.2
    static let scale = 1.2
}
