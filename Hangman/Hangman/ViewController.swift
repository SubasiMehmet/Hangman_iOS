//
//  ViewController.swift
//  Hangman
//
//  Created by Mehmet Subaşı on 16.07.2022.
//

import UIKit

//MARK: To use some text field operations -> UITextFieldDelegate
class ViewController: UIViewController, UITextFieldDelegate {

    var mainTextLabel = UITextField()
    var scoreLabel =  UILabel()
    var submitTextField = UITextField()
    var submitButton = UIButton()
    var usedLetters = UILabel()
    var failLabel = UILabel()

    var images = [UIImageView]()
    var tableImage = UIImageView()
    
    
    var questionText = String()
    var allWords = [String]()
    var score : Int = 0 {
        didSet{
            scoreLabel.text = "score: \(score)"
        }
    }
    var fail : Int = 0 {
        didSet{
            failLabel.text = "fail: \(fail)"
        }
    }
    var usedLettersArray = [String]()
    var gameOver = false
    var picturesNames = [String]()
    
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        /*
        let manView = UIView()
        manView.backgroundColor = .red
        manView.translatesAutoresizingMaskIntoConstraints = false
        //print(UIScreen.main.bounds.size.height)
        manView.frame = CGRect(x: 200,
                               y: 200,
                               width: 150,
                               height: 150)
        
        view.addSubview(manView)
        */
        
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.font = UIFont.systemFont(ofSize: 20)
        
        scoreLabel.text = "score: \(score)"
        view.addSubview(scoreLabel)
        
        failLabel.translatesAutoresizingMaskIntoConstraints = false
        failLabel.textAlignment = .left
        failLabel.font = UIFont.systemFont(ofSize: 20)
        failLabel.text = "fail: \(fail)"
        
        view.addSubview(failLabel)
        

        mainTextLabel.translatesAutoresizingMaskIntoConstraints = false
        mainTextLabel.textAlignment = .center
        mainTextLabel.font = UIFont.systemFont(ofSize: 38)
        mainTextLabel.isUserInteractionEnabled = false
        
        

        mainTextLabel.text = "HELLO"
        view.addSubview(mainTextLabel)
        
        submitTextField.translatesAutoresizingMaskIntoConstraints = false
        submitTextField.textAlignment = .center
        submitTextField.font = UIFont.systemFont(ofSize: 30)
        submitTextField.layer.borderWidth = 0.5
        submitTextField.layer.cornerRadius = 10
        submitTextField.becomeFirstResponder()
        
        submitTextField.addTarget(self, action: #selector(textViewChanged), for: .editingChanged)

        view.addSubview(submitTextField)
        
        submitButton = UIButton(type: .system)  // -> Important
        let buttonSize = UIScreen.main.bounds.size.height / 12
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("OK", for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        submitButton.backgroundColor = .white
        submitButton.tintColor = .systemBlue
        submitButton.layer.cornerRadius = 20
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.systemGray.cgColor
        submitButton.addTarget(self, action: #selector(giveLetter), for: .touchUpInside)
        
        
        view.addSubview(submitButton)
        
        usedLetters.translatesAutoresizingMaskIntoConstraints = false
        usedLetters.textAlignment = .center
        usedLetters.font = UIFont.systemFont(ofSize: 30)
        usedLetters.numberOfLines = 0
        
        view.addSubview(usedLetters)
        
//        mainTextLabel.backgroundColor = .blue
//        usedLetters.backgroundColor = .systemPink
//        submitLabel.backgroundColor = .systemRed
//        scoreLabel.backgroundColor = .yellow
        
        loadImages()
        
        for _ in 0...6 {
            let image = UIImageView()
            images.append(image)
        }
        
        for (index, _) in picturesNames.enumerated() {
            images[index].image = UIImage(named: "\(picturesNames[index])")
            images[index].translatesAutoresizingMaskIntoConstraints = false
            images[index].contentMode = .scaleAspectFit
            
            if index > 0 {
                images[index].isHidden = true
            }
            view.addSubview(images[index])
        }
        
        images[0].layer.zPosition = -1000
        images[1].layer.zPosition = -9
        images[2].layer.zPosition = -8
        images[3].layer.zPosition = -7
        images[4].layer.zPosition = -6
        images[5].layer.zPosition = -5
        images[6].layer.zPosition = -4
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            scoreLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            scoreLabel.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.05),
            
            failLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            failLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            failLabel.heightAnchor.constraint(equalTo: scoreLabel.heightAnchor),
            
            mainTextLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            mainTextLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            mainTextLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 0),
            
            submitTextField.topAnchor.constraint(equalTo: mainTextLabel.bottomAnchor, constant: UIScreen.main.bounds.size.height / 3),
            submitTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            submitTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            submitButton.bottomAnchor.constraint(equalTo: submitTextField.topAnchor, constant: 0),
            submitButton.leadingAnchor.constraint(equalTo: submitTextField.trailingAnchor, constant: 20),
            submitButton.heightAnchor.constraint(equalToConstant: buttonSize),
            submitButton.widthAnchor.constraint(equalToConstant: buttonSize),
            
            
            usedLetters.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            usedLetters.topAnchor.constraint(equalTo: mainTextLabel.bottomAnchor, constant: 0),
            usedLetters.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height / 2),
            usedLetters.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height / 12),
            
            
            images[0].centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: UIScreen.main.bounds.size.height / 30),
            images[0].centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -(UIScreen.main.bounds.size.height / 8)),
            images[0].heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height / 3.5),
            
            images[1].centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -(UIScreen.main.bounds.size.height / 26)),
            images[1].centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -(UIScreen.main.bounds.size.height / 6)),
            images[1].heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height / 3.5),
            
            images[2].centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -(UIScreen.main.bounds.size.height / 25.2)),
            images[2].centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -(UIScreen.main.bounds.size.height / 11.5)),
            images[2].heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height / 3.5),
            
            images[3].centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -(UIScreen.main.bounds.size.height / 16)),
            images[3].centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -(UIScreen.main.bounds.size.height / 12)),
            images[3].heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height / 3.5),
            
            images[4].centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -(UIScreen.main.bounds.size.height / 55)),
            images[4].centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -(UIScreen.main.bounds.size.height / 12)),
            images[4].heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height / 3.5),
            
            images[5].centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -(UIScreen.main.bounds.size.height / 16)),
            images[5].centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -(UIScreen.main.bounds.size.height / 70)),
            images[5].heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height / 3.5),
            
            images[6].centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -(UIScreen.main.bounds.size.height / 55)),
            images[6].centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -(UIScreen.main.bounds.size.height / 70)),
            images[6].heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height / 3.5),
            
            
        ])
        

        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "HANGMAN"
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: nil, action: #selector(loadGame))
        
        

        
       // performSelector(inBackground: #selector(loadImages), with: nil)
           
        
        //MARK: To use some text field operations
        self.submitTextField.delegate = self
        
        readData()
        //performSelector(inBackground: #selector(readData), with: nil)
        //performSelector(inBackground: #selector(loadGame), with: nil)
        loadGame()
        


        
    }
    
    @objc func readData(){
            if let textFileUrl = Bundle.main.url(forResource: "start", withExtension: "txt"){
                if let textFile = try? String(contentsOf: textFileUrl){
                    allWords = textFile.components(separatedBy: "\n")
                }
            }
    }
    
    @objc func loadGame(){
        if let searchedWord = allWords.randomElement() {
            questionText = searchedWord
            //questionText = "cadenced"
            print(questionText)
            mainTextLabel.text = String(repeating: "?", count: searchedWord.count)
            usedLetters.text = ""
            submitTextField.text = ""
            usedLettersArray.removeAll()
            

            gameOver = false
            fail = 0
            for i in 1...6 {
                images[i].isHidden = true
            }
            
            
        }
        
    }
    
    @objc func giveLetter(){
        
        guard let takenWord  = submitTextField.text else{return}
        if takenWord.isEmpty {return}
        guard var mainText : String = mainTextLabel.text else {return}
        let takenLetter : Character = takenWord[takenWord.startIndex]
        
        let lowerTakenLetter = takenLetter.lowercased()
        
        
        
        var questionTextAux = questionText
        if !questionText.contains(lowerTakenLetter){
            if !usedLettersArray.contains(lowerTakenLetter)  && gameOver == false{ // -> If game continues and you chose wrong letter
                usedLettersArray.append(lowerTakenLetter)
                fail += 1
                images[fail].isHidden = false
                usedLetters.text = usedLettersArray.joined(separator: "\n").uppercased()
                submitTextField.text = ""
            }else if usedLettersArray.contains(lowerTakenLetter) {  // -> If game continues and you you chose an already selected letter
                makeAlert(title: "Ooops!", message: "You used this letter. Try another one.", type: "Fail")
                submitTextField.text = ""
            }else if gameOver == true {
                usedLettersArray.append(lowerTakenLetter)
                usedLetters.text = usedLettersArray.joined(separator: "\n").uppercased()
                submitTextField.text = ""
            }
            
            submitTextField.text = ""
            if fail == 6 && gameOver == false {     // If you make 5 mistakes
                makeAlert(title: "Game Over", message: "You made 5 mistakes!!!", type: "Game Over")
            }
        }else{
            if usedLettersArray.contains(lowerTakenLetter){
                submitTextField.text = ""
                makeAlert(title: "Ooops!", message: "You used this letter. Try another one.", type: "Fail")
                return
            }
            repeat {
                mainText.insert(takenLetter, at: questionTextAux.firstIndex(of: Character(lowerTakenLetter))!)
                mainText.remove(at: mainText.index(questionTextAux.firstIndex(of: Character(lowerTakenLetter))!, offsetBy: 1))
                
                questionTextAux.remove(at: questionTextAux.firstIndex(of: Character(lowerTakenLetter))!)
                questionTextAux.insert("?", at: questionTextAux.startIndex)
                if !usedLettersArray.contains(lowerTakenLetter){
                    usedLettersArray.append(lowerTakenLetter)
                }

                usedLetters.text = usedLettersArray.joined(separator: "\n").uppercased()
                

            }while (questionTextAux.contains(lowerTakenLetter))
        }
        
        print(questionText)

        
        submitTextField.text = ""
        mainTextLabel.text = mainText
        
        if !mainText.contains("?"){
            score += 1
            makeAlert(title: "Perfect!", message: "Your score is \(score). Let's skip to other one.", type: "Success")
        }
        
      
    }
    
    func makeAlert(title: String, message: String, type: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        if type == "Success" {
            let skipButton = UIAlertAction(title: "Let's Go!", style: UIAlertAction.Style.default) { [weak self] _ in
                self?.loadGame()
            }
            alert.addAction(skipButton)
        }else if type == "Game Over"{
            let skipButton = UIAlertAction(title: "Skip to Another Game", style: UIAlertAction.Style.default) { [weak self] _ in
                self?.loadGame()
            }
            let continueButton = UIAlertAction(title: "Continue Anyway", style: UIAlertAction.Style.default) { [weak self] _ in
                self?.gameOver = true
            }
            alert.addAction(skipButton)
            alert.addAction(continueButton)
        }else if type == "Fail"{
            let okButton = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okButton)
        }
        present(alert, animated: true)
    }
    
    //MARK: Force TextField to some conditions.
    @objc func textViewChanged(){
        /*if let lowerCasedStr  = submitLabel.text?.lowercased{
            submitLabel.text = lowerCasedStr()
        }*/
        
        guard let text = submitTextField.text else{return}
        if text.utf16.count == 2 {
            let droppedText = text.dropLast()
            submitTextField.text = String(droppedText)
        }
        
      }
    
    //MARK: Assigning enter to action
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        giveLetter()
        
        return true
    }
    
    func loadImages(){
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if  item.hasSuffix(".png") {
                self.picturesNames.append(item)
                self.picturesNames.sort()
            }
        }

        
    }
    
    

     
}

