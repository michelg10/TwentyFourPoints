//
//  konamiView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/23.
//

import SwiftUI

struct konamiButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .animation(springAnimation)
            .saturation(configuration.isPressed ? 0.95 : 1)
            .brightness(configuration.isPressed ? 0.03 : 0) //0.05
            .animation(.easeInOut(duration: 0.07), value: configuration.isPressed)
    }
}

struct konamiTextView: UIViewRepresentable {
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
        func textFieldDidBeginEditing(_ textField: UITextField) {
            
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            
            return true
        }
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            
            return true
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        print("View update")
        uiView.text = text
        let roundedFont=UIFont.systemFont(ofSize: textSize, weight: .medium)
        uiView.font=UIFont(descriptor: roundedFont.fontDescriptor.withDesign(.rounded)!, size: textSize)
    }
    
    @Binding var text: String
    var textSize: CGFloat
    
    func makeUIView(context: Context) -> UITextField {
        let rturn=UITextField()
        rturn.keyboardType = .numbersAndPunctuation
        rturn.text=text
        let roundedFont=UIFont.systemFont(ofSize: textSize, weight: .medium)
        rturn.font=UIFont(descriptor: roundedFont.fontDescriptor.withDesign(.rounded)!, size: textSize)
        
        rturn.translatesAutoresizingMaskIntoConstraints=false
        rturn.textAlignment = .center
        rturn.placeholder = NSLocalizedString("konamiPlaceholder", comment: "Level")
        rturn.delegate=context.coordinator
        return rturn
    }
}

class konamiKaren: ObservableObject {
    @Published var level: Int
    
    init() {
        level=1
    }
    
    func set(val: String) {
        let cleaned=val.filter("0123456789".contains)
        level=Int(cleaned) ?? 0
        print("Level set to \(level)")
        objectWillChange.send()
    }
}

struct konamiView: View {
    var tfengine:TFEngine
    @ObservedObject var karen: konamiKaren
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text(NSLocalizedString("konamiString", comment: "I solemnly swear that I am up to no good"))
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(.bottom,15)
            HStack(spacing:14) {
                konamiTextView(text: Binding(get: {
                    String(karen.level)
                }, set: { (val) in
                    print("Set")
                    karen.set(val: val)
                }), textSize: 18)
                    .fixedSize(horizontal: true, vertical: true)
                    .padding(3)
                    .padding(.horizontal,15)
                    .frame(maxWidth:350)
                    .background(
                        RoundedRectangle(cornerRadius: .greatestFiniteMagnitude)
                            .frame(height: 42, alignment: .center)
                            .foregroundColor(.init("ButtonColorActive"))
                    )
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    tfengine.konamiLvl(setLvl: karen.level)
                    print("Setting \(karen.level)")
                    tfengine.hapticGate(hap: .medium)
                }, label: {
                    Circle()
                        .frame(width:42,height:42)
                        .foregroundColor(.init("ButtonColorActive"))
                        .overlay(
                            Image(systemName: "checkmark")
                                .foregroundColor(.primary)
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                        )
                })
                .buttonStyle(konamiButtonStyle())
            }.padding(.horizontal,30)
            Spacer()
            if tfengine.konamiLimitation() != 1 {
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    tfengine.softStorageReset()
                    tfengine.hapticGate(hap: .medium)
                }, label: {
                    ZStack {
                        Circle()
                            .foregroundColor(.init("ButtonColorActive"))
                            .frame(width:45,height:45)
                        Image(systemName: "arrow.clockwise")
                            .padding(.bottom,4)
                            .foregroundColor(.primary)
                            .font(.system(size:22,weight: .medium))
                    }.padding(.horizontal,20)
                }).buttonStyle(konamiButtonStyle())

                Text(NSLocalizedString("CloudSyncKonamiLimitationPrefix",comment: "")+String(tfengine.konamiLimitation())+NSLocalizedString("CloudSyncKonamiLimitationPostfix", comment: ""))
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }.padding(.horizontal,40)
        .onAppear {
            karen.level=tfengine.levelInfo.lvl
        }
    }
}

struct konamiView_Previews: PreviewProvider {
    static var previews: some View {
        konamiView(tfengine: TFEngine(isPreview: true), karen: konamiKaren())
    }
}
