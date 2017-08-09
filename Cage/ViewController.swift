//
//  檔名： ViewController.swift
//  專案： Cage
//
//  《Swift 入門指南》 V3.00 的範例程式
//  購書連結
//         Google Play  : https://play.google.com/store/books/details?id=AO9IBwAAQBAJ
//         iBooks Store : https://itunes.apple.com/us/book/id1079291979
//         Readmoo      : https://readmoo.com/book/210034848000101
//         Pubu         : http://www.pubu.com.tw/ebook/65565?apKey=576b20f092
//
//  作者網站： http://www.kaiching.org
//  電子郵件： kaichingc@gmail.com
//
//  作者： 張凱慶
//  時間： 2017/08/06
//

import Cocoa
import GameplayKit

class ViewController: NSViewController {
    //MARK: 屬性
    var cagePos = [[0,0], [1,0], [0,1], [1,1]]
    var cageExternal = [[0,-1], [1,-1], [2,0], [2,1], [0,2], [1,2], [-1,1], [-1,0]]
    var position = [0,0]
    var escapePos = [-1,-1]
    
    var animal = #imageLiteral(resourceName: "elephant01")
    var cageCorner = #imageLiteral(resourceName: "empty")
    var hurt = 0
    
    //MARK: 視窗屬性
    @IBOutlet weak var cage01: NSImageView!
    @IBOutlet weak var cage11: NSImageView!
    @IBOutlet weak var cage00: NSImageView!
    @IBOutlet weak var cage10: NSImageView!
    @IBOutlet weak var display: NSTextField!
    @IBOutlet weak var upButton: NSButton!
    @IBOutlet weak var rightButton: NSButton!
    @IBOutlet weak var downButton: NSButton!
    @IBOutlet weak var leftButton: NSButton!
    
    //MARK: 視窗方法
    
    //往上一步
    @IBAction func up(_ sender: NSButton) {
        //找到出口
        if escapeHole(position[0], position[1] + 1) {
            position[1] += 1
            display.stringValue = "好加在！謝謝你 :)"
        }
        else {
            //處理碰撞
            if hit(position[0], position[1] + 1) {
                position[1] += 1
                promptMessage()
            }
            else {
                display.stringValue = "很痛耶！"
            }
        }
        
        showAnimal()
    }
    
    //往右一步
    @IBAction func right(_ sender: NSButton) {
        //找到出口
        if escapeHole(position[0] + 1, position[1]) {
            position[0] += 1
            display.stringValue = "太棒了！謝謝你 :)"
        }
        else {
            //處理碰撞
            if hit(position[0] + 1, position[1]) {
                position[0] += 1
                promptMessage()
            }
            else {
                display.stringValue = "好痛！"
            }
        }
        
        showAnimal()
    }
    
    //往下一步
    @IBAction func down(_ sender: NSButton) {
        //找到出口
        if escapeHole(position[0], position[1] - 1) {
            position[1] -= 1
            display.stringValue = "神乎其技！謝謝你 :)"
        }
        else {
            //處理碰撞
            if hit(position[0], position[1] - 1) {
                position[1] -= 1
                promptMessage()
            }
            else {
                display.stringValue = "唔唔唔！"
            }
        }
        
        showAnimal()
    }
    
    //往左一步
    @IBAction func left(_ sender: NSButton) {
        //找到出口
        if escapeHole(position[0] - 1, position[1]) {
            position[0] -= 1
            display.stringValue = "終於可以自由呼吸了！謝謝你 :)"
        }
        else {
            //處理碰撞
            if hit(position[0] - 1, position[1]) {
                position[0] -= 1
                promptMessage()
            }
            else {
                display.stringValue = "阿嗚！"
            }
        }
        
        showAnimal()
    }
    
    //MARK: 方法
    
    //依座標顯示圖片
    func showAnimal() {
        let x = position[0]
        let y = position[1]
        switch (x, y) {
        case (0, 0):
            cage01.image = cageCorner
            cage11.image = cageCorner
            cage00.image = animal
            cage10.image = cageCorner
        case (0, 1):
            cage01.image = animal
            cage11.image = cageCorner
            cage00.image = cageCorner
            cage10.image = cageCorner
        case (1, 0):
            cage01.image = cageCorner
            cage11.image = cageCorner
            cage00.image = cageCorner
            cage10.image = animal
        case (1, 1):
            cage01.image = cageCorner
            cage11.image = animal
            cage00.image = cageCorner
            cage10.image = cageCorner
        default:
            cage01.image = cageCorner
            cage11.image = cageCorner
            cage00.image = cageCorner
            cage10.image = cageCorner
        }
    }
    
    //顯示提示訊息
    func promptMessage() {
        let x = position[0]
        let y = position[1]
        let dx = escapePos[0]
        let dy = escapePos[1]
        
        if dx == x {
            display.stringValue = ""
        }
        else {
            if dx > x {
                display.stringValue = "往右"
            }
            else {
                display.stringValue = "往左"
            }
        }
        
        if dy == y {
            display.stringValue += ""
        }
        else {
            if dy > y {
                display.stringValue += "往上"
            }
            else {
                display.stringValue += "往下"
            }
        }
    }
    
    //關閉按鈕
    func closeControl() {
        upButton.isEnabled = false
        rightButton.isEnabled = false
        downButton.isEnabled = false
        leftButton.isEnabled = false
    }
    
    //計算傷害值
    func hurtImage() {
        switch hurt {
        case 0:
            animal = #imageLiteral(resourceName: "elephant01")
        case 1:
            animal = #imageLiteral(resourceName: "elephant02")
        case 2:
            animal = #imageLiteral(resourceName: "elephant03")
        default:
            animal = #imageLiteral(resourceName: "sleep")
            closeControl()
        }
    }
    
    //判斷是否到達出口
    func escapeHole(_ newX: Int, _ newY: Int) -> Bool {
        if newX == escapePos[0] && newY == escapePos[1] {
            closeControl()
            return true
        }
        else {
            return false
        }
    }
    
    //判斷是否碰撞
    func hit(_ newX: Int, _ newY: Int) -> Bool {
        if newX < 0 || newX > 1 || newY < 0 || newY > 1 {
            hurt += 1
            hurtImage()
            return false
        }
        else {
            return true
        }
    }

    //MARK: 預設方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cagePos = (GKRandomSource.sharedRandom().arrayByShufflingObjects(in: cagePos) as? [[Int]])!
        cageExternal = (GKRandomSource.sharedRandom().arrayByShufflingObjects(in: cageExternal) as? [[Int]])!
        
        //隨機取得動物座標
        position = cagePos[0]
        //隨機取得出口座標
        escapePos = cageExternal[0]
        //顯示圖片
        showAnimal()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

