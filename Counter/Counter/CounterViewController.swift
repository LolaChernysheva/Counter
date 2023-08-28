//
//  CounterViewController.swift
//  Counter
//
//  Created by Лолита Чернышева on 26.08.2023.
//

import UIKit

class CounterViewController: UIViewController {
    
    //MARK: - Properties
    
    private var counterValue: Int = 0 {
        didSet {
            if counterValue < 0 {
                counterValue = 0
            }
            configureLabel()
        }
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    //MARK: - IBOutlet
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var minusButton: UIButton!
    @IBOutlet private weak var resetCounterButton: UIButton!
    @IBOutlet private weak var historyTextView: UITextView!
    @IBOutlet private weak var counterNumberLabel: UILabel!
    @IBOutlet private weak var cleanHistoryButton: UIButton!

    //MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        historyTextView.delegate = self
    }
    
    //MARK: - Private methods
    
    private func configureLabel() {
        counterLabel.text = "Значение счетчика: \(counterValue)"
        counterNumberLabel.text = "\(counterValue)"
    }
    
    private func configureView() {
        configureLabel()
        configureButtons()
        historyTextView.text = "История изменений:\n"
    }
    
    private func configureButtons() {
        minusButton.layer.borderWidth = Metrics.borderWidth
        minusButton.layer.borderColor = UIColor.red.withAlphaComponent(Metrics.alpha).cgColor
        minusButton.layer.cornerRadius = minusButton.frame.width / 2
        
        plusButton.layer.borderWidth = Metrics.borderWidth
        plusButton.layer.borderColor = UIColor.blue.withAlphaComponent(Metrics.alpha).cgColor
        plusButton.layer.cornerRadius = plusButton.frame.width / 2
        plusButton.layer.cornerRadius = plusButton.frame.width / 2
        
        resetCounterButton.setImage(UIImage(named: "reset"), for: .normal)
        
        cleanHistoryButton.setImage(UIImage(named: "delete"), for: .normal)
    }
    
    private func scrollToBottom() {
        let range = NSRange(location: historyTextView.text.count, length: 0)
        historyTextView.scrollRangeToVisible(range)
    }
    
    private func updateCounter(by value: Int) {
        counterValue += value
    }
    
    private func log(message: String) {
        let currentTime = dateFormatter.string(from: Date())
        let newLine = "[\(currentTime)]: \(message)\n"
        historyTextView.text.append(newLine)
        scrollToBottom()
    }
    
    private func addScaleAnimation(into button: UIButton) {
        UIView.animate(withDuration: Metrics.duration, animations: {
            button.transform = CGAffineTransform(scaleX: Metrics.scale, y: Metrics.scale)
            button.layer.borderColor = button.layer.borderColor?.copy(alpha: 1)
        }) { _ in
            UIView.animate(withDuration: Metrics.duration) {
                button.transform = .identity
            }
            button.layer.borderColor = button.layer.borderColor?.copy(alpha: Metrics.alpha)
        }
    }
    
    //MARK: - IBActions
    
    @IBAction private func resetButtonTapped(_ sender: Any) {
        updateCounter(by: -counterValue)
        log(message: "значение сброшено")
    }
    
    @IBAction private func plusButtonTapped(_ sender: Any) {
        updateCounter(by: 1)
        log(message: "cчетчик увеличен на 1")
        addScaleAnimation(into: plusButton)
    }
    
    @IBAction private func minusButtonTapped(_ sender: Any) {
        if counterValue <= 0 {
            log(message: "попытка уменьшить значение счётчика ниже 0")
        } else {
            updateCounter(by: -1)
            log(message: "cчетчик уменьшен на 1")
        }
        addScaleAnimation(into: minusButton)
    }
    
    @IBAction private func cleanHistoryButtonTapped(_ sender: Any) {
        historyTextView.text = "История изменений:\n"
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
    static let alpha = 0.2
    static let borderWidth: CGFloat = 4
}
