//
//  ViewController.swift
//  WakeMeUpOnTV
//
//  Created by Arai Koyo on 2017/03/29.
//  Copyright © 2017年 Arai Koyo. All rights reserved.
//

import UIKit
import SocketIO
class ViewController: UIViewController {
    
    let socket = SocketIOClient(socketURL: URL(string: "http://192.168.0.6:8000/")!, config: [.forceWebsockets(true)])


    @IBAction func NowButton(_ sender: Any) {
        comment.text = "NOW!"
        socket.emit("from_client_nowButton")
    }

    @IBAction func Button(_ sender: Any) {
       
       // var minuts
        //let hour = date.date
        
        comment.text = getHour() + ":" + getMin() + "に設定しました"
        //TODO
        socket.emit("from_client_okButton",getSetTime())
    }

    @IBOutlet weak var date: UIDatePicker!
    
    @IBOutlet weak var comment: UILabel!
    

    @IBAction func canselButton(_ sender: Any) {
        
        comment.text = ""
        
        //TODO
        //キャンセル
    socket.emit("from_client_stopButton")

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        date.minimumDate = getNowClockString(isTomorrow : true)
        date.maximumDate = getNowClockString(isTomorrow : false)

        socket.on("connect") { data, ack in
            print("socket connected!!")
        }
        socket.on("disconnect") { data, ack in
            print("socket disconnected!!")
        }
        socket.connect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getHour() ->String{
        let now = date.date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        let nowString = formatter.string(from: now)
        return nowString
    }
    func getMin() ->String{
        let now = date.date
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        let nowString = formatter.string(from: now)
        return nowString
    }
    
    func getSetTime() ->String{
        let now = date.date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd/HH/mm/ss"
        let nowString = formatter.string(from: now)
        return nowString
    }
    
    func getNowClockString(isTomorrow : Bool) -> Date {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        let now = Date(timeIntervalSinceNow: 0)
        let aDayAfter = Date(timeIntervalSinceNow: 24 * 60 * 60)

        let nowString = formatter.string(from: now)
        let aDayAfterString = formatter.string(from: aDayAfter)

        //文字列から日付を取得
        let nowDateFromString = formatter.date(from: nowString)!
        let aDayAfterDateFromString = formatter.date(from: aDayAfterString)!

        
        if(isTomorrow){
            return nowDateFromString
        }else{
            return aDayAfterDateFromString
        }
    }


}

