//
//  ViewController.swift
//  fatCat
//
//  Created by 邱珮瑜 on 2024/4/6.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var weight: UITextField!  // 輸入貓咪體重
    @IBOutlet weak var activityPicker: UIPickerView! // 選擇貓咪活動狀態
    @IBOutlet weak var result: UILabel! // 顯示計算結果
    
    // 定義貓咪活動狀態及其對應的活動係數
    let activityType: [String: Double] = ["4個月以下幼貓": 2.5, "4個月~1歲": 2, "已結紮成貓": 1.2, "未結紮成貓(1~7歲)": 1.4, "中年成貓(7~11歲)": 1.1, "老貓(11歲以上)": 1.1, "肥胖貓": 0.8, "久坐不動的成貓": 1 ,"過瘦成貓": 1.2, "懷孕的貓": 1.6, "哺乳的貓": 2, "生病成貓": 1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設定 UIPickerView 的代理和資料來源
        activityPicker.delegate = self
        activityPicker.dataSource = self
    }
    
    @IBAction func weightTextField(_ sender: Any) {
        // 當體重輸入框的內容發生改變時，更新結果
        updateResult()
    }
    
    func updateResult() {
        // 檢查體重輸入框是否包含有效的數值
        guard let weightText = weight.text, let weightValue = Double(weightText) else {
            result.text = "請輸入有效的體重"
            result.textColor = .red
            return
        }
        
        // 獲取選擇的活動係數
        guard let selectedActivity = getSelectedActivity() else {
            result.text = "請選擇活動狀態"
            result.textColor = .red
            return
        }
        
        // 計算貓咪所需熱量並更新結果標籤
        let caloricNeeds = countCal(weight: weightValue, activity: selectedActivity)
        result.text = "\(String(caloricNeeds)) kcal"
        result.textColor = .brown
    }

    func getSelectedActivity() -> Double? {
        // 獲取選擇的行數
        let selectedRow = activityPicker.selectedRow(inComponent: 0)
        // 根據selectedRow數獲取對應的活動狀態
        let selectedKey = Array(activityType.keys)[selectedRow]
        // 根據活動狀態獲取對應的活動係數
        return activityType[selectedKey]
    }

    func countCal(weight: Double, activity: Double) -> Double {
        //熱量公式 = (體重 * 30 + 70) * DER
        return (weight * 30 + 70) * activity
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 點擊畫面空白處，收起鍵盤
        view.endEditing(true)
    }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 當選擇行數發生改變時，更新結果
        updateResult()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // UIPickerView 中的列數
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // UIPickerView 中選項數
        return activityType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // pickerView中選項顯示
        return Array(activityType.keys)[row]
    }
}

