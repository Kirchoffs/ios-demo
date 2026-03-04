import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var boyImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    private var isThinkingHard = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        isThinkingHard.toggle()
        updateUI()
    }
    
    private func updateUI() {
        if isThinkingHard {
            boyImageView.image = UIImage(named: "gemini_boy_1")
            statusLabel.text = "He is finding a solution..."
            statusLabel.textColor = .systemGreen
            actionButton.setTitle("Deep Thinking", for: .normal)
            actionButton.backgroundColor = .systemGreen
        } else {
            boyImageView.image = UIImage(named: "gemini_boy_2")
            statusLabel.text = "Just started thinking..."
            statusLabel.textColor = .systemBlue
            actionButton.setTitle("Start Thinking", for: .normal)
            actionButton.backgroundColor = .systemBlue
        }
        
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.layer.cornerRadius = 12
    }
}
