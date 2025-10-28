/// MIT License
///
/// Copyright (c) 2023 Mac Gallagher
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

import SwiftUI

/// A SwiftUI view that wraps the `DurationPicker` UIKit control.
///
/// `DurationPickerView` provides a native SwiftUI interface for inputting time values
/// ranging between 0 and 24 hours. It serves as a SwiftUI wrapper around the UIKit
/// `DurationPicker` control.
///
/// ## Usage
///
/// ```swift
/// struct ContentView: View {
///     @State private var duration: TimeInterval = 3600 // 1 hour
///
///     var body: some View {
///         VStack {
///             DurationPickerView(
///                 duration: $duration,
///                 pickerMode: .hourMinuteSecond
///             )
///
///             Text("Selected: \(Int(duration)) seconds")
///         }
///     }
/// }
/// ```
///
/// ## Configuration
///
/// You can customize the picker by chaining view modifiers:
///
/// ```swift
/// DurationPickerView(duration: $duration)
///     .durationPickerMode(.hourMinute)
///     .minimumDuration(0)
///     .maximumDuration(7200) // 2 hours
///     .minuteInterval(5)
/// ```
///
/// ## Topics
///
/// ### Creating a Duration Picker
/// - ``init(duration:pickerMode:)``
///
/// ### Configuring the Picker
/// - ``durationPickerMode(_:)``
/// - ``minimumDuration(_:)``
/// - ``maximumDuration(_:)``
/// - ``hourInterval(_:)``
/// - ``minuteInterval(_:)``
/// - ``secondInterval(_:)``
@available(iOS 13.0, *)
public struct DurationPickerView: UIViewRepresentable {
    
    /// The binding to the selected duration in seconds.
    @Binding public var duration: TimeInterval
    
    /// The mode of the duration picker.
    public var pickerMode: DurationPicker.Mode
    
    /// The minimum duration that the picker can show (in seconds).
    public var minimumDuration: TimeInterval?
    
    /// The maximum duration that the picker can show (in seconds).
    public var maximumDuration: TimeInterval?
    
    /// The interval at which the duration picker should display hours.
    public var hourInterval: Int
    
    /// The interval at which the duration picker should display minutes.
    public var minuteInterval: Int
    
    /// The interval at which the duration picker should display seconds.
    public var secondInterval: Int
    
    /// Creates a new duration picker view.
    ///
    /// - Parameters:
    ///   - duration: A binding to the selected duration in seconds.
    ///   - pickerMode: The mode of the duration picker. Defaults to `.hourMinuteSecond`.
    public init(
        duration: Binding<TimeInterval>,
        pickerMode: DurationPicker.Mode = .hourMinuteSecond
    ) {
        self._duration = duration
        self.pickerMode = pickerMode
        self.minimumDuration = nil
        self.maximumDuration = nil
        self.hourInterval = 1
        self.minuteInterval = 1
        self.secondInterval = 1
    }
    
    public func makeUIView(context: Context) -> DurationPicker {
        let picker = DurationPicker()
        picker.pickerMode = pickerMode
        picker.duration = duration
        
        if let minimumDuration = minimumDuration {
            picker.minimumDuration = minimumDuration
        }
        if let maximumDuration = maximumDuration {
            picker.maximumDuration = maximumDuration
        }
        
        picker.hourInterval = hourInterval
        picker.minuteInterval = minuteInterval
        picker.secondInterval = secondInterval
        
        // Set up action handler
        picker.addAction(
            UIAction { [weak picker] _ in
                guard let picker = picker else { return }
                DispatchQueue.main.async {
                    duration = picker.duration
                }
            },
            for: .valueChanged
        )
        
        return picker
    }
    
    public func updateUIView(_ picker: DurationPicker, context: Context) {
        // Update picker mode if changed
        if picker.pickerMode != pickerMode {
            picker.pickerMode = pickerMode
        }
        
        // Update duration if changed (with a small tolerance to avoid floating point precision issues)
        if abs(picker.duration - duration) > 0.001 {
            picker.setDuration(duration, animated: false)
        }
        
        // Update minimum duration
        if picker.minimumDuration != minimumDuration {
            picker.minimumDuration = minimumDuration
        }
        
        // Update maximum duration
        if picker.maximumDuration != maximumDuration {
            picker.maximumDuration = maximumDuration
        }
        
        // Update intervals
        if picker.hourInterval != hourInterval {
            picker.hourInterval = hourInterval
        }
        if picker.minuteInterval != minuteInterval {
            picker.minuteInterval = minuteInterval
        }
        if picker.secondInterval != secondInterval {
            picker.secondInterval = secondInterval
        }
    }
}

// MARK: - View Modifiers

@available(iOS 13.0, *)
extension DurationPickerView {
    
    /// Sets the mode of the duration picker.
    ///
    /// - Parameter mode: The picker mode to display.
    /// - Returns: A modified duration picker view.
    public func durationPickerMode(_ mode: DurationPicker.Mode) -> DurationPickerView {
        var view = self
        view.pickerMode = mode
        return view
    }
    
    /// Sets the minimum duration that the picker can show.
    ///
    /// - Parameter duration: The minimum duration in seconds, or `nil` for no minimum.
    /// - Returns: A modified duration picker view.
    public func minimumDuration(_ duration: TimeInterval?) -> DurationPickerView {
        var view = self
        view.minimumDuration = duration
        return view
    }
    
    /// Sets the maximum duration that the picker can show.
    ///
    /// - Parameter duration: The maximum duration in seconds, or `nil` for no maximum.
    /// - Returns: A modified duration picker view.
    public func maximumDuration(_ duration: TimeInterval?) -> DurationPickerView {
        var view = self
        view.maximumDuration = duration
        return view
    }
    
    /// Sets the interval at which the duration picker should display hours.
    ///
    /// - Parameter interval: The hour interval. Must evenly divide into 24.
    /// - Returns: A modified duration picker view.
    public func hourInterval(_ interval: Int) -> DurationPickerView {
        var view = self
        view.hourInterval = interval
        return view
    }
    
    /// Sets the interval at which the duration picker should display minutes.
    ///
    /// - Parameter interval: The minute interval. Must evenly divide into 60.
    /// - Returns: A modified duration picker view.
    public func minuteInterval(_ interval: Int) -> DurationPickerView {
        var view = self
        view.minuteInterval = interval
        return view
    }
    
    /// Sets the interval at which the duration picker should display seconds.
    ///
    /// - Parameter interval: The second interval. Must evenly divide into 60.
    /// - Returns: A modified duration picker view.
    public func secondInterval(_ interval: Int) -> DurationPickerView {
        var view = self
        view.secondInterval = interval
        return view
    }
}

// MARK: - Preview Support

#if DEBUG
@available(iOS 13.0, *)
struct DurationPickerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Basic example
            StatefulPreviewWrapper(3600) { duration in
                VStack {
                    Text("Duration: \(Int(duration.wrappedValue)) seconds")
                        .padding()
                    DurationPickerView(duration: duration)
                }
            }
            .previewDisplayName("Hour Minute Second")
            
            // Hour minute mode
            StatefulPreviewWrapper(1800) { duration in
                VStack {
                    Text("Duration: \(Int(duration.wrappedValue)) seconds")
                        .padding()
                    DurationPickerView(
                        duration: duration,
                        pickerMode: .hourMinute
                    )
                }
            }
            .previewDisplayName("Hour Minute")
            
            // With constraints
            StatefulPreviewWrapper(900) { duration in
                VStack {
                    Text("Duration: \(Int(duration.wrappedValue)) seconds")
                        .padding()
                    DurationPickerView(duration: duration)
                        .minimumDuration(300)
                        .maximumDuration(3600)
                        .minuteInterval(5)
                }
            }
            .previewDisplayName("With Constraints")
        }
    }
}

@available(iOS 13.0, *)
private struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content
    
    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        self._value = State(initialValue: value)
        self.content = content
    }
    
    var body: some View {
        content($value)
    }
}
#endif

