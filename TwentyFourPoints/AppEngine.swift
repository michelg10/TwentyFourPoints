//
//  AppEngine.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/14.
//

import Foundation
import SwiftUI
import GameKit

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
    case divByZero
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

struct currentQuestion {
    var cs: [card]
    var sol: String
    var questionGenerated: Date
    var questionSession: String
}

class TFEngine: ObservableObject,tfCallable {
    func getDoSplit() -> Bool {
        return useSplit
    }
    
    func getUltraCompetitive() -> Bool {
        return ultraCompetitive
    }
    
    var curQ: currentQuestion
    
    //MARK: Updaters and Updatees
    var storedExpr: String?
    var expr: String = "" //update this from getExpr
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
    
    var cA: [Bool] // which cards are being activated and which are not
        
    var buttonsCanPress=false
    
    var cardsOnScreen = false
    
    var keyboardType: Int
    
    var showKeyboardTips: Bool
    
    var curKeyboardSettings: KeyboardShortcutSet?
    
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
    
    var ultraCompetitive: Bool
    
    var instantCompetitive: Bool
    
    struct devicePersistLevelData {
        var allTimeData: Int
        var weeklyData: Int
        var lastSaved: Date
    }
    
    var deviceData = [String: devicePersistLevelData]()
    
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
        defaults.setValue(deviceData[deviceID]!.allTimeData, forKey: "myLvl")
        defaults.setValue(deviceData[deviceID]!.lastSaved, forKey: "myWkSv")
        defaults.setValue(deviceData[deviceID]!.weeklyData, forKey: "myWkLvl")
        defaults.setValue(deviceID, forKey: "deviceID")
        defaults.setValue(synciCloud, forKey: "synciCloud")
        deviceData.removeValue(forKey: "empty")
        
        if synciCloud {
            let deviceList:[String]=Array(deviceData.keys)
            print("Devices: \(deviceList)")
            icloudstore.set(deviceList, forKey: "devices")
            icloudstore.set(deviceData[deviceID]!.allTimeData, forKey: "dev"+deviceID+"lvl") // i am only responsible for my own data
            icloudstore.set(deviceData[deviceID]!.lastSaved, forKey: "dev"+deviceID+"sv")
            icloudstore.set(deviceData[deviceID]!.weeklyData, forKey: "dev"+deviceID+"wklvl")
            icloudstore.set(try? PropertyListEncoder().encode(curQ.cs), forKey: "cards")
            icloudstore.set(useHaptics, forKey: "useHaptics")
            icloudstore.set(upperBound, forKey: "upperBound")
            icloudstore.set(ultraCompetitive, forKey: "ultraCompetitive")
            icloudstore.set(instantCompetitive, forKey: "instantCompetitive")
            icloudstore.set(prefersGameCenter, forKey: "prefersGameCenter")
            icloudstore.set(keyboardType, forKey: "keyboardType")
            switch preferredColorMode {
            case .none:
                icloudstore.set(0, forKey: "appearance")
            case .light:
                icloudstore.set(1, forKey: "appearance")
            case .dark:
                icloudstore.set(2, forKey: "appearance")
            case .some(_):
                icloudstore.set(0, forKey: "appearance")
            }
            icloudstore.set(showKeyboardTips, forKey: "showKeyboardTips")
            icloudstore.set(useSplit, forKey: "useSplit")
            icloudstore.set(isShowingAnswer, forKey: "isShowingAnswer")
            NSUbiquitousKeyValueStore.default.synchronize()
        } else {
            // save cards array locally
            defaults.set(try? PropertyListEncoder().encode(curQ.cs), forKey: "cards")

            defaults.set(useHaptics, forKey: "useHaptics")
            defaults.set(upperBound, forKey: "upperBound")
            defaults.set(ultraCompetitive, forKey: "ultraCompetitive")
            defaults.set(instantCompetitive, forKey: "instantCompetitive")
            defaults.set(prefersGameCenter, forKey: "prefersGameCenter")
            defaults.set(keyboardType, forKey: "keyboardType")
            switch preferredColorMode {
            case .none:
                defaults.set(0, forKey: "appearance")
            case .light:
                defaults.set(1, forKey: "appearance")
            case .dark:
                defaults.set(2, forKey: "appearance")
            case .some(_):
                icloudstore.set(0, forKey: "appearance")
            }
            defaults.set(showKeyboardTips, forKey: "showKeyboardTips")
            defaults.set(useSplit, forKey: "useSplit")
            defaults.set(isShowingAnswer, forKey: "isShowingAnswer")
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
    var levelInfo: LevelInfo
    
    func updtLvlName() {
        var newLvl=0 //this gaurentees an atomic lvl update
        var nxtLvlName: String?
        newLvl=0
        for i in deviceData.values {
            newLvl+=i.allTimeData-1
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
        reportAchievements()
        reportScores()
    }
    
    func reportScores() {
        if (gameCenterState == .success || gameCenterState == .couldNotAuth) && prefersGameCenter {
            GKLeaderboard.submitScore(levelInfo.lvl, context: 0, player: GKLocalPlayer.local, leaderboardIDs: ["persistLeaderboard"]) { (error: Error?) in
                if error != nil {
                    print("Error occured while reporting score \(String(describing: error))")
                }
            }
        }
    }
    
    var selectedOperator : opr?
    
    var useHaptics: Bool
    
    var synciCloud: Bool
    
    var upperBound: Int
    
    var uboundSnapshot: Int?
    
    var prefersGameCenter: Bool
    
    func setPrefersGameCenter(val: Bool) {
        if val==false {
            GKAccessPoint.shared.isActive=false
        }
        prefersGameCenter=val
    }
    
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
    
    var curQuestionID: UUID
    
    var nxtNumNeg:Bool? //set this as nil when its been applied
    
    @Published var oprButtonActive: Bool = false // activate this when any number is pressed. and thus an opertor could be used.
    
    var useSplit: Bool
    
    enum PersistLocation {
        case local
        case icloud
    }
    
    func grabData<T>(toGrab: inout T, id: String, persistLocation: PersistLocation) {
        var dataVal: Any?
        if persistLocation == .icloud {
            dataVal=icloudstore.object(forKey: id)
        }
        if dataVal != nil {
            toGrab=dataVal as! T
        } else {
            print(persistLocation == .icloud ? "iCloud" : "Local" + " \(id) data not present")
        }
    }
        
    func loadData(isIncremental: Bool) {
        print("Load data")
        let startingAppearance=preferredColorMode
        var hasToShowAnswer=false
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
                        let tryDeviceWeeklyLevel = icloudstore.object(forKey: "dev"+devices[i]+"wklvl")
                        let tryDeviceWeeklySave = icloudstore.object(forKey: "dev"+devices[i]+"sv")
                        var deviceWeeklySave=Date.init(timeIntervalSinceNow: 0.0)
                        var deviceWeeklyLevel=0
                        if tryDeviceWeeklySave != nil && tryDeviceLevel != nil {
                            deviceWeeklySave=tryDeviceWeeklySave as! Date
                            deviceWeeklyLevel=tryDeviceWeeklyLevel as! Int
                            print("Got device Weekly")
                        }
                        deviceData[devices[i]]=devicePersistLevelData(allTimeData: deviceLevel, weeklyData: deviceWeeklyLevel, lastSaved: deviceWeeklySave)
                        print("Set \(devices[i]) as \(deviceLevel), weekly \(deviceWeeklyLevel), last saved \(deviceWeeklySave)")
                    }
                }
            } else {
                print("iCloud devices list not present")
            }
        }
        let defaultsmyLvlVal=defaults.object(forKey: "myLvl")
        if defaultsmyLvlVal != nil {
            let localDataLevel=defaults.object(forKey: "myLvl") as! Int
            let tryLocalWeeklyLevel=defaults.object(forKey: "myWkLvl")
            let tryLocalWeeklySave=defaults.object(forKey: "myWkSv")
            var localWeeklyLevel=0
            var localWeeklySave=Date.init(timeIntervalSinceNow: 0.0)
            if tryLocalWeeklySave != nil && tryLocalWeeklyLevel != nil {
                localWeeklyLevel=tryLocalWeeklyLevel as! Int
                localWeeklySave=tryLocalWeeklySave as! Date
            }
            deviceData[deviceID]=devicePersistLevelData(allTimeData: localDataLevel, weeklyData: localWeeklyLevel, lastSaved: localWeeklySave)
        } else {
            print("Local level data not present")
            deviceData[deviceID]=devicePersistLevelData(allTimeData: 1, weeklyData: 0, lastSaved: Date.init(timeIntervalSinceNow: 0.0))
        }
        updtLvlName()
        
        var csGrab: Data?
        if synciCloud {
            csGrab=icloudstore.object(forKey: "cards") as? Data
            
            grabData(toGrab: &useHaptics, id: "useHaptics", persistLocation: .icloud)
            grabData(toGrab: &upperBound, id: "upperBound", persistLocation: .icloud)
            grabData(toGrab: &ultraCompetitive, id: "ultraCompetitive", persistLocation: .icloud)
            grabData(toGrab: &instantCompetitive, id: "instantCompetitive", persistLocation: .icloud)
            grabData(toGrab: &prefersGameCenter, id: "prefersGameCenter", persistLocation: .icloud)
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
            grabData(toGrab: &keyboardType, id: "keyboardType", persistLocation: .icloud)
            grabData(toGrab: &showKeyboardTips, id: "showKeyboardTips", persistLocation: .icloud)
            grabData(toGrab: &useSplit, id: "useSplit", persistLocation: .icloud)
            let isShowingAnswerSnapshot=isShowingAnswer
            grabData(toGrab: &isShowingAnswer, id: "isShowingAnswer", persistLocation: .icloud)
            if isShowingAnswer && !isShowingAnswerSnapshot {
                hasToShowAnswer=true
            }
        } else {
            csGrab=defaults.object(forKey: "cards") as? Data
            grabData(toGrab: &useHaptics, id: "useHaptics", persistLocation: .local)
            grabData(toGrab: &upperBound, id: "upperBound", persistLocation: .local)
            grabData(toGrab: &ultraCompetitive, id: "ultraCompetitive", persistLocation: .local)
            grabData(toGrab: &instantCompetitive, id: "instantCompetitive", persistLocation: .local)
            grabData(toGrab: &prefersGameCenter, id: "prefersGameCenter", persistLocation: .local)
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
            grabData(toGrab: &keyboardType, id: "keyboardType", persistLocation: .local)
            grabData(toGrab: &showKeyboardTips, id: "showKeyboardTips", persistLocation: .local)
            grabData(toGrab: &useSplit, id: "useSplit", persistLocation: .local)
            grabData(toGrab: &isShowingAnswer, id: "isShowingAnswer", persistLocation: .local)
        }
        if !prefersGameCenter {
            GKAccessPoint.shared.isActive=false
        }
        if csGrab != nil {
            let newcs:[card]=try! PropertyListDecoder().decode(Array<card>.self, from: csGrab!)
            if isIncremental {
                if curQ.cs != newcs {
                    nextCardView(nxtCardSet: newcs)
                }
            } else {
                curQ.cs=newcs
                let checkSolution=solution(problemSet: [curQ.cs[0].numb,curQ.cs[1].numb,curQ.cs[2].numb,curQ.cs[3].numb])
                if checkSolution==nil {
                    getRandomCards()
                } else {
                    curQ.sol=solution(problemSet: [curQ.cs[0].numb,curQ.cs[1].numb,curQ.cs[2].numb,curQ.cs[3].numb])!
                }
            }
        } else {
            nextCardView(nxtCardSet: nil)
        }
        if preferredColorMode != startingAppearance {
            updtColorScheme()
        }
        if hasToShowAnswer && nxtState == .ready {
            nxtButtonPressed()
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
    
    var preferredColorMode: ColorScheme?
    
    var gameCenterState: gcState
    
    enum gcState {
        case noAuth
        case success
        case couldNotAuth
        case unknown
    }
    
    func reportAchievements() {
        if (gameCenterState == .success || gameCenterState == .couldNotAuth) && prefersGameCenter {
            var achievementsToReport: [GKAchievement] = []
            for i in 0..<achievement.count {
                let theAch=GKAchievement(identifier: "level"+String(achievement[i].lvlReq))
                if levelInfo.lvl >= achievement[i].lvlReq {
                    theAch.percentComplete=100
                } else {
                    if i != achievement.count-1 {
                        theAch.percentComplete=Double(levelInfo.lvl)/Double(achievement[i].lvlReq)*100
                    }
                }
                theAch.showsCompletionBanner=false
                achievementsToReport.append(theAch)
            }
            GKAchievement.report(achievementsToReport) { (error: Error?) in
                if error != nil {
                    print("Error occured while reporting achievement \(String(describing: error))")
                }
            }
        }
        
    }
    
    var currentSession: String
    
    init(isPreview: Bool) {
        currentSession=UUID().uuidString
        icloudstore=NSUbiquitousKeyValueStore.default
        
        curQ = .init(cs: [card(CardIcon: .club, numb: 1),card(CardIcon: .diamond, numb: 5),card(CardIcon: .heart, numb: 10),card(CardIcon: .spade, numb: 12)], sol: "", questionGenerated: Date(), questionSession: currentSession)
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
        instantCompetitive=false
        keyboardType=1
        showKeyboardTips=true
        useSplit=true
        prefersGameCenter=true
        gameCenterState = .unknown
        isShowingAnswer=false
        
        curQ.sol=solution(problemSet: [curQ.cs[0].numb,curQ.cs[1].numb,curQ.cs[2].numb,curQ.cs[3].numb]) ?? "No Solution"
        
        if isPreview {
            return
        }

        // store locally: Device ID
        // store in the cloud: All level information and card information
        let doesicloudsync=defaults.value(forKey: "synciCloud")
        if doesicloudsync != nil {
            synciCloud=doesicloudsync as! Bool
        }
                
        // fetch device ID from UserDefaults
        let readDevID=defaults.string(forKey: "deviceID")
//        readDevID="C1CF3B9C-CD47-4CB6-BC45-06303F6F1613"
        
        if readDevID == nil {
            deviceID=UUID().uuidString
            deviceData[deviceID] = devicePersistLevelData(allTimeData: levelInfo.lvl, weeklyData: 0, lastSaved: Date.init(timeIntervalSinceNow: 0.0))
            print("Init \(deviceID)")
        } else {
            deviceID=readDevID!
        }
        
        if synciCloud {
            NotificationCenter.default.addObserver(self, selector: #selector(storeUpdated(notification:)), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: icloudstore)
        }
        
        if synciCloud {
            icloudstore.synchronize()
        }
        
        if readDevID == nil {
            getRandomCards()
        } else {
            loadData(isIncremental: false)
        }
        print("My id is \(deviceID)")
        saveData()
        
        setGCAuthHandler()
        
        updtExpr()
        updtLvlName()
    }
    
    func setAccessPointVisible(visible: Bool) {
        GKAccessPoint.shared.isActive=visible && prefersGameCenter
    }
    
    func setGCAuthHandler() {
        GKLocalPlayer.local.authenticateHandler = { [self] viewController, error in
            if let viewController = viewController {
                // how about not presenting the view controller since its annoying to the player
                gameCenterState = .noAuth
                return
            }
            if error != nil {
                // Player could not be authenticated
                // Disable Game Center in the game
                gameCenterState = .couldNotAuth
                return
            }
            if GKLocalPlayer.local.isAuthenticated {
                gameCenterState = .success
            }
        }
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
            curQ.cs[i]=card(CardIcon: cardIcon.allCases.randomElement()!, numb: Int(nxtCardsList[i]))
        }
        curQ.sol=String(cString: nxtCards.res.data)
        nxtCards.res.data.deallocate()
    }
        
    var cardsClickable:Bool
    
    func refresh() {
        objectWillChange.send()
    }
    
    let viewShowDelay = 0.12
    let viewShowOrder=[1,3,0,2]
    var inTransition=false
    
    var incorShowOpacity: Double
    var incorText:String
    var rewardScreenVisible: Bool = false
    
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
        isShowingAnswer=false
        cardsShouldVisible=Array(repeating: false, count: 4)
        curQuestionID=UUID()
        inTransition=true
        if !instantCompetitive {
            playCardsHaptic()
            objectWillChange.send()
        } else {
            hapticGate(hap: .soft)
        }
        for i in 0..<viewShowOrder.count {
            if cardsOnScreen {
                if instantCompetitive {
                    inTransition=false
                    cardsShouldVisible=Array(repeating: true, count: 4)
                    objectWillChange.send()
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now()+Double(i)*viewShowDelay, execute: { [self] in
                        if i == viewShowOrder.count-1 {
                            inTransition=false
                        }
                        cardsShouldVisible[viewShowOrder[i]]=true
                        objectWillChange.send()
                    })
                }
            } else {
                inTransition=false
                cardsShouldVisible[viewShowOrder[i]]=true
            }
        }
        
        if nxtCardSet == nil {
            getRandomCards()
        } else {
            curQ.cs=nxtCardSet!
            let checkSolution=solution(problemSet: [curQ.cs[0].numb,curQ.cs[1].numb,curQ.cs[2].numb,curQ.cs[3].numb])
            if checkSolution==nil {
                getRandomCards()
            } else {
                curQ.sol=solution(problemSet: [curQ.cs[0].numb,curQ.cs[1].numb,curQ.cs[2].numb,curQ.cs[3].numb])!
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
                rturn+=itrLvl.allTimeData-1
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
            objectWillChange.send()
        }
    }
    
    var konamiCheatVisible:Bool=false
    
    var cardsShouldVisible:[Bool]=[true,true,true,true]
    
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
                objectWillChange.send()
            })
        }
    }
    
    func konamiLvl(setLvl: Int?) {
        cardsOnScreen=true
        playCardsHaptic()
        if (setLvl != nil) {
            //set the level
            if setLvl! >= konamiLimitation() {
                let devSnapshot=deviceData[deviceID]!.allTimeData
                deviceData[deviceID]!.allTimeData=setLvl!-konamiLimitation()+1
                if deviceData[deviceID]!.allTimeData<devSnapshot {
                    GKAchievement.resetAchievements { [self] (error: Error?) in
                        if error != nil {
                            print("Error occured while reporting achievement \(String(describing: error))")
                        }
                        reportAchievements()
                        reportScores()
                    }
                }
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
                objectWillChange.send()
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
        objectWillChange.send()
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
                mainVal=storedVal(value: Double(curQ.cs[index].numb), source: index)
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
                            mainVal=storedVal(value: Double(curQ.cs[index].numb), source: index)
                        }
                    }
                }
            }
        } else {
            // do the math
            let addendB = Double(curQ.cs[index].numb)
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
                respondToFailure(isDivByZero: false)
            } else if mathRes == .divByZero {
                respondToFailure(isDivByZero: true)
            }
        }
        updtExpr()
        objectWillChange.send()
    }
    
    func respondToFailure(isDivByZero: Bool) {
        var currentExpr: String
        if isDivByZero {
            currentExpr=expr+"0"
        } else {
            updtExpr()
            currentExpr=expr
        }
        reset()
        incorText=currentExpr
        let flashDuration=0.2
        objectWillChange.send()
        incorShowOpacity=0.4
        objectWillChange.send()
        DispatchQueue.main.asyncAfter(deadline: .now()+flashDuration) { [self] in
            incorShowOpacity=1.0
            objectWillChange.send()
        }
    }
    
    func incrementLvl() {
        print("Increment Level")
        // check if rank has changed
        let lastRank = getLvlIndex(getLvl: levelInfo.lvl)
        deviceData[deviceID]!.allTimeData+=1
        GKLeaderboard.loadLeaderboards(IDs: ["weeklyLeaderboard"]) { [self] (fetchedLBs, error) in
            guard let lb = fetchedLBs?.first else { return }
            guard let endDate = lb.startDate?.addingTimeInterval(lb.duration), endDate > Date() else { return }
            print("Leaderboard starts \(lb.startDate!)")
            if lb.startDate!<Date() {
                if deviceData[deviceID]!.lastSaved<lb.startDate! {
                    deviceData[deviceID]!.weeklyData=0
                }
                deviceData[deviceID]!.weeklyData+=1
                deviceData[deviceID]!.lastSaved=Date()
                // total it up
                var totalWeekly=0
                for devData in deviceData.values {
                    if devData.lastSaved>=lb.startDate! {
                        totalWeekly+=devData.weeklyData
                        print("Totaling weekly data from device - saved \(devData.lastSaved), data \(devData.weeklyData)")
                    } else {
                        print("Data not in range - saved \(devData.lastSaved), data \(devData.weeklyData)")
                    }
                }
                lb.submitScore(totalWeekly, context: 0, player: GKLocalPlayer.local) { (error) in
                    if error != nil {
                        print("Error occured while reporting weekly score \(String(describing: error))")
                    }
                }
            }
        }
        
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
            return .divByZero
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
        objectWillChange.send()
    }
    
    func doStore() {
        hapticGate(hap: .light)
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
                        respondToFailure(isDivByZero: false)
                    } else if mathRturn == .divByZero {
                        respondToFailure(isDivByZero: true)
                    }
                }
            }
        }
        
        updtStoredExpr()
        updtExpr()
        objectWillChange.send()
    }
    
    var answerShow:String = "888"
    var answerShowOpacity:Double=0
    enum NxtState {
        case showingAnswer
        case inTransition
        case ready
    }
    var nxtState:NxtState = .ready
    let ansBrightenTime=0.4
    let ansBlinkTime=0.3
    var isShowingAnswer: Bool
    func nxtButtonPressed() {
        incorText=""
        if nxtState == .inTransition {
            if !inTransition {
                nxtState = .showingAnswer
                answerShow=""
                isShowingAnswer=false
                objectWillChange.send()
            } else {
                objectWillChange.send()
                return
            }
        }
        if nxtState == .ready {
            if cardsOnScreen {
                hapticGate(hap: .soft)
            }
            expr=""
            // show the answer
            nxtState = .inTransition
            answerShowOpacity=0
            answerShow = curQ.sol
            isShowingAnswer=true
            saveData()
            if cardsOnScreen {
                withAnimation(.easeInOut(duration:ansBrightenTime)) {
                    answerShowOpacity = 1.0
                }
                objectWillChange.send()
                DispatchQueue.main.asyncAfter(deadline: .now()+ansBrightenTime, execute: { [self] in
                    withAnimation(.easeInOut(duration:ansBlinkTime)) {
                        answerShowOpacity = 0.7
                    }
                    objectWillChange.send()
                })
                DispatchQueue.main.asyncAfter(deadline: .now()+ansBrightenTime+ansBlinkTime, execute: { [self] in
                    withAnimation(.easeInOut(duration:ansBlinkTime)) {
                        answerShowOpacity = 1.0
                    }
                    objectWillChange.send()
                })
                DispatchQueue.main.asyncAfter(deadline: .now()+ansBlinkTime*2+ansBrightenTime, execute: { [self] in
                    if nxtState == .inTransition {
                        nxtState = .showingAnswer
                    }
                })
            } else {
                answerShowOpacity = 1.0
                nxtState = .showingAnswer
                objectWillChange.send()
            }
        }
        if nxtState == .showingAnswer && !inTransition && cardsOnScreen {
            hapticGate(hap: .medium)
            nxtState = .ready
            nextCardView(nxtCardSet: nil)
        }
    }
}
