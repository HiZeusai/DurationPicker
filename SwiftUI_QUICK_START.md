# DurationPicker SwiftUI 快速入门指南

## 简介

`DurationPickerView` 是 `DurationPicker` 的 SwiftUI 包装器，提供了原生的 SwiftUI 接口来选择时间间隔（0到24小时）。

## 基础使用

### 1. 最简单的例子

```swift
import SwiftUI
import DurationPicker

struct ContentView: View {
    @State private var duration: TimeInterval = 0
    
    var body: some View {
        VStack {
            Text("选择时长")
            DurationPickerView(duration: $duration)
            Text("已选择: \(Int(duration)) 秒")
        }
    }
}
```

### 2. 指定选择器模式

```swift
// 仅选择小时和分钟
DurationPickerView(
    duration: $duration,
    pickerMode: .hourMinute
)

// 可用的模式：
// .hour              - 仅小时
// .hourMinute        - 小时和分钟
// .hourMinuteSecond  - 小时、分钟和秒（默认）
// .minute            - 仅分钟
// .minuteSecond      - 分钟和秒
// .second            - 仅秒
```

### 3. 使用修饰符配置

```swift
DurationPickerView(duration: $duration)
    .durationPickerMode(.hourMinute)           // 设置模式
    .minimumDuration(300)                      // 最小时长：5分钟
    .maximumDuration(7200)                     // 最大时长：2小时
    .minuteInterval(5)                         // 分钟间隔：5分钟
```

## 完整示例

### 示例 1：锻炼计时器

```swift
struct WorkoutTimerView: View {
    @State private var workoutDuration: TimeInterval = 1800 // 30分钟
    
    var body: some View {
        VStack(spacing: 20) {
            Text("设置锻炼时长")
                .font(.headline)
            
            DurationPickerView(
                duration: $workoutDuration,
                pickerMode: .hourMinute
            )
            .minimumDuration(15 * 60)      // 最少15分钟
            .maximumDuration(2 * 3600)     // 最多2小时
            .minuteInterval(5)              // 5分钟间隔
            
            Text("锻炼时长: \(formatDuration(workoutDuration))")
                .font(.title2)
        }
        .padding()
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        
        if hours > 0 {
            return "\(hours) 小时 \(minutes) 分钟"
        } else {
            return "\(minutes) 分钟"
        }
    }
}
```

### 示例 2：倒计时定时器

```swift
struct CountdownView: View {
    @State private var selectedDuration: TimeInterval = 300
    @State private var isTimerRunning = false
    
    var body: some View {
        VStack(spacing: 30) {
            if !isTimerRunning {
                DurationPickerView(
                    duration: $selectedDuration,
                    pickerMode: .minuteSecond
                )
                .minimumDuration(1)
                
                Button("开始倒计时") {
                    startTimer()
                }
                .buttonStyle(.borderedProminent)
            } else {
                // 倒计时界面
                Text(formatTime(selectedDuration))
                    .font(.system(size: 60, weight: .bold))
                
                Button("停止") {
                    stopTimer()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func startTimer() {
        isTimerRunning = true
        // 实现定时器逻辑
    }
    
    private func stopTimer() {
        isTimerRunning = false
    }
}
```

### 示例 3：多个选择器

```swift
struct MultiplePickersView: View {
    @State private var cookingTime: TimeInterval = 900      // 15分钟
    @State private var restTime: TimeInterval = 300         // 5分钟
    @State private var totalTime: TimeInterval = 3600       // 1小时
    
    var body: some View {
        Form {
            Section(header: Text("烹饪时间")) {
                DurationPickerView(
                    duration: $cookingTime,
                    pickerMode: .minuteSecond
                )
                .minimumDuration(60)
                .maximumDuration(3600)
            }
            
            Section(header: Text("休息时间")) {
                DurationPickerView(
                    duration: $restTime,
                    pickerMode: .minute
                )
                .minimumDuration(60)
                .maximumDuration(1800)
                .minuteInterval(5)
            }
            
            Section(header: Text("总时长")) {
                DurationPickerView(
                    duration: $totalTime,
                    pickerMode: .hourMinute
                )
            }
            
            Section {
                Text("烹饪: \(Int(cookingTime/60)) 分钟")
                Text("休息: \(Int(restTime/60)) 分钟")
                Text("总计: \(Int(totalTime/3600)) 小时")
            }
        }
    }
}
```

## 所有可用的修饰符

### durationPickerMode(_:)
设置选择器的模式。

```swift
.durationPickerMode(.hourMinute)
```

### minimumDuration(_:)
设置最小可选时长（秒）。

```swift
.minimumDuration(300)  // 5分钟
```

### maximumDuration(_:)
设置最大可选时长（秒）。

```swift
.maximumDuration(3600)  // 1小时
```

### hourInterval(_:)
设置小时的间隔。必须能被24整除。

```swift
.hourInterval(2)  // 每次增加2小时
```

### minuteInterval(_:)
设置分钟的间隔。必须能被60整除。

```swift
.minuteInterval(5)  // 每次增加5分钟
```

### secondInterval(_:)
设置秒的间隔。必须能被60整除。

```swift
.secondInterval(15)  // 每次增加15秒
```

## 注意事项

1. **时间单位**：`duration` 绑定使用 `TimeInterval`（即秒数），例如：
   - 1 分钟 = 60 秒
   - 1 小时 = 3600 秒
   - 1 小时 30 分钟 = 5400 秒

2. **间隔约束**：
   - 小时间隔必须能被 24 整除（1-12）
   - 分钟和秒间隔必须能被 60 整除（1-30）
   - 如果设置的间隔不符合要求，将使用默认值 1

3. **最小/最大值**：
   - 如果最小值大于最大值，两个约束都会被忽略
   - 确保在最小值和最大值之间至少有一个可选值

4. **iOS 版本要求**：
   - 最低支持 iOS 13.0+（SwiftUI）
   - UIKit 版本最低支持 iOS 15.0+

## 更多示例

查看 `Examples/SwiftUIExample.swift` 文件以获取更多详细示例，包括：
- 不同模式的使用
- 带约束的选择器
- 实际的倒计时定时器应用

## 与 UIKit 版本的比较

| UIKit | SwiftUI |
|-------|---------|
| `DurationPicker` | `DurationPickerView` |
| `picker.duration = 3600` | `@State var duration: TimeInterval = 3600` |
| `picker.pickerMode = .hourMinute` | `pickerMode: .hourMinute` 或 `.durationPickerMode(.hourMinute)` |
| `picker.minimumDuration = 300` | `.minimumDuration(300)` |
| `picker.addAction(...)` | 使用 `@State` 绑定自动更新 |

## 问题排查

### 选择器没有显示
- 确保已正确导入 `import DurationPicker`
- 检查 `duration` 绑定是否正确使用 `@State`

### 约束不生效
- 确保最小值小于等于最大值
- 检查间隔设置是否能被整除（小时/24，分钟和秒/60）

### 编译错误
- 确保你的项目支持 SwiftUI（iOS 13.0+）
- 检查是否正确安装了 DurationPicker 包

## 许可证

DurationPicker 使用 MIT 许可证。详见 [LICENSE](LICENSE) 文件。

