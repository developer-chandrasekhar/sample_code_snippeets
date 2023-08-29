//
//  ContentView.swift
//  TextFiledIntrospect
//
//  Created by Chandra Sekhar P V on 29/08/23.
//

import SwiftUI
import SwiftUIIntrospect

public protocol FocusableTextFiled {}


struct ContentView: View {
    
    @State var userName: String = ""
    @State var isFocusableFiled: Bool = false
    var body: some View {
        VStack {
            TextField("", text: $userName)
                .focusTextFiled($isFocusableFiled)
                .background(Color.red)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.all)
                .border(Color(UIColor.separator))
                .padding(.leading)
                .padding(.trailing)
                .font(Font.system(size: 50))
                .keyboardType(.numberPad)
            
        }.onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                isFocusableFiled = true
            })
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

public extension TextField {
    func focusTextFiled(_ isFocusableField: Binding<Bool>) -> some View {
        modifier(FocusModifier<Any>(isFocusableField: isFocusableField))
    }
}

public struct FocusModifier<TextField>: ViewModifier {
    
    @State var observer = TextFieldObserver()
    @Binding var isFocusableField: Bool

    public func body(content: Content) -> some View {
        content.introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { tf in
            if isFocusableField {
                DispatchQueue.main.async {
                    tf.becomeFirstResponder()
                }
            }
        }
    }
}

class TextFieldObserver: NSObject, UITextFieldDelegate {
    var onReturnTap: () -> () = {}
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onReturnTap()
        return false
    }
}
