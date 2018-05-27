//
//  QuizViewController.swift
//  Quizgame
//
//  Created by Chiemi Sugiura on 2018/05/27.
//  Copyright © 2018年 c-sugiura. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    // 問題表示の接続
    @IBOutlet weak var quizNumberLabel: UILabel!
    @IBOutlet weak var quizQuestionLabel: UILabel!
    @IBOutlet weak var uiButton1: UIButton!
    @IBOutlet weak var uiButton2: UIButton!
    @IBOutlet weak var uiButton3: UIButton!
    @IBOutlet weak var uiButton4: UIButton!
    
    // 正誤表示
    @IBOutlet weak var answerImage: UIImageView!

    // 問題を格納
    var csvArray = [String]()

    // 取り出した問題を格納
    var questionArray = [String]()

    // 定数
    var questionCount = 0   // 出題数
    var correctCount = 0    // 正解
    let total = 3          // 出題数

    // 画面表示完了後に動くメソッド
    override func viewDidLoad() {
        // 画面表示が完了した時に表示されるメソッド
        super.viewDidLoad()

        // 1. 問題の読み込み
        csvArray = loadCSV(filename: "loveswift")
        
        // 2. 画面の初期化
        answerImage.isHidden = true
        
        // 3. 問題表示
        nextProblem()
        // Do any additional setup after loading the view.
    }

    // 正誤判定
    @IBAction func btnAction(_ sender: UIButton) {
        // 正解とボタンのタグ番号が同じなら正解
        if sender.tag == Int(questionArray[1]) {
            answerImage.image = UIImage(named: "correct.png")
            correctCount += 1
        } else {
            answerImage.image = UIImage(named: "incorrect.png")
        }
        
        // 回答表示の有効化(0.5秒間)
        answerImage.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.answerImage.isHidden = true
        }
        
        // 次の問題文呼び出し
        questionCount += 1
        nextProblem()
    }
    
    // 問題表示 & 画面遷移
    func nextProblem() {
        // questionArrayの初期化
        questionArray.removeAll(keepingCapacity: true)
        
        if questionCount < total {
            // questionArrayに新規問題を格納
            questionArray = csvArray[questionCount].components(separatedBy: ",")
            // 表示内容をセット
            quizNumberLabel.text = "第\(questionCount+1)問"
            quizQuestionLabel.text = questionArray[0]
            uiButton1.setTitle(questionArray[2], for: .normal)
            uiButton2.setTitle(questionArray[3], for: .normal)
            uiButton3.setTitle(questionArray[4], for: .normal)
            uiButton4.setTitle(questionArray[5], for: .normal)
        } else {
            // Storyboard Segue の Identifier を引数に定義して画面遷移
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.performSegue(withIdentifier: "toResultViewController", sender: nil)
            }
        }
    }
    
    // Segue で値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sVC: ResultViewController = (segue.destination as? ResultViewController)!
        sVC.correct = correctCount
    }
    
    // CSVファイルの読み込み
    func loadCSV(filename : String)->[String] {
        
        // 返却値の初期化
        var csvStr = [String]()
        
        // CSVを読み込んでArrayに
        // https://qiita.com/MYamate_jp/items/ce4a05e78aa23449fa1e
        if let csvPath = Bundle.main.path(forResource: filename, ofType: "csv") {
            do {
                var csvData = try String(contentsOfFile: csvPath, encoding: String.Encoding.utf8)
                csvData = csvData.replacingOccurrences(of: "\n", with: "")
                csvStr = csvData.components(separatedBy: .newlines)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        return csvStr
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
