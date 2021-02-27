//
//  AppEngine.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/14.
//

import Foundation
import SwiftUI

enum cardIcon: String, CaseIterable, Codable {
    case heart = "heart"
    case diamond = "diamond"
    case club = "club"
    case spade = "spade"
}

enum opr {
    case add
    case sub
    case mul
    case div
}

struct card:Codable, Equatable {
    var CardIcon:cardIcon
    var numb:Int
}

struct storedVal {
    var value:Double
    var source:Int
}

func doubleEquality(a:Double, b:Double) -> Bool {
    if (abs(a-b)<0.00001) {
        return true
    }
    return false
}

func dblToString3Precision(x:Double) -> String {
    let testIfInt=Int(x*100000)
    if testIfInt%100000 == 0 {
        return String(Int(testIfInt/100000))
    }
    return String(round(x*1000)/1000)
}

enum mathResult {
    case success
    case failure
    case cont
}

func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}

class TFEngine: ObservableObject {
    //MARK: Updaters and Updatees
    @Published var storedExpr: String?
    @Published var expr: String = "" //update this from getExpr
    @Published var lvl: Int //the current level
    func updtStoredExpr() {
        if stored != nil {
            storedExpr=dblToString3Precision(x: stored!.value)
        } else {
            storedExpr=nil
        }
    }
    func updtExpr() {
        expr=""
        if (nxtNumNeg==true) {
            expr = "-"
        }
        if (mainVal == nil) {
            return
        }
        expr=expr+dblToString3Precision(x: mainVal!.value)
        if (selectedOperator == nil) {
            return
        }
        switch selectedOperator! {
        case .add:
            expr+="+"
        case .div:
            expr+="÷"
        case .mul:
            expr+="×"
        case .sub:
            expr+="-"
        }
    }
    
    
    @Published var cs: [card] //card set
    
    @Published var cA: [Bool] // which cards are being activated and which are not
    
    var buttonsCanPress=false
    
    var deviceData = [String: Int]()
    
    let defaults=UserDefaults.standard
    
    var deviceID: String
        
    func saveData() {
        icloudstore.removeObject(forKey: "devemptylvl")
        precondition(deviceID != "empty")
        defaults.setValue(deviceData[deviceID], forKey: "myLvl")
        defaults.setValue(deviceID, forKey: "deviceID")
        deviceData.removeValue(forKey: "empty")
        let deviceList:[String]=Array(deviceData.keys)
        print(deviceList)
        icloudstore.set(deviceList, forKey: "devices")
        for (itrDeviceID,itrDeviceLvl) in deviceData {
            print("Saving \(itrDeviceID) as \(itrDeviceLvl)")
            icloudstore.set(itrDeviceLvl, forKey: "dev"+itrDeviceID+"lvl")
        }
        icloudstore.set(try? PropertyListEncoder().encode(cs), forKey: "cards")
        NSUbiquitousKeyValueStore.default.synchronize()
        defaults.synchronize()
    }
    
    @Published var stored: storedVal?
    
    var mainVal: storedVal? //put any calculation result into here
    
    @Published var lvlName: String = "" //update this from getLvlName
    func updtLvlName() {
        lvl=0
        for i in deviceData.values {
            lvl+=i-1
        }
        lvl+=1
        lvlName = "Level"
    }
    
    var selectedOperator : opr?
    
    @Published var curQuestionID: UUID
    
    var nxtNumNeg:Bool? //set this as nil when its been applied
    
    @Published var oprButtonActive: Bool = false // activate this when any number is pressed. and thus an opertor could be used.
    
    var cachedSols: [String?]
    
    func loadData(isIncremental: Bool) {
        let devices=icloudstore.array(forKey: "devices") as! [String]
        for i in 0..<devices.count {
            if devices[i] == "empty" {
                continue
            }
            let tryDeviceLevel = icloudstore.object(forKey: "dev"+devices[i]+"lvl")
            if tryDeviceLevel != nil {
                let deviceLevel=tryDeviceLevel as! Int
                deviceData[devices[i]]=deviceLevel
                print("Set \(devices[i]) as \(deviceLevel)")
            }
        }
        deviceData[deviceID]=(defaults.object(forKey: "myLvl") as! Int)
        updtLvlName()
        
        let csGrab=icloudstore.object(forKey: "cards") as! Data
        let newcs:[card]=try! PropertyListDecoder().decode(Array<card>.self, from: csGrab)
        if cs != newcs && isIncremental {
            nextCardView(nxtCardSet: newcs)
        }
    }
    
    func resetStorage() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        let allKeys = NSUbiquitousKeyValueStore.default.dictionaryRepresentation.keys
        for key in allKeys {
            NSUbiquitousKeyValueStore.default.removeObject(forKey: key)
        }
        UserDefaults.standard.synchronize()
        icloudstore.synchronize()
    }
    
    let icloudstore: NSUbiquitousKeyValueStore
    
    @objc func storeUpdated(notification: Notification) {
        //deal with a store update
        loadData(isIncremental: true)
    }
    
    init() {
        icloudstore=NSUbiquitousKeyValueStore.default
        
        cs=[card(CardIcon: .club, numb: 1),card(CardIcon: .diamond, numb: 5),card(CardIcon: .heart, numb: 10),card(CardIcon: .spade, numb: 12)]
        cA=[true, true, true,true]
        
        lvl=1
        curQuestionID=UUID()
        cardsClickable=true
        
        cachedSols=Array(repeating: nil, count: 13*13*13*13)
        for i in 0..<tfqs.count {
            cachedSols[(tfqs[i][0]-1)*13*13*13+(tfqs[i][1]-1)*13*13+(tfqs[i][2]-1)*13+tfqs[i][3]-1]=tfas[i]
        }
        
        deviceID="empty"
                
        // store locally: Device ID
        // store in the cloud: All level information and card information
        
        NotificationCenter.default.addObserver(self, selector: #selector(storeUpdated(notification:)), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: icloudstore)
                
        // fetch device ID from UserDefaults
        let readDevID=defaults.string(forKey: "deviceID")
//        readDevID="C1CF3B9C-CD47-4CB6-BC45-06303F6F1613"
        
        if readDevID == nil {
            deviceID=UUID().uuidString
            deviceData[deviceID] = lvl
            print("Init \(deviceID)")
        } else {
            deviceID=readDevID!
        }
        
        icloudstore.synchronize()
        
        if readDevID == nil {
            let nxtNum=Int.random(in: 0..<tfqs.count)
            var crdSet=tfqs[nxtNum]
            crdSet.shuffle()
            for i in 0..<4 {
                cs[i]=card(CardIcon: cardIcon.allCases.randomElement()!, numb: crdSet[i])
            }
        } else {
            loadData(isIncremental: false)
            print("load")
        }
        print("My id is \(deviceID)")
        saveData()
        
        updtExpr()
        updtLvlName()
    }
        
    @Published var cardsClickable:Bool
    
    let viewShowDelay = 0.15
    let viewShowOrder=[1,3,0,2]
    var inTransition=false
    let softHapticsEngine=UIImpactFeedbackGenerator.init(style: .soft)
    let lightHapticsEngine=UIImpactFeedbackGenerator.init(style: .light)
    let mediumHapticsEngine=UIImpactFeedbackGenerator.init(style: .medium)
    let heavyHapticsEngine=UIImpactFeedbackGenerator.init(style: .heavy)
    let rigidHapticsEngine=UIImpactFeedbackGenerator.init(style: .rigid)
    enum haptic {
        case soft
        case light
        case medium
        case heavy
        case rigid
    }
    func generateHaptic(hap:haptic) {
        switch hap {
        case .soft:
            softHapticsEngine.impactOccurred()
        case .light:
            lightHapticsEngine.impactOccurred()
        case .medium:
            mediumHapticsEngine.impactOccurred()
        case .heavy:
            heavyHapticsEngine.impactOccurred()
        case .rigid:
            rigidHapticsEngine.impactOccurred()
        }
    }
    
    func nextCardView(nxtCardSet:[card]?) {
        if inTransition {
            return
        }
        answerShow=""
        nxtState = .ready
        cardsShouldVisible=Array(repeating: false, count: 4)
        curQuestionID=UUID()
        inTransition=true
        for i in 0..<viewShowOrder.count {
            DispatchQueue.main.asyncAfter(deadline: .now()+Double(i)*viewShowDelay, execute: { [self] in
                if i == viewShowOrder.count-1 {
                    inTransition=false
                }
                cardsShouldVisible[viewShowOrder[i]]=true
                softHapticsEngine.impactOccurred()
            })
        }
        
        if nxtCardSet == nil {
            let nxtNum=Int.random(in: 0..<tfqs.count)
            var crdSet=tfqs[nxtNum]
            crdSet.shuffle()
            for i in 0..<4 {
                cs[i]=card(CardIcon: cardIcon.allCases.randomElement()!, numb: crdSet[i])
            }
        } else {
            cs=nxtCardSet!
        }

        cA=[true,true,true,true]

        selectedOperator=nil
        withAnimation(.easeInOut(duration: cardAniDur)) {
            oprButtonActive=false
        }
        nxtNumNeg=nil
        mainVal=nil
        updtExpr()
        stored=nil
        updtStoredExpr()
        
        saveData()
    }
    
    enum daBtn:CaseIterable {
        case add
        case sub
        case mul
        case div
        case c1
        case c2
        case c3
        case c4
    }
    
    var konamiLog:[daBtn]=[]
    ***REMOVED***
    
    func konamiLimitation() -> Int {
        var rturn = 0
        for (itrDeviceID,itrLvl) in deviceData {
            if itrDeviceID != deviceID {
                rturn+=itrLvl-1
            }
        }
        rturn+=1
        return rturn
    }
    
    func logButtonKonami(button:daBtn) {
        konamiLog.append(button)
        if konamiLog.count > 11 {
            konamiLog.remove(at: 0)
        }
        if konamiLog == konamiCode {
            cardsClickable=false
            konamiCheatVisible=true
            cardsShouldVisible=Array(repeating: false, count: 4)
            curQuestionID=UUID()
        }
    }
    
    @Published var konamiCheatVisible:Bool=false
    
    @Published var cardsShouldVisible:[Bool]=[true,true,true,true]
    
    func konamiLvl(setLvl: Int?) {
        if (setLvl != nil) {
            //set the level
            if setLvl! >= konamiLimitation() {
                deviceData[deviceID]=setLvl!-konamiLimitation()+1
                updtLvlName()
                saveData()
            }
        }
        
        reset()
        cardsShouldVisible=Array(repeating: false, count: 4)
        cardsClickable=true
        inTransition=true
        konamiCheatVisible=false
        for i in 0..<viewShowOrder.count {
            DispatchQueue.main.asyncAfter(deadline: .now()+Double(i)*viewShowDelay+0.1, execute: { [self] in
                if i == viewShowOrder.count-1 {
                    inTransition=false
                }
                cardsShouldVisible[viewShowOrder[i]]=true
            })
        }
    }
    
    func handleOprPress(Opr:opr) {
        mediumHapticsEngine.impactOccurred()
        // replace whatever operator is currently in use. if there's nothing in the expression right now, turn the next number negative.
        
        if (mainVal == nil) {
            assert(Opr == .sub)
            if (nxtNumNeg == nil) {
                nxtNumNeg = true
            } else {
                nxtNumNeg!.toggle()
            }
        } else {
            selectedOperator = Opr
        }
        
        updtExpr()
    }
    let cardAniDur=0.17
            
    func handleNumberPress(index: Int) {
        mediumHapticsEngine.impactOccurred()
        
        if !cA[index] {
            return
        }
        
        if (selectedOperator == nil) {
            if (mainVal == nil) {
                withAnimation(.easeInOut(duration: cardAniDur)) {
                    cA[index]=false
                    oprButtonActive=true
                }
                mainVal=storedVal(value: Double(cs[index].numb), source: index)
            } else {
                if mainVal!.source == 4 {
                    // put into storage
                    if (stored == nil) {
                        stored=mainVal
                        mainVal=nil
                    } else {
                        precondition(stored!.source != 4)
                        
                        withAnimation(.easeInOut(duration: cardAniDur)) {
                            cA[stored!.source]=true
                        }
                        
                        stored=mainVal
                        
                        mainVal=nil
                        
                        //push out what is currently in storage back to the cards
                    }
                    
                    updtStoredExpr()
                    handleNumberPress(index: index)
                } else {
                    if mainVal!.source != index {
                        withAnimation(.easeInOut(duration: cardAniDur)) {
                            cA[mainVal!.source]=true
                            cA[index]=false
                        }
                        mainVal=storedVal(value: Double(cs[index].numb), source: index)
                    }
                }
            }
        } else {
            // do the math
            let addendB = Double(cs[index].numb)
            var pretendcA=cA
            pretendcA[index]=false
            let mathRes:mathResult=doMath(addendB: addendB, noCardsActive: !pretendcA.contains(true))
            if mathRes == .success {
                cA[index]=false
                nextCardView(nxtCardSet: nil)
                incrementLvl()
            } else if mathRes == .cont {
                withAnimation(.easeInOut(duration: cardAniDur)) {
                    cA[index]=false
                }
            }
        }
        updtExpr()
    }
    
    func incrementLvl() {
        deviceData[deviceID]!+=1
        updtLvlName()
        saveData()
    }
    
    func doMath(addendB: Double, noCardsActive: Bool) -> mathResult {
        let addendA = mainVal!.value * (nxtNumNeg == true ? -1 : 1)
        switch selectedOperator! {
        case .add:
            mainVal!.value=addendA+addendB
        case .div:
            mainVal!.value=addendA/addendB
        case .mul:
            mainVal!.value=addendA*addendB
        case .sub:
            mainVal!.value=addendA-addendB
        }
        mainVal!.source=4
        selectedOperator = nil
        
        nxtNumNeg=nil
        
        // check for all empty and 24
        let allEmpty: Bool = noCardsActive && stored == nil
        if allEmpty {
            if doubleEquality(a: mainVal!.value,b: 24) {
                return .success
            } else {
                reset()
                return .failure
            }
        }
        return .cont
    }
    
    func reset() { //deactivate everything and reset engine
        selectedOperator=nil
        nxtNumNeg=nil
        withAnimation(.easeInOut(duration: cardAniDur)) {
            for i in 0..<4 {
                cA[i]=true
            }
            oprButtonActive=false
        }
        mainVal=nil
        updtExpr()
        stored=nil
        updtStoredExpr()
    }
    
    func doStore() {
        mediumHapticsEngine.impactOccurred()
        //store can only be called if there's something in store or in the expression
        
        //handle operator selected
        //handle disabling operator selection and usage
        
        if (stored == nil) { //put the mainval into stored. it's now empty.
            if (mainVal != nil) {
                if nxtNumNeg == true {
                    nxtNumNeg=nil
                    mainVal!.value *= -1
                }
                stored=mainVal
                mainVal=nil
                selectedOperator=nil
                oprButtonActive=false
            }
        } else {
            if (mainVal == nil) {
                if nxtNumNeg == true {
                    nxtNumNeg=nil
                    stored!.value *= -1
                }
                mainVal=stored
                withAnimation(.easeInOut(duration: cardAniDur)) {
                    oprButtonActive=true
                    stored=nil
                }
            } else {
                if nxtNumNeg == true {
                    nxtNumNeg=nil
                    mainVal!.value *= -1
                }
                if selectedOperator == nil {
                    swap(&mainVal,&stored)
                } else {
                    let tmp=stored!.value
                    stored=nil
                    if doMath(addendB: tmp, noCardsActive: !cA.contains(true)) == .success {
                        nextCardView(nxtCardSet: nil)
                        incrementLvl()
                    }
                }
            }
        }
        
        updtStoredExpr()
        updtExpr()
    }
    
    @Published var answerShow:String = "888"
    @Published var answerShowOpacity:Double=0
    enum NxtState {
        case showingAnswer
        case inTransition
        case ready
    }
    @Published var nxtState:NxtState = .ready
    let ansBrightenTime=0.4
    let ansBlinkTime=0.3
    func nxtButtonPressed() {
        if nxtState == .inTransition {
            if !inTransition {
                nxtState = .showingAnswer
                answerShow=""
            } else {
                return
            }
        }
        if nxtState == .ready {
            softHapticsEngine.impactOccurred()
            expr=""
            // show the answer
            nxtState = .inTransition
            var ansCs=Array(repeating: 0, count: 4)
            for i in 0..<4 {
                ansCs[i]=cs[i].numb-1
            }
            ansCs=ansCs.sorted()
            answerShowOpacity=0
            answerShow = cachedSols[13*13*13*ansCs[0]+13*13*ansCs[1]+13*ansCs[2]+ansCs[3]]!
            withAnimation(.easeInOut(duration:ansBrightenTime)) {
                answerShowOpacity = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+ansBrightenTime, execute: { [self] in
                withAnimation(.easeInOut(duration:ansBlinkTime)) {
                    answerShowOpacity = 0.7
                }
            })
            DispatchQueue.main.asyncAfter(deadline: .now()+ansBrightenTime+ansBlinkTime, execute: { [self] in
                withAnimation(.easeInOut(duration:ansBlinkTime)) {
                    answerShowOpacity = 1.0
                }
            })
            DispatchQueue.main.asyncAfter(deadline: .now()+ansBlinkTime*2+ansBrightenTime, execute: { [self] in
                if nxtState == .inTransition {
                    nxtState = .showingAnswer
                }
            })
        }
        if nxtState == .showingAnswer && !inTransition {
            mediumHapticsEngine.impactOccurred()
            nxtState = .ready
            nextCardView(nxtCardSet: nil)
        }
    }
}
