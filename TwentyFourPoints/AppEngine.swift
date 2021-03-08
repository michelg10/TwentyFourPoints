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

let qwertySet=KeyboardShortcutSet(resetButton: .init(" "), storeButton: .init("v"), numsButton: [.init("w"),.init("r"),.init("u"),.init("o")], oprsButton: [.init("s"),.init("f"),.init("j"),.init("l")], skipButton: .return)
let azertySet=KeyboardShortcutSet(resetButton: .init(" "), storeButton: .init("v"), numsButton: [.init("z"),.init("r"),.init("u"),.init("o")], oprsButton: [.init("s"),.init("f"),.init("j"),.init("l")], skipButton: .return)

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

class TFEngine: ObservableObject,tfCallable {
    func getDoSplit() -> Bool {
        return useSplit
    }
    
    func getUltraCompetitive() -> Bool {
        return ultraCompetitive
    }
    
    //MARK: Updaters and Updatees
    @Published var storedExpr: String?
    @Published var expr: String = "" //update this from getExpr
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
    
    var currentProblemSol: String="currentProblemSol"
    
    var buttonsCanPress=false
    
    var cardsOnScreen = false
    
    @Published var keyboardType: Int
    
    @Published var showKeyboardTips: Bool
    
    @Published var curKeyboardSettings: KeyboardShortcutSet?
    
    func getKeyboardSettings() -> KeyboardShortcutSet {
        if curKeyboardSettings == nil {
            return qwertySet
        }
        return curKeyboardSettings!
    }
    
    func getKeyboardType() {
        if keyboardType == 1 {
            curKeyboardSettings=qwertySet
        } else if keyboardType == 2 {
            curKeyboardSettings=azertySet
        }
    }
    
    @Published var ultraCompetitive: Bool
    
    var deviceData = [String: Int]()
    
    let defaults=UserDefaults.standard
    
    var deviceID: String
        
    func softStorageReset() {
        if synciCloud {
            icloudstore.synchronize()
            for (itrDeviceID,itrDeviceLvl) in deviceData {
                if itrDeviceID == deviceID { // only save my own level as a security (???) measure
                    print("Erasing \(itrDeviceID) -> \(itrDeviceLvl)")
                    icloudstore.removeObject(forKey: "dev"+itrDeviceID+"lvl")
                }
            }
            let myData=deviceData[deviceID]
            deviceData.removeAll()
            deviceData[deviceID]=myData
            saveData()
            konamiLvl(setLvl: nil)
            updtLvlName()
        }
    }
    
    var savingData: Bool=false
    
    func saveData() {
        if savingData {
            return
        }
        savingData=true
        print("Save data")
        if synciCloud {
            icloudstore.removeObject(forKey: "devemptylvl")
        }
        precondition(deviceID != "empty")
        defaults.setValue(deviceData[deviceID], forKey: "myLvl")
        defaults.setValue(deviceID, forKey: "deviceID")
        defaults.setValue(synciCloud, forKey: "synciCloud")
        deviceData.removeValue(forKey: "empty")
        
        if synciCloud {
            let deviceList:[String]=Array(deviceData.keys)
            print(deviceList)
            icloudstore.set(deviceList, forKey: "devices")
            for (itrDeviceID,itrDeviceLvl) in deviceData {
                if itrDeviceID == deviceID { // only save my own level as a security (???) measure
                    print("Saving \(itrDeviceID) as \(itrDeviceLvl)")
                    icloudstore.set(itrDeviceLvl, forKey: "dev"+itrDeviceID+"lvl")
                }
            }
            icloudstore.set(try? PropertyListEncoder().encode(cs), forKey: "cards")
            icloudstore.set(useHaptics, forKey: "useHaptics")
            icloudstore.set(upperBound, forKey: "upperBound")
            icloudstore.set(ultraCompetitive, forKey: "ultraCompetitive")
            icloudstore.set(keyboardType, forKey: "keyboardType")
            switch preferredColorMode {
            case .none:
                icloudstore.set(0, forKey: "appearance")
            case .light:
                icloudstore.set(1, forKey: "appearance")
            case .dark:
                icloudstore.set(2, forKey: "appearance")
            }
            icloudstore.set(showKeyboardTips, forKey: "showKeyboardTips")
            icloudstore.set(useSplit, forKey: "useSplit")
            NSUbiquitousKeyValueStore.default.synchronize()
        } else {
            // save cards array locally
            defaults.set(try? PropertyListEncoder().encode(cs), forKey: "cards")

            defaults.set(useHaptics, forKey: "useHaptics")
            defaults.set(upperBound, forKey: "upperBound")
            defaults.set(ultraCompetitive, forKey: "ultraCompetitive")
            defaults.set(keyboardType, forKey: "keyboardType")
            switch preferredColorMode {
            case .none:
                defaults.set(0, forKey: "appearance")
            case .light:
                defaults.set(1, forKey: "appearance")
            case .dark:
                defaults.set(2, forKey: "appearance")
            }
            defaults.set(showKeyboardTips, forKey: "showKeyboardTips")
            defaults.set(useSplit, forKey: "useSplit")
        }
        defaults.synchronize()
        savingData=false
    }
    
    var stored: storedVal?
    
    var mainVal: storedVal? //put any calculation result into here
    
    func getLvlIndex(getLvl:Int) -> Int {
        if getLvl < achievement[0].lvlReq {
            return -1
        }
        for i in 0..<achievement.count {
            if getLvl >= achievement[achievement.count-i-1].lvlReq {
                return achievement.count-i-1
            }
        }
        return -1
    }
    
    struct LevelInfo {
        var lvl: Int
        var lvlName: String?
    }
    @Published var levelInfo: LevelInfo
    
    func updtLvlName() {
        var newLvl=0 //this gaurentees an atomic lvl update
        var nxtLvlName: String?
        newLvl=0
        for i in deviceData.values {
            newLvl+=i-1
        }
        newLvl+=1
        let myRank=getLvlIndex(getLvl: newLvl)
        print("Rank for \(newLvl) -> \(myRank)")
        if myRank == -1 {
            nxtLvlName=nil
        } else {
            nxtLvlName = achievement[myRank].name
        }
        levelInfo=LevelInfo(lvl: newLvl, lvlName: nxtLvlName)
    }
    
    var selectedOperator : opr?
    
    var useHaptics: Bool
    
    var synciCloud: Bool
    
    @Published var upperBound: Int
    
    var uboundSnapshot: Int?
    
    func snapshotUBound() {
        uboundSnapshot=upperBound
    }
    
    func commitSnap() {
        if uboundSnapshot != nil {
            if upperBound != uboundSnapshot {
                cachedCards=nil
                nextCardView(nxtCardSet: nil)
            }
            uboundSnapshot=nil
        }
    }
    
    @Published var curQuestionID: UUID
    
    var nxtNumNeg:Bool? //set this as nil when its been applied
    
    @Published var oprButtonActive: Bool = false // activate this when any number is pressed. and thus an opertor could be used.
    
    @Published var useSplit: Bool
        
    func loadData(isIncremental: Bool) {
        print("Load data")
        let startingAppearance=preferredColorMode
        if synciCloud {
            let icloudDevicesVal=icloudstore.array(forKey: "devices")
            if icloudDevicesVal != nil {
                let devices=icloudDevicesVal as! [String]
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
            } else {
                print("iCloud devices list not present")
            }
        }
        let defaultsmyLvlVal=defaults.object(forKey: "myLvl")
        if defaultsmyLvlVal != nil {
            deviceData[deviceID]=(defaults.object(forKey: "myLvl") as! Int)
        } else {
            print("Local level data not present")
            deviceData[deviceID]=1
        }
        updtLvlName()
        
        var csGrab: Data
        if synciCloud {
            csGrab=icloudstore.object(forKey: "cards") as! Data
            let icloudHapticVal=icloudstore.object(forKey: "useHaptics")
            if icloudHapticVal != nil {
                useHaptics=icloudHapticVal as! Bool
            } else {
                print("iCloud haptics data not present")
            }
            let upperBoundVal=icloudstore.object(forKey: "upperBound")
            if upperBoundVal != nil {
                upperBound=upperBoundVal as! Int
            } else {
                print("iCloud upper bound data not present")
            }
            let ultraCompetitiveVal=icloudstore.object(forKey: "ultraCompetitive")
            if ultraCompetitiveVal != nil {
                ultraCompetitive=ultraCompetitiveVal as! Bool
            } else {
                print("iCloud ultra competitive data not present")
            }
            let appearanceVal=icloudstore.object(forKey: "appearance")
            if appearanceVal != nil {
                let tmpAppearanceVal = appearanceVal as! Int
                if tmpAppearanceVal == 0 {
                    preferredColorMode = .none
                } else if tmpAppearanceVal == 1 {
                    preferredColorMode = .light
                } else if tmpAppearanceVal == 2 {
                    preferredColorMode = .dark
                }
            } else {
                print("iCloud appearance data not present")
            }
            let keyboardTypeVal=icloudstore.object(forKey: "keyboardType")
            if keyboardTypeVal != nil {
                keyboardType=keyboardTypeVal as! Int
            } else {
                print("iCloud keyboard type data not present")
            }
            let showKeyboardTipsVal=icloudstore.object(forKey: "showKeyboardTips")
            if showKeyboardTipsVal != nil {
                showKeyboardTips=showKeyboardTipsVal as! Bool
            } else {
                print("iCloud show keyboard tips data not present")
            }
            let useSplitVal=icloudstore.object(forKey: "useSplit")
            if useSplitVal != nil {
                useSplit=useSplitVal as! Bool
            } else {
                print("iCloud use split data not present")
            }
        } else {
            csGrab=defaults.object(forKey: "cards") as! Data
            let localHapticsVal=defaults.object(forKey: "useHaptics")
            if localHapticsVal != nil {
                useHaptics=localHapticsVal as! Bool
            } else {
                print("Local haptics data not present")
            }
            let upperBoundVal=defaults.object(forKey: "upperBound")
            if upperBoundVal != nil {
                upperBound=upperBoundVal as! Int
            } else {
                print("Local upper bound data not present")
            }
            let ultraCompetitiveVal=defaults.object(forKey: "ultraCompetitive")
            if ultraCompetitiveVal != nil {
                ultraCompetitive=ultraCompetitiveVal as! Bool
            } else {
                print("Local ultra competitive data not present")
            }
            let appearanceVal=defaults.object(forKey: "appearance")
            if appearanceVal != nil {
                let tmpAppearanceVal = appearanceVal as! Int
                if tmpAppearanceVal == 0 {
                    preferredColorMode = .none
                } else if tmpAppearanceVal == 1 {
                    preferredColorMode = .light
                } else if tmpAppearanceVal == 2 {
                    preferredColorMode = .dark
                }
            } else {
                print("Local appearance data not present")
            }
            let keyboardTypeVal=defaults.object(forKey: "keyboardType")
            if keyboardTypeVal != nil {
                keyboardType=keyboardTypeVal as! Int
            } else {
                print("Local keyboard type data not present")
            }
            let showKeyboardTipsVal=defaults.object(forKey: "showKeyboardTips")
            if showKeyboardTipsVal != nil {
                showKeyboardTips=showKeyboardTipsVal as! Bool
            } else {
                print("Local show keyboard tips data not present")
            }
            let useSplitVal=defaults.object(forKey: "useSplit")
            if useSplitVal != nil {
                useSplit=useSplitVal as! Bool
            } else {
                print("iCloud use split data not present")
            }
        }
        let newcs:[card]=try! PropertyListDecoder().decode(Array<card>.self, from: csGrab)
        if isIncremental {
            if cs != newcs {
                nextCardView(nxtCardSet: newcs)
            }
        } else {
            cs=newcs
            let checkSolution=solution(problemSet: [cs[0].numb,cs[1].numb,cs[2].numb,cs[3].numb])
            if checkSolution==nil {
                getRandomCards()
            } else {
                currentProblemSol=solution(problemSet: [cs[0].numb,cs[1].numb,cs[2].numb,cs[3].numb])!
            }
        }
        if preferredColorMode != startingAppearance {
            updtColorScheme()
        }
        getKeyboardType()
    }
    
    func updtColorScheme() {
        switch preferredColorMode {
        case .none:
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .unspecified
        case .light:
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
        case .dark:
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
        }
    }
    
    func solution(problemSet: [Int]) -> String? {
        let solvedData=solve24(Int32(problemSet[0]), Int32(problemSet[1]), Int32(problemSet[2]), Int32(problemSet[3])).data
        let solutionToProblem=String(cString: solvedData!)
        solvedData?.deallocate()
        if solutionToProblem=="nosol" {
            return nil
        }
        return solutionToProblem
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
    
    func setiCloudSync(val: Bool) {
        if val==synciCloud {
            return
        }
        if val==true {
            NotificationCenter.default.addObserver(self, selector: #selector(storeUpdated(notification:)), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: icloudstore)
            synciCloud=val
            saveData()
            loadData(isIncremental: false)
        } else {
            NotificationCenter.default.removeObserver(self, name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: icloudstore)
            icloudstore.removeObject(forKey: "dev"+deviceID+"lvl")
            icloudstore.synchronize()
            let myData=deviceData[deviceID]
            deviceData.removeAll()
            deviceData[deviceID]=myData
            updtLvlName()
            synciCloud=val
            saveData()
        }
    }
    
    func hapticGate(hap:haptic) {
        if useHaptics {
            generateHaptic(hap: hap)
        }
    }
    
    @Published var preferredColorMode: ColorScheme?
    
    init(isPreview: Bool) {
        icloudstore=NSUbiquitousKeyValueStore.default
        
        cs=[card(CardIcon: .club, numb: 1),card(CardIcon: .diamond, numb: 5),card(CardIcon: .heart, numb: 10),card(CardIcon: .spade, numb: 12)]
        cA=[true, true, true,true]
        
        if isPreview {
            levelInfo=LevelInfo(lvl: 696, lvlName: "Mimi")
            expr="Expression"
        } else {
            levelInfo=LevelInfo(lvl: 1, lvlName: nil)
        }
        curQuestionID=UUID()
        cardsClickable=true
        
        deviceID="empty"
        
        incorText=""
        incorShowOpacity=1
        
        useHaptics=true
        synciCloud=true
        upperBound=13
        ultraCompetitive=false
        keyboardType=1
        showKeyboardTips=true
        useSplit=true
        
        if isPreview {
            return
        }

        // store locally: Device ID
        // store in the cloud: All level information and card information
        let doesicloudsync=defaults.value(forKey: "synciCloud")
        if doesicloudsync != nil {
            synciCloud=doesicloudsync as! Bool
        }
        
        if synciCloud {
            NotificationCenter.default.addObserver(self, selector: #selector(storeUpdated(notification:)), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: icloudstore)
        }
                
        // fetch device ID from UserDefaults
        let readDevID=defaults.string(forKey: "deviceID")
//        readDevID="C1CF3B9C-CD47-4CB6-BC45-06303F6F1613"
        
        if readDevID == nil {
            deviceID=UUID().uuidString
            deviceData[deviceID] = levelInfo.lvl
            print("Init \(deviceID)")
        } else {
            deviceID=readDevID!
        }
        
        if synciCloud {
            icloudstore.synchronize()
        }
        
        if readDevID == nil {
            getRandomCards()
        } else {
            loadData(isIncremental: false)
            print("load")
        }
        print("My id is \(deviceID)")
        saveData()
        
        updtExpr()
        updtLvlName()
    }
    
    var cachedCards: problem24?
    
    var cacheFilling: Bool = false
    
    func fillCache() {
        if cacheFilling||cachedCards != nil {
            return
        }
        DispatchQueue.main.async { [self] in
            cacheFilling=true
            cachedCards=generateProblem(Int32(upperBound))
            cacheFilling=false
        }
    }
    
    func getRandomCards() {
        var nxtCards: problem24
        if cachedCards == nil {
            fillCache()
            nxtCards=generateProblem(Int32(upperBound))
        } else {
            nxtCards=cachedCards!
            cachedCards=nil
            fillCache()
        }
        let nxtCardsList=[nxtCards.c1,nxtCards.c2,nxtCards.c3,nxtCards.c4]
        for i in 0..<4 {
            cs[i]=card(CardIcon: cardIcon.allCases.randomElement()!, numb: Int(nxtCardsList[i]))
        }
        currentProblemSol=String(cString: nxtCards.res.data)
        nxtCards.res.data.deallocate()
    }
        
    @Published var cardsClickable:Bool
    
    let viewShowDelay = 0.15
    let viewShowOrder=[1,3,0,2]
    var inTransition=false
    
    @Published var incorShowOpacity: Double
    @Published var incorText:String
    @Published var rewardScreenVisible: Bool = false
    
    func playCardsHaptic() {
        for i in 0..<viewShowOrder.count {
            DispatchQueue.main.asyncAfter(deadline: .now()+Double(i)*viewShowDelay, execute: { [self] in
                if cardsOnScreen {
                    print("Play cards haptic")
                    hapticGate(hap: .soft)
                }
            })
        }
    }
    
    func nextCardView(nxtCardSet:[card]?) {
        if inTransition {
            return
        }
        incorText=""
        answerShow=""
        nxtState = .ready
        cardsShouldVisible=Array(repeating: false, count: 4)
        curQuestionID=UUID()
        inTransition=true
        playCardsHaptic()
        for i in 0..<viewShowOrder.count {
            if cardsOnScreen {
                DispatchQueue.main.asyncAfter(deadline: .now()+Double(i)*viewShowDelay, execute: { [self] in
                    if i == viewShowOrder.count-1 {
                        inTransition=false
                    }
                    cardsShouldVisible[viewShowOrder[i]]=true
                })
            } else {
                inTransition=false
                cardsShouldVisible[viewShowOrder[i]]=true
            }
        }
        
        if nxtCardSet == nil {
            getRandomCards()
        } else {
            cs=nxtCardSet!
            let checkSolution=solution(problemSet: [cs[0].numb,cs[1].numb,cs[2].numb,cs[3].numb])
            if checkSolution==nil {
                getRandomCards()
            } else {
                currentProblemSol=solution(problemSet: [cs[0].numb,cs[1].numb,cs[2].numb,cs[3].numb])!
            }
        }

        cA=[true,true,true,true]

        selectedOperator=nil
        if cardsOnScreen {
            withAnimation(.easeInOut(duration: cardAniDur)) {
                oprButtonActive=false
            }
        } else {
            oprButtonActive=false
        }
        nxtNumNeg=nil
        mainVal=nil
        updtExpr()
        stored=nil
        updtStoredExpr()
        
        saveData()
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
            cardsOnScreen=false
            cardsClickable=false
            konamiCheatVisible=true
            cardsShouldVisible=Array(repeating: false, count: 4)
            curQuestionID=UUID()
        }
    }
    
    @Published var konamiCheatVisible:Bool=false
    
    @Published var cardsShouldVisible:[Bool]=[true,true,true,true]
    
    func dismissRank() {
        cardsOnScreen=true
        playCardsHaptic()
        reset()
        cardsShouldVisible=Array(repeating: false, count: 4)
        cardsClickable=true
        inTransition=true
        rewardScreenVisible=false
        for i in 0..<viewShowOrder.count {
            DispatchQueue.main.asyncAfter(deadline: .now()+Double(i)*viewShowDelay+0.1, execute: { [self] in
                if i == viewShowOrder.count-1 {
                    inTransition=false
                }
                cardsShouldVisible[viewShowOrder[i]]=true
            })
        }
    }
    
    func konamiLvl(setLvl: Int?) {
        cardsOnScreen=true
        playCardsHaptic()
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
        incorText=""
        hapticGate(hap: .light)
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
    let cardAniDur=0.07
            
    func handleNumberPress(index: Int) {
        incorText=""
        hapticGate(hap: .light)
        
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
                    }
                    
                    updtStoredExpr()
                    handleNumberPress(index: index)
                } else {
                    if stored == nil {
                        // push into storage
                        stored=mainVal
                        mainVal=nil
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
            } else if mathRes == .failure {
                respondToFailure()
            }
        }
        updtExpr()
    }
    
    func respondToFailure() {
        updtExpr()
        let currentExpr=expr
        reset()
        incorText=currentExpr
        let flashDuration=0.2
        incorShowOpacity=0.6
        DispatchQueue.main.asyncAfter(deadline: .now()+flashDuration) { [self] in
            incorShowOpacity=1.0
        }
    }
    
    func incrementLvl() {
        print("Increment Level")
        // check if rank has changed
        let lastRank = getLvlIndex(getLvl: levelInfo.lvl)
        deviceData[deviceID]!+=1
        updtLvlName()
        let currentRank=getLvlIndex(getLvl: levelInfo.lvl)
        if currentRank != lastRank {
            // show
            cardsOnScreen=false
            cardsClickable=false
            rewardScreenVisible=true
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: { [self] in
                hapticGate(hap: .rigid)
            })
            cardsShouldVisible=Array(repeating: false, count: 4)
            curQuestionID=UUID()
        }
        saveData()
    }
    
    func doMath(addendB: Double, noCardsActive: Bool) -> mathResult {
        let addendA = mainVal!.value * (nxtNumNeg == true ? -1 : 1)
        if selectedOperator == .div && doubleEquality(a: addendB, b: 0) {
            mainVal!.value=0
            selectedOperator = nil
            return .failure
        }
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
            if doubleEquality(a: abs(mainVal!.value),b: 24) {
                return .success
            } else {
                return .failure
            }
        }
        return .cont
    }
    
    func reset() { //deactivate everything and reset engine
        incorText=""
        selectedOperator=nil
        nxtNumNeg=nil
        withAnimation(.easeInOut(duration: cardAniDur)) {
            cA=Array(repeating: true, count: 4)
            oprButtonActive=false
        }
        mainVal=nil
        updtExpr()
        stored=nil
        updtStoredExpr()
    }
    
    func doStore() {
        hapticGate(hap: .medium)
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
                    let mathRturn=doMath(addendB: tmp, noCardsActive: !cA.contains(true))
                    if mathRturn == .success {
                        nextCardView(nxtCardSet: nil)
                        incrementLvl()
                    } else if mathRturn == .failure {
                        respondToFailure()
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
        incorText=""
        if nxtState == .inTransition {
            if !inTransition {
                nxtState = .showingAnswer
                answerShow=""
            } else {
                return
            }
        }
        if nxtState == .ready {
            hapticGate(hap: .soft)
            expr=""
            // show the answer
            nxtState = .inTransition
            var ansCs=Array(repeating: 0, count: 4)
            for i in 0..<4 {
                ansCs[i]=cs[i].numb-1
            }
            ansCs=ansCs.sorted()
            answerShowOpacity=0
            answerShow = currentProblemSol
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
            hapticGate(hap: .medium)
            nxtState = .ready
            nextCardView(nxtCardSet: nil)
        }
    }
}
