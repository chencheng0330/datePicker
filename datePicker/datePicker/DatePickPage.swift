//
//  DatePickPage.swift
//  BillNote
//
//  Created by chencheng0330 on 2019/11/8.
//  Copyright © 2019年 chencheng0330. All rights reserved.
//

import UIKit
typealias Times = (year : Int, month : Int, day : Int, hour : Int, minute : Int)

typealias ButtonBlock = (_ time : Double?) ->()

class DatePickPage: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickView: UIPickerView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    
    var gotoCurrentTime : Bool = true
    
    var sureBtnBlock : ButtonBlock?
    
    var currentYear : Int = 0
    var currentMonth : Int = 0
    var currentDay : Int = 0
    var currentHour : Int = 0
    var currentMin : Int = 0
    var dayCount : Int = 0
    
    var selectedYear : Int = 0
    var selectedMonth : Int = 0
    var selectedDay : Int = 0
    var selectedHour : Int = 0
    var selectedMin : Int = 0
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .overFullScreen
        self.view.backgroundColor = UIColor.init(white: 0, alpha: 0)
        self.backView.backgroundColor = UIColor.init(white: 0, alpha: 0)
        self.view.superview?.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let times = self.fetchTime(date: Date.init())
        
        self.currentYear = times.year ?? 0
        self.currentMonth = times.month ?? 0
        self.currentDay = times.day ?? 0
        self.currentHour = times.hour ?? 0
        self.currentMin = times.minute ?? 0
        
        self.selectedYear = self.currentYear
        self.selectedMonth = self.currentMonth
        self.selectedDay = self.currentDay
        self.selectedHour = self.currentHour
        self.selectedMin = self.currentMin
        
        self.dayCount = self.fetchDayCountsOfMonth(year: self.currentYear, month: self.currentMonth) ?? 0
        
        self.pickView.reloadComponent(2)
        self.pickView.selectRow(DatePickPage.years.index(of:self.currentYear)!, inComponent: 0, animated: true)
        self.pickView.selectRow(DatePickPage.months.index(of:self.currentMonth)!, inComponent: 1, animated: true)
        if self.dayCount == 31 {
            self.pickView.selectRow(DatePickPage.daysOfBigMonth.index(of:self.currentDay)!, inComponent: 2, animated: true)
        }else if self.dayCount == 30 {
            self.pickView.selectRow(DatePickPage.daysOfTinyMonth.index(of:self.currentDay)!, inComponent: 2, animated: true)
        }else if self.dayCount == 29 {
            self.pickView.selectRow(DatePickPage.daysOfLeapYearFebruary.index(of:self.currentDay)!, inComponent: 2, animated: true)
        }else if self.dayCount == 28 {
            self.pickView.selectRow(DatePickPage.daysOfCommonYearFebruary.index(of:self.currentDay)!, inComponent: 2, animated: true)
        }
        self.pickView.selectRow(DatePickPage.hours.index(of:self.currentHour)!, inComponent: 3, animated: true)
        self.pickView.selectRow(DatePickPage.minutes.index(of:self.currentMin)!, inComponent: 4, animated: true)
        
    }
    
    func fetchTime(date : Date) -> DateComponents{
        let calendar = Calendar.current
        let nowComps = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        return nowComps
    }
    
    func fetchDayCountsOfMonth(year : Int, month : Int) -> Int?{
        if [1,3,5,7,8,10,12].contains(month) {
            return 31
        }else if [4,6,9,11].contains(month) {
            return 30
        }else {
            let calendar = Calendar.current
            
            var startComps = DateComponents.init()
            startComps.day = 1
            startComps.month = month
            startComps.year = year
            
            var endComps = DateComponents.init()
            endComps.day = 1
            endComps.month = (month == 12 ? 1 : month + 1)
            endComps.year = (month == 12 ? year + 1 : year)
            let diff = calendar.dateComponents([.day], from: startComps, to: endComps)
            return diff.day
        }
    }
    
    @IBAction func sureButtonAction(_ sender: Any) {
        let format = DateFormatter.init()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        let date = format.date(from: "\(self.selectedYear)-\(self.selectedMonth)-\(self.selectedDay) \(self.selectedHour):\(self.selectedMin)")
        let time = date?.timeIntervalSince1970
        self.sureBtnBlock?(time)
        self.dismiss()
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss()
    }
    
    func dismiss() {
        self.constraint.constant = -216
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.backView.backgroundColor = UIColor.init(white: 0, alpha: 0)
            self.backView.layoutIfNeeded()
        }) { (result) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func showDatePickerPage(to viewController : UIViewController)  {
        viewController.present(self, animated: false) {
            self.constraint.constant = 0
            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                self.backView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
                self.backView.layoutIfNeeded()
            }, completion: nil)
        }
    }
}

extension DatePickPage {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return DatePickPage.years.count
        }else if component == 1 {
            return DatePickPage.months.count
        }else if component == 2 {
            if [1,3,5,7,8,10,12].contains(self.selectedMonth) {
                return 31
            }else if [4,6,9,11].contains(self.selectedMonth) {
                return 30
            }else if self.selectedMonth == 2 {
                let dayCount = self.fetchDayCountsOfMonth(year: self.selectedYear, month: self.selectedMonth) ?? 0
                return dayCount
            }
            return 30
        }else if component == 3 {
            return DatePickPage.hours.count
        }else if component == 4 {
            return 60
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(DatePickPage.years[row])"
        }else if component == 1 {
            return "\(DatePickPage.months[row])"
        }else if component == 2 {
            if [1,3,5,7,8,10,12].contains(self.selectedMonth) {
                return "\(DatePickPage.daysOfBigMonth[row])"
            }else if [4,6,9,11].contains(self.selectedMonth) {
                return "\(DatePickPage.daysOfTinyMonth[row])"
            }else if self.selectedMonth == 2 {
                let dayCount = self.fetchDayCountsOfMonth(year: self.selectedYear, month: self.selectedMonth) ?? 0
                if dayCount == 28 {
                    return "\(DatePickPage.daysOfCommonYearFebruary[row])"
                }else if dayCount == 29 {
                    return "\(DatePickPage.daysOfLeapYearFebruary[row])"
                }
                return "\(DatePickPage.daysOfCommonYearFebruary[row])"
            }
            return "\(DatePickPage.daysOfCommonYearFebruary[row])"
        }else if component == 3 {
            return String.init(format: "%02d", DatePickPage.hours[row])
        }else if component == 4 {
            return String.init(format: "%02d", DatePickPage.minutes[row])
        }
        return ""
    }
    
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if component == 0 {
                self.selectedYear = DatePickPage.years[row]
                if pickerView.selectedRow(inComponent: 1) == 1 {
                    pickerView.reloadComponent(2)
                }
            }else if component == 1 {
                self.selectedMonth = DatePickPage.months[row]
                pickerView.reloadComponent(2)
            }else if component == 2 {
                if row == 30 {
                    self.selectedDay = 31
                }else if row == 29 {
                    self.selectedDay = 30
                }else if row == 28 {
                    self.selectedDay = 29
                }else if row == 27 {
                    self.selectedDay = 28
                }else {
                    self.selectedDay = row + 1
                }
            }else if component == 3 {
                self.selectedHour = DatePickPage.hours[row]
            }else if component == 4 {
                self.selectedMin = DatePickPage.minutes[row]
            }
            
        }
}

extension DatePickPage {
    static var years : [Int] {
        return [2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025, 2026, 2027, 2028, 2029, 2030, 2031,2032, 2033, 2034, 2035, 2036, 2037, 2038, 2039, 2040, 2041, 2042, 2043, 2044, 2045, 2046, 2047, 2048, 2049, 2050]
    }
    
    static var months : [Int] {
        return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    }
    
    static var daysOfBigMonth : [Int] {
        return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
    }
    
    static var daysOfTinyMonth : [Int] {
        return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
    }
    
    static var daysOfLeapYearFebruary : [Int] {
        return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]
    }
    
    static var daysOfCommonYearFebruary : [Int] {
        return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28]
    }
    
    static var hours : [Int] {
        return [00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]
    }
    
    static var minutes : [Int] {
        return [00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59]
    }
    
}
