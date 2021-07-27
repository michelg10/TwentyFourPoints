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

struct card:Codable, Equatable {
    var CardIcon:cardIcon
    var numb:Int
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

enum gcState {
    case noAuth
    case success
    case couldNotAuth
    case unknown
}

struct currentQuestion {
    var cs: [card]
    var sol: String
    var questionShown: Date
    var questionSession: String
    var ubound: Int
}
struct BestTime: Codable {
    var time: Double
    var qspan: Int
}
enum achievementState: String,Codable {
    case questions="questions"
    case speed="speed"
}

struct customAchievement {
    var img: UIImage?
    var id: String
}

let currentVersion=46

class TFEngine: ObservableObject,tfCallable {
    
    // routing everything to TFCalcEngine
    var calcEngine: TFCalcEngine
    func reset() {
        calcEngine.reset()
    }
    func doStore() {
        calcEngine.doStore()
    }
    
    func handleNumberPress(index: Int) {
        calcEngine.handleNumberPress(index: index)
    }
    
    func handleOprPress(Opr: opr) {
        calcEngine.handleOprPress(Opr: Opr)
    }
    
    func handleKeyboardNumberPress(number: Int?) {
        if cardsClickable && nxtState == .ready {
            calcEngine.handleKeyboardNumberPress(number: number)
        }
    }
    
    var solengine: solverEngine
    
    var showWhatsNewView=false
    
    //All the speed achievement stuff
    /*
    var bestTime = BestTime(time: -1, qspan: 30)
    var speedAchievementsLocked=true
    
    // how the image data is going to work: each device will keep a local version of the file.
    // If iCloud is enabled, then check if there is an update (probably through a sync key with iCloud KVS)
    // if there is, download it, replace the image in memory, and run the save image function
    // the incremental image save function: check if the current id of the image matches with the one in icloud. If not, then overwrite the one in icloud
    // the image save function: is called when the user modifies the image. the function is responsible for
    // saving the new image to memory, generating a new ID, and saving it to iCloud.
    
    // these functions are time intensive, so call them sparingly
    
    func saveImageData(newimg: UIImage) {
        
    }
    
    func saveImageDataIncrementally() {
        var doesSynciCloud=synciCloud
        var icloudCont: URL?
        if doesSynciCloud {
            DispatchQueue.global().async {
                icloudCont=FileManager.default.url(forUbiquityContainerIdentifier: nil)
                if icloudCont == nil {
                    doesSynciCloud=false
                }
            }
        }
        if doesSynciCloud {
            
        }
    }
    
    func loadImageData() {
        // save and keep track of the modification date of the icloud and the local image. when loading image data,
    }
     */
    
    var savedVersion=currentVersion
    
    var currentAchievementState: achievementState = .questions
    
    func getDoSplit() -> Bool {
        return useSplit
    }
    
    func getUltraCompetitive() -> Bool {
        return true
    }
    
    var curQ: currentQuestion
    
    //MARK: Updaters and Updatees
        
    var buttonsCanPress=false
    
    var cardsOnScreen = false
        
    var showKeyboardTips: Bool
        
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
    
    func storeData<T>(toStore: T, id: String, persistLocation: PersistLocation) {
        if persistLocation == .icloud {
            icloudstore.set(toStore, forKey: id)
        } else {
            defaults.set(toStore,forKey: id)
        }
    }
    
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
        
        let persistLoc = synciCloud ? PersistLocation.icloud : PersistLocation.local
        
        storeData(toStore: useHaptics, id: "useHaptics", persistLocation: persistLoc)
        storeData(toStore: upperBound, id: "upperBound", persistLocation: persistLoc)
        storeData(toStore: instantCompetitive, id: "instantCompetitive", persistLocation: persistLoc)
        storeData(toStore: prefersGameCenter, id: "prefersGameCenter", persistLocation: persistLoc)
        storeData(toStore: showKeyboardTips, id: "showKeyboardTips", persistLocation: persistLoc)
        storeData(toStore: useSplit, id: "useSplit", persistLocation: persistLoc)
        storeData(toStore: solengine.cards, id: "solCards", persistLocation: persistLoc)
        storeData(toStore: isShowingAnswer, id: "isShowingAnswer", persistLocation: persistLoc)
        let tmpCurAchState: String=currentAchievementState.rawValue
        storeData(toStore: tmpCurAchState, id: "curAchState", persistLocation: persistLoc)
        storeData(toStore: try? PropertyListEncoder().encode(curQ.cs), id: "cards", persistLocation: persistLoc)
        storeData(toStore: curQ.questionShown, id: "cardsDate", persistLocation: persistLoc)
        storeData(toStore: curQ.ubound, id: "cardsBound", persistLocation: persistLoc)
        let encodedAppearance: Int
        switch preferredColorMode {
        case .none:
            encodedAppearance=0
        case .light:
            encodedAppearance=1
        case .dark:
            encodedAppearance=2
        case .some(_):
            encodedAppearance=0
        }
        storeData(toStore: encodedAppearance, id: "appearance", persistLocation: persistLoc)
        
        storeData(toStore: savedVersion, id: "savedVersion", persistLocation: .local)
        
        if synciCloud {
            let deviceList:[String]=Array(deviceData.keys)
            print("Devices: \(deviceList)")
            icloudstore.set(deviceList, forKey: "devices")
            icloudstore.set(deviceData[deviceID]!.allTimeData, forKey: "dev"+deviceID+"lvl") // i am only responsible for my own data
            icloudstore.set(deviceData[deviceID]!.lastSaved, forKey: "dev"+deviceID+"sv")
            icloudstore.set(deviceData[deviceID]!.weeklyData, forKey: "dev"+deviceID+"wklvl")
            NSUbiquitousKeyValueStore.default.synchronize()
        }
        defaults.synchronize()
        savingData=false
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
        let myRank=getQuestionLvlIndex(getLvl: newLvl)
        print("Rank for \(newLvl) -> \(myRank)")
        if myRank == -1 {
            nxtLvlName=nil
        } else {
            nxtLvlName = lvlachievement[myRank].title
        }
        levelInfo=LevelInfo(lvl: newLvl, lvlName: nxtLvlName)
        reportAchievements()
        reportScores()
        
        /*
        if levelInfo.lvl > speedAchievementsLockedThreshold {
            speedAchievementsLocked=false
        }
         */
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
        
    var useSplit: Bool
    
    enum PersistLocation {
        case local
        case icloud
    }
    
    func grabData<T>(toGrab: inout T, id: String, persistLocation: PersistLocation) {
        var dataVal: Any?
        if persistLocation == .icloud {
            dataVal=icloudstore.object(forKey: id)
        } else if persistLocation == .local {
            dataVal=defaults.object(forKey: id)
        }
        if dataVal != nil {
            toGrab=dataVal as! T
        } else {
            print((persistLocation == .icloud ? "iCloud" : "Local") + " \(id) data not present")
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
        
        let persLoc = synciCloud ? PersistLocation.icloud: PersistLocation.local
        
        grabData(toGrab: &useHaptics, id: "useHaptics", persistLocation: persLoc)
        grabData(toGrab: &upperBound, id: "upperBound", persistLocation: persLoc)
        grabData(toGrab: &instantCompetitive, id: "instantCompetitive", persistLocation: persLoc)
        grabData(toGrab: &prefersGameCenter, id: "prefersGameCenter", persistLocation: persLoc)
        grabData(toGrab: &showKeyboardTips, id: "showKeyboardTips", persistLocation: persLoc)
        grabData(toGrab: &useSplit, id: "useSplit", persistLocation: persLoc)
        var tmpCurAchState=""
        grabData(toGrab: &tmpCurAchState, id: "curAchState", persistLocation: persLoc)
        currentAchievementState=achievementState.init(rawValue: tmpCurAchState) ?? .questions
        grabData(toGrab: &solengine.cards, id: "solCards", persistLocation: persLoc)
        solengine.computeSolution()
        
        var csGrab: Data?
        // card data to grab: the cards themselves, the upper bound, the date they were generated
        var csDate: Date?
        var csBound: Int?
        grabData(toGrab: &csGrab, id: "cards", persistLocation: persLoc)
        grabData(toGrab: &csDate, id: "cardsDate", persistLocation: persLoc)
        grabData(toGrab: &csBound, id: "cardsBound", persistLocation: persLoc)
        
        savedVersion = -1
        grabData(toGrab: &savedVersion, id: "savedVersion", persistLocation: .local)
        
        if synciCloud {
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
            let isShowingAnswerSnapshot=isShowingAnswer
            grabData(toGrab: &isShowingAnswer, id: "isShowingAnswer", persistLocation: .icloud)
            if isShowingAnswer && !isShowingAnswerSnapshot {
                hasToShowAnswer=true
            }
        } else {
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
            grabData(toGrab: &isShowingAnswer, id: "isShowingAnswer", persistLocation: .local)
        }
        if !prefersGameCenter {
            GKAccessPoint.shared.isActive=false
        }
        if csGrab != nil {
            let newcs:[card]=try! PropertyListDecoder().decode(Array<card>.self, from: csGrab!)
            if curQ.cs != newcs {
                if isIncremental {
                    nextCardView(nxtCardSet: newcs)
                    curQ.ubound=csBound ?? -1
                    curQ.questionShown=csDate ?? Date()
                } else {
                    let checkSolution=solution(problemSet: [newcs[0].numb,newcs[1].numb,newcs[2].numb,newcs[3].numb])
                    if checkSolution==nil {
                        getRandomCards()
                    } else {
                        curQ.cs=newcs
                        curQ.sol=solution(problemSet: [curQ.cs[0].numb,curQ.cs[1].numb,curQ.cs[2].numb,curQ.cs[3].numb])!
                        curQ.questionShown=csDate ?? Date()
                        curQ.questionSession="OtherDevice"
                        curQ.ubound=csBound ?? -1
                    }
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
        
        currentAchievementState = .questions
        /*
        if currentAchievementState == .speed && speedAchievementsLocked {
            currentAchievementState = .questions
        }
         */
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
        DispatchQueue.main.async { [self] in
            objectWillChange.send()
        }
    }
    
    func setiCloudSync(val: Bool) {
        if val==synciCloud {
            return
        }
        if val==true {
            NotificationCenter.default.addObserver(self, selector: #selector(storeUpdated(notification:)), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: icloudstore)
            synciCloud=val
            loadData(isIncremental: false)
        } else {
            NotificationCenter.default.removeObserver(self, name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: icloudstore)
            icloudstore.removeObject(forKey: "dev"+deviceID+"lvl")
            icloudstore.removeObject(forKey: "dev"+deviceID+"wklvl")
            icloudstore.removeObject(forKey: "dev"+deviceID+"sv")
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
    
    func reportAchievements() {
        if (gameCenterState == .success || gameCenterState == .couldNotAuth) && prefersGameCenter {
            var achievementsToReport: [GKAchievement] = []
            for i in 0..<lvlachievement.count {
                let theAch=GKAchievement(identifier: "level"+String(lvlachievement[i].lvlReq))
                if levelInfo.lvl >= lvlachievement[i].lvlReq {
                    theAch.percentComplete=100
                } else {
                    if i != lvlachievement.count-1 {
                        theAch.percentComplete=Double(levelInfo.lvl)/Double(lvlachievement[i].lvlReq)*100
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
        
        curQ = .init(cs: [card(CardIcon: .club, numb: 1),card(CardIcon: .diamond, numb: 5),card(CardIcon: .heart, numb: 10),card(CardIcon: .spade, numb: 12)], sol: "", questionShown: Date(), questionSession: "initSession", ubound: -1)
        
        if isPreview {
            levelInfo=LevelInfo(lvl: 696, lvlName: "Mimi")
        } else {
            levelInfo=LevelInfo(lvl: 1, lvlName: nil)
        }
        curQuestionID=UUID()
        cardsClickable=true
        
        deviceID="empty"
        useHaptics=true
        synciCloud=true
        upperBound=13
        instantCompetitive=false
        showKeyboardTips=true
        useSplit=true
        prefersGameCenter=true
        gameCenterState = .unknown
        isShowingAnswer=false
        
        curQ.sol=solution(problemSet: [curQ.cs[0].numb,curQ.cs[1].numb,curQ.cs[2].numb,curQ.cs[3].numb]) ?? "No Solution"
        
        solengine=solverEngine(isPreview: false, tfEngine: nil)
        calcEngine=TFCalcEngine(isPreview: isPreview)
        
        solengine.tfengine=self
        calcEngine.tfengine=self
        
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
        if solengine.cards == nil {
            solengine.randomProblem(upperBound: upperBound)
        }
        saveData()
        
        setGCAuthHandler()
        
        updtLvlName()
        
        if savedVersion<currentVersion {
            savedVersion=currentVersion
            showWhatsNewView=true
            saveData()
        }
    }
    
    func setAccessPointVisible(visible: Bool) {
        GKAccessPoint.shared.isActive=visible && prefersGameCenter
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
        curQ.questionSession=currentSession
        curQ.questionShown=Date()
        curQ.ubound=upperBound
        nxtCards.res.data.deallocate()
    }
        
    var cardsClickable:Bool
    
    func refresh() {
        objectWillChange.send()
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
    
    let viewShowDelay = 0.12
    let viewShowOrder=[1,3,0,2]
    var inTransition=false
    
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
            curQ.questionSession="otherDevice"
        }

        reset()
        
        DispatchQueue.global().async {
            self.saveData()
        }
    }
    
    var konamiLog:[daBtn]=[]
    
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
    
    let speedAchievementsLockedThreshold=100
    
    func incrementLvl() {
        print("Increment Level")
        // check if rank has changed
        let lastRank = getQuestionLvlIndex(getLvl: levelInfo.lvl)
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
        let currentRank=getQuestionLvlIndex(getLvl: levelInfo.lvl)
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
        DispatchQueue.global().async {
            self.saveData()
        }
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
        currentSession=UUID().uuidString
        calcEngine.incorText=""
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
            calcEngine.expression=""
            // show the answer
            nxtState = .inTransition
            answerShowOpacity=0
            answerShow = curQ.sol
            isShowingAnswer=true
            DispatchQueue.global().async {
                self.saveData()
            }
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
