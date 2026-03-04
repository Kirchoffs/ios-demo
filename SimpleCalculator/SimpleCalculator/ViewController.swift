import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var firstNumberText: UITextField!
    @IBOutlet weak var secondNumberText: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addAction(_ sender: Any) {
        if let firstNumber = Int(firstNumberText.text!) {
            if let secondNumber = Int(secondNumberText.text!) {
                resultLabel.text = String(firstNumber + secondNumber)
            }
        }
    }
    
    @IBAction func minusAction(_ sender: Any) {
        if let firstNumber = Int(firstNumberText.text!) {
            if let secondNumber = Int(secondNumberText.text!) {
                resultLabel.text = String(firstNumber - secondNumber)
            }
        }
    }
    
    @IBAction func multiplyAction(_ sender: Any) {
        if let firstNumber = Int(firstNumberText.text!) {
            if let secondNumber = Int(secondNumberText.text!) {
                resultLabel.text = String(firstNumber * secondNumber)
            }
        }
    }
    
    @IBAction func divideAction(_ sender: Any) {
        if let firstNumber = Int(firstNumberText.text!) {
            if let secondNumber = Int(secondNumberText.text!) {
                resultLabel.text = String(firstNumber / secondNumber)
            }
        }
    }
}
