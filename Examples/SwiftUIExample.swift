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

// MARK: - 基础使用示例

/// 最简单的使用方式
@available(iOS 13.0, *)
struct BasicExample: View {
    @State private var duration: TimeInterval = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("选择时长")
                .font(.headline)
            
            DurationPickerView(duration: $duration)
            
            Text("已选择: \(formatDuration(duration))")
                .font(.title2)
        }
        .padding()
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

// MARK: - 不同模式示例

/// 展示不同的选择器模式
@available(iOS 13.0, *)
struct ModesExample: View {
    @State private var hourOnly: TimeInterval = 3600
    @State private var hourMinute: TimeInterval = 5400
    @State private var hourMinuteSecond: TimeInterval = 5445
    @State private var minuteOnly: TimeInterval = 300
    @State private var minuteSecond: TimeInterval = 345
    @State private var secondOnly: TimeInterval = 45
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("仅小时")) {
                    DurationPickerView(
                        duration: $hourOnly,
                        pickerMode: .hour
                    )
                    Text("\(Int(hourOnly / 3600)) 小时")
                }
                
                Section(header: Text("小时和分钟")) {
                    DurationPickerView(
                        duration: $hourMinute,
                        pickerMode: .hourMinute
                    )
                    Text("\(Int(hourMinute / 3600)) 小时 \(Int(hourMinute.truncatingRemainder(dividingBy: 3600) / 60)) 分钟")
                }
                
                Section(header: Text("小时、分钟和秒")) {
                    DurationPickerView(
                        duration: $hourMinuteSecond,
                        pickerMode: .hourMinuteSecond
                    )
                    Text(formatTime(hourMinuteSecond))
                }
                
                Section(header: Text("仅分钟")) {
                    DurationPickerView(
                        duration: $minuteOnly,
                        pickerMode: .minute
                    )
                    Text("\(Int(minuteOnly / 60)) 分钟")
                }
                
                Section(header: Text("分钟和秒")) {
                    DurationPickerView(
                        duration: $minuteSecond,
                        pickerMode: .minuteSecond
                    )
                    Text("\(Int(minuteSecond / 60)) 分钟 \(Int(minuteSecond.truncatingRemainder(dividingBy: 60))) 秒")
                }
                
                Section(header: Text("仅秒")) {
                    DurationPickerView(
                        duration: $secondOnly,
                        pickerMode: .second
                    )
                    Text("\(Int(secondOnly)) 秒")
                }
            }
            .navigationTitle("选择器模式")
        }
    }
    
    private func formatTime(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d 小时 %d 分钟 %d 秒", hours, minutes, seconds)
    }
}

// MARK: - 带约束的示例

/// 展示如何设置最小值、最大值和间隔
@available(iOS 13.0, *)
struct ConstraintsExample: View {
    @State private var workoutDuration: TimeInterval = 1800 // 30 分钟
    @State private var breakDuration: TimeInterval = 300 // 5 分钟
    
    var body: some View {
        VStack(spacing: 30) {
            // 锻炼时长：15分钟到2小时，5分钟间隔
            VStack(alignment: .leading, spacing: 10) {
                Text("锻炼时长")
                    .font(.headline)
                Text("最小: 15分钟 | 最大: 2小时 | 间隔: 5分钟")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                DurationPickerView(
                    duration: $workoutDuration,
                    pickerMode: .hourMinute
                )
                .minimumDuration(900) // 15 分钟
                .maximumDuration(7200) // 2 小时
                .minuteInterval(5)
                
                Text("已选择: \(Int(workoutDuration / 60)) 分钟")
                    .font(.title3)
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
            
            // 休息时长：1分钟到10分钟，30秒间隔
            VStack(alignment: .leading, spacing: 10) {
                Text("休息时长")
                    .font(.headline)
                Text("最小: 1分钟 | 最大: 10分钟 | 间隔: 30秒")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                DurationPickerView(
                    duration: $breakDuration,
                    pickerMode: .minuteSecond
                )
                .minimumDuration(60) // 1 分钟
                .maximumDuration(600) // 10 分钟
                .secondInterval(30)
                
                Text("已选择: \(Int(breakDuration / 60)) 分 \(Int(breakDuration.truncatingRemainder(dividingBy: 60))) 秒")
                    .font(.title3)
            }
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .navigationTitle("带约束的选择器")
    }
}

// MARK: - 实际应用示例：倒计时定时器

/// 一个使用 DurationPickerView 的实际应用示例
@available(iOS 14.0, *)
struct CountdownTimerExample: View {
    @State private var selectedDuration: TimeInterval = 300 // 5 分钟
    @State private var remainingTime: TimeInterval = 0
    @State private var isRunning = false
    @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing: 30) {
            Text("倒计时定时器")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if !isRunning {
                // 选择时长
                VStack(spacing: 15) {
                    Text("设置时长")
                        .font(.headline)
                    
                    DurationPickerView(
                        duration: $selectedDuration,
                        pickerMode: .hourMinuteSecond
                    )
                    .minimumDuration(1)
                    .maximumDuration(86399) // 23:59:59
                }
                
                Button(action: startTimer) {
                    Label("开始", systemImage: "play.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .disabled(selectedDuration == 0)
            } else {
                // 显示倒计时
                VStack(spacing: 20) {
                    Text(formatTime(remainingTime))
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .monospacedDigit()
                    
                    ProgressView(value: remainingTime, total: selectedDuration)
                        .progressViewStyle(LinearProgressViewStyle())
                        .scaleEffect(x: 1, y: 4, anchor: .center)
                    
                    HStack(spacing: 20) {
                        Button(action: stopTimer) {
                            Label("停止", systemImage: "stop.fill")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        
                        Button(action: resetTimer) {
                            Label("重置", systemImage: "arrow.counterclockwise")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.orange)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    private func startTimer() {
        remainingTime = selectedDuration
        isRunning = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                stopTimer()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }
    
    private func resetTimer() {
        stopTimer()
        remainingTime = 0
    }
}

// MARK: - 预览

#if DEBUG
@available(iOS 14.0, *)
struct SwiftUIExamples_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BasicExample()
                .previewDisplayName("基础示例")
            
            ModesExample()
                .previewDisplayName("模式示例")
            
            ConstraintsExample()
                .previewDisplayName("约束示例")
            
            CountdownTimerExample()
                .previewDisplayName("倒计时定时器")
        }
    }
}
#endif

