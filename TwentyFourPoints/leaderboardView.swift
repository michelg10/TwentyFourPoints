//
//  leaderboardView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/3/20.
//

import SwiftUI

struct leaderboardView: View {
    var tfengine: TFEngine
    @State var leaderboardFocus: LeaderboardFocus = .topPlayers
    @State var leaderboardScope: LeaderboardScope = .global
    @State var leaderboardTimeframe: LeaderboardTimeframe = .allTime
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    var body: some View {
        VStack(spacing:0) {
            HStack {
                Button(action: {
                    tfengine.hapticGate(hap: .medium)
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    ZStack {
                        Circle()
                            .foregroundColor(.init("ButtonColorActive"))
                            .frame(width:horizontalSizeClass == .regular ? 55 : 45,height:horizontalSizeClass == .regular ? 65 : 45)
                        Image(systemName: "chevron.down")
                            .foregroundColor(.init("TextColor"))
                            .font(.system(size: horizontalSizeClass == .regular ? 27 : 22,weight: .medium))
                            .padding(.top,horizontalSizeClass == .regular ? 3 : 4)
                    }.padding(.horizontal,20)
                }).buttonStyle(topBarButtonStyle())
                .hoverEffect(.lift)
                Spacer()
            }.padding(.top,20)
            .padding(.bottom,18)
            Text("Leaderboards")
                .font(.system(size: 36, weight: .semibold, design: .rounded))
                .padding(.bottom,10)
            Picker(selection: Binding(get: {
                leaderboardTimeframe
            }, set: { (val) in
                tfengine.hapticGate(hap: .light)
                leaderboardTimeframe = val
            }), label: Text(""), content: {
                Text("All Time").tag(LeaderboardTimeframe.allTime)
                Text("This Week").tag(LeaderboardTimeframe.thisWeek)
            }).pickerStyle(SegmentedPickerStyle())
            .frame(width:250)
            .padding(.bottom,37)
            Text("You are in the top 1%")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .padding(.horizontal,50)
                .multilineTextAlignment(.center)
                .padding(.bottom,2)
            Text("Rank 1 in 24 players")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .padding(.horizontal,40)
                .multilineTextAlignment(.center)
                .padding(.bottom,37)
            VStack(spacing:0) {
                ZStack {
                    Rectangle()
                        .frame(height:39)
                        .foregroundColor(.init("LeaderboardFloat"))
                    HStack {
                        Picker(selection: Binding(get: {
                            leaderboardFocus
                        }, set: { (val) in
                            leaderboardFocus=val
                            tfengine.hapticGate(hap: .light)
                        }), label:
                                HStack(spacing:4) {
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 15, weight: .medium, design: .rounded))
                                    Text(leaderboardFocus == .topPlayers ? "Top Players" : "My Rank")
                                        .font(.system(size: 17, weight: .medium, design: .rounded))
                                }.foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                               , content: {
                            Text("Top Players").tag(LeaderboardFocus.topPlayers)
                            Text("My Rank").tag(LeaderboardFocus.me)
                        }).pickerStyle(MenuPickerStyle())
                        Picker(selection: Binding(get: {
                            leaderboardScope
                        }, set: { (val) in
                            leaderboardScope=val
                            tfengine.hapticGate(hap: .light)
                        }), label:
                                HStack(spacing:4) {
                                    Text(leaderboardScope == .global ? "Global" : "Friends")
                                        .font(.system(size: 17, weight: .medium, design: .rounded))
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 15, weight: .medium, design: .rounded))
                                }.foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                               , content: {
                            Text("Global").tag(LeaderboardScope.global)
                            Text("Friends").tag(LeaderboardScope.friends)
                        }).pickerStyle(MenuPickerStyle())
                    }.padding(.horizontal,15)
                }
                ScrollView {
                    Text("Testing scrollview")
                    ForEach((0..<100), id:\.self) { index in
                        HStack {
                            Text(String(index))
                            Spacer()
                        }
                    }
                }
            }.background(Color.init("LeaderboardBg"))
            .cornerRadius(11,antialiased: true)
            .padding(.horizontal,15)
            .padding(.bottom,10)
        }
    }
}

struct leaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        leaderboardView(tfengine: TFEngine(isPreview: true))
    }
}
