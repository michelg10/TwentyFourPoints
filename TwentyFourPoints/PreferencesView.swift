//
//  PreferencesView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/3/6.
//

import SwiftUI

struct PreferencesView: View {
    @ObservedObject var tfengine: TFEngine
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    tfengine.hapticGate(hap: .medium)
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    ZStack {
                        Circle()
                            .foregroundColor(.white)
                            .colorMultiply(Color.init("ButtonColorActive"))
                            .frame(width:45,height:45)
                        Image(systemName: "chevron.down")
                            .foregroundColor(.white)
                            .colorMultiply(.init("TextColor"))
                            .font(.system(size:22,weight: .medium))
                            .padding(.top,3)
                    }.padding(.horizontal,20)
                }).buttonStyle(topBarButtonStyle())
                Spacer()
            }.padding(.top,20)
            Text("Preferences")
                .font(.system(size: 36, weight: .semibold, design: .rounded))
                .padding(.top, 13)
                .padding(.bottom,17)
            List {
                Toggle(isOn: Binding(get: {
                    tfengine.useHaptics
                }, set: { (val) in
                    tfengine.useHaptics=val
                    tfengine.saveData()
                }), label: {
                    Text("Haptics")
                })
                Toggle(isOn: Binding(get: {
                    !tfengine.ultraCompetitive
                }, set: { (val) in
                    tfengine.ultraCompetitive = !val
                    tfengine.saveData()
                }), label: {
                    Text("Animate number presses")
                })
                Toggle(isOn: Binding(get: {
                    tfengine.synciCloud
                }, set: { (val) in
                    tfengine.setiCloudSync(val: val)
                }), label: {
                    Text("iCloud sync")
                })
                VStack(alignment: .leading) {
                    HStack {
                        Text("Problem Range")
                        Spacer()
                        Text("1 ... \(String(tfengine.upperBound))")
                    }
                    Picker(selection: Binding(get: {
                        tfengine.upperBound
                    }, set: { (val) in
                        tfengine.upperBound=val
                        tfengine.saveData()
                    }), label: Text("Number Range").foregroundColor(.init("TextColor")), content: {
                        ForEach((8...24), id:\.self) { index in
                            Text("\(String(index))").tag(index)
                        }
                    }).pickerStyle(InlinePickerStyle())
                }
            }
        }
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView(tfengine: TFEngine(isPreview: true))
    }
}
