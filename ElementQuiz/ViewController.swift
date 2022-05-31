//
//  ViewController.swift
//  ElementQuiz
//
//  Created by Student AM on 2/15/22.
//

import UIKit

enum Mode {
    case flashCard
    case quiz
}

enum State {
    case question
    case answer
    case score
}

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
   
    
    @IBOutlet weak var modeSelector: UISegmentedControl!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var showAnswerButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var letterView: UIImageView!
    
    @IBOutlet weak var width: NSLayoutConstraint!
    @IBOutlet weak var height: NSLayoutConstraint!
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var smallStack: UIStackView!
    
    let fixedElementList = ["a", "aa", "ae", "am", "ao", "ay", "b", "bha", "ca", "chha", "d", "da", "dh", "dha", "e", "fa", "ga", "gha", "ha", "i", "ja", "jha", "ka", "kha", "la", "ma", "n", "na", "nga", "nya", "o", "oo","p","r", "ri", "rr", "sa", "sha", "shha", "t", "tha", "thh", "u", "v", "y"]
    var elementList: [String] = []
    
    var currentElementIndex = 0
    var mode: Mode = .flashCard {
        didSet {
            switch mode {
            case .flashCard:
                setupFlashCards()
            case .quiz:
                setupQuiz()
            }
            updateUI()
        }
    }
    var state: State = .question
    var answerIsCorrect = false
    var correctAnswerCount = 0
    

    
    override func viewDidLoad() {
            super.viewDidLoad()
            mode = .flashCard
            // Do any additional setup after loading the view.
            
            setImageSize(size: view.frame.size)
            
    //        if view.frame.width > 700 && view.frame.height > 700 {
    //            width.constant = 220
    //            height.constant = 220
    //            mainStackView.spacing = 30
    //            smallStack.spacing = 20
    //        }
        }
        
        func setImageSize(size: CGSize) {
            if size.width > 700 && size.height > 700 {
                width.constant = 200
                height.constant = 200
            }
            else if size.width > size.height {
                width.constant = 87
                height.constant = 87
            }
            else {
                width.constant = 120
                height.constant = 120
            }
        }
        
        override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            setImageSize(size: size)
        }
    
    func updateFlashCardUI(elementName: String) {
        textField.isHidden = true
        textField.resignFirstResponder()
        
        if state == .answer {
            answerLabel.text = elementName
        } else {
        answerLabel.text = "?"
        }
        modeSelector.selectedSegmentIndex = 0
        showAnswerButton.isHidden = false
        nextButton.isEnabled = true
        nextButton.setTitle("Next Letter", for: .normal)
    }
    
    func updateQuizUI(elementName: String) {
        textField.isHidden = false
        switch state {
        case .question:
            textField.isEnabled = true
            textField.text = ""
            textField.becomeFirstResponder()
        case .answer:
            textField.isEnabled = false
            textField.resignFirstResponder()
        case .score:
            textField.isHidden = true
            textField.resignFirstResponder()
        }
        
        switch state {
        case .score:
            answerLabel.text = ""
//            print("Your score is \(correctAnswerCount) out of \(elementList.count).")
        case .question:
            answerLabel.text = ""
        case .answer:
            if answerIsCorrect {
                answerLabel.text = "Correct!"
            } else {
                answerLabel.text = "❌ Correct Answer: " + elementName
            }
        }
        if state == .score {
            displayScoreAlert()
        }
        modeSelector.selectedSegmentIndex = 1
        showAnswerButton.isHidden = true
        if currentElementIndex == elementList.count - 1 {
            nextButton.setTitle("Show Score", for: .normal)
        } else {
            nextButton.setTitle("Next Question", for: .normal)
        }
        switch state {
        case .question:
            nextButton.isEnabled = false
        case .answer:
            nextButton.isEnabled = true
        case .score:
            nextButton.isEnabled = false
        }
    }
    
    
    
    func updateUI() {
        
        
        let elementName = elementList[currentElementIndex]
        let image = UIImage(named: elementName)
        imageView.image = image
        switch mode {
        case .flashCard:
            updateFlashCardUI(elementName: elementName)
        case .quiz:
            updateQuizUI(elementName: elementName)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textFieldContents = textField.text!
        if textFieldContents.lowercased() == elementList[currentElementIndex].lowercased() {
            answerIsCorrect = true
            correctAnswerCount += 1
        } else {
            answerIsCorrect = false
        }
        state = .answer
        updateUI()
        
        if answerIsCorrect {
            print("Correct!")
        } else {
            print("❌")
        }
        
        return true
        
    }
    
    @IBAction func showAnswer(_ sender: UIButton) {
//        answerLabel.text = elementList[currentElementIndex]
        state = .answer
        updateUI()
    }
   
    @IBAction func nextElement(_ sender: UIButton) {
        currentElementIndex += 1
        if currentElementIndex >= elementList.count {
            currentElementIndex = 0
            if mode == .quiz {
                state = .score
                updateUI()
                return
            }
        }
        state = .question
        
        updateUI()
    }
    
    @IBAction func switchModes(_ sender: UISegmentedControl) {
        if modeSelector.selectedSegmentIndex == 0 {
            mode = .flashCard
        } else {
            mode = .quiz
        }
    }
    
    func displayScoreAlert() {
        let alert = UIAlertController(title: "Quiz Score", message: "Your score is \(correctAnswerCount) out of \(elementList.count).", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: scoreAlertDismissed(_:))
        alert.addAction(dismissAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func scoreAlertDismissed(_ action: UIAlertAction) {
        mode = .flashCard
    }
    
    func setupFlashCards() {
        state = .question
        currentElementIndex = 0
        elementList = fixedElementList
    }
    
    func setupQuiz() {
        state = .question
        currentElementIndex = 0
        answerIsCorrect = false
        correctAnswerCount = 0
        elementList = fixedElementList.shuffled()
    }
    
}

