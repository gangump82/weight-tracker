<template>
  <view class="container">
    <!-- 今日统计 -->
    <view class="today-card">
      <text class="today-title">🏃 今日运动</text>
      <text class="today-value">{{ store.todayExerciseCalories }}</text>
      <text class="today-label">消耗 kcal</text>
    </view>

    <!-- 记录按钮 -->
    <button class="add-btn" @click="openAddDialog">
      <text class="btn-icon">+</text>
      <text>记录运动</text>
    </button>

    <!-- 历史记录 -->
    <view class="history-card">
      <text class="history-title">📋 运动历史</text>
      <view v-if="store.exercises.length === 0" class="empty-text">
        <text>暂无运动记录</text>
      </view>
      <view v-else class="history-list">
        <view
          v-for="exercise in reversedExercises"
          :key="exercise.id"
          class="history-item"
        >
          <text class="exercise-icon">{{ exercise.typeIcon }}</text>
          <view class="exercise-info">
            <text class="exercise-name">{{ exercise.typeName }}</text>
            <text class="exercise-sub">{{ exercise.date }} · {{ exercise.duration }}分钟</text>
          </view>
          <text class="exercise-calories">{{ exercise.calories }} kcal</text>
        </view>
      </view>
    </view>

    <!-- 添加弹窗 -->
    <view v-if="showAddDialog" class="modal-mask" @click="showAddDialog = false">
      <view class="modal-content" @click.stop>
        <text class="modal-title">记录运动</text>

        <view class="form-group">
          <text class="form-label">日期</text>
          <picker mode="date" :value="selectedDate" @change="onDateChange">
            <view class="picker-value">{{ selectedDate }}</view>
          </picker>
        </view>

        <view class="form-group">
          <text class="form-label">运动类型</text>
          <view class="type-grid">
            <view
              v-for="type in exerciseTypes"
              :key="type.value"
              class="type-item"
              :class="{ 'selected': selectedType === type.value }"
              @click="selectedType = type.value"
            >
              <text>{{ type.label }}</text>
            </view>
          </view>
        </view>

        <view class="form-group">
          <text class="form-label">运动时长 (分钟)</text>
          <input
            type="number"
            v-model="inputDuration"
            placeholder="请输入时长"
            class="form-input"
          />
        </view>

        <view v-if="calculatedCalories > 0" class="calories-preview">
          <text>预计消耗: {{ calculatedCalories }} kcal</text>
        </view>

        <view class="modal-actions">
          <button class="cancel-btn" @click="showAddDialog = false">取消</button>
          <button class="confirm-btn" @click="saveExercise">保存</button>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import store, { formatDate } from '../../store/index'

const exerciseTypes = [
  { value: 'running', label: '跑步 🏃', caloriesPerMin: 10 },
  { value: 'swimming', label: '游泳 🏊', caloriesPerMin: 8 },
  { value: 'cycling', label: '骑行 🚴', caloriesPerMin: 7 },
  { value: 'gym', label: '健身 🏋️', caloriesPerMin: 6 },
  { value: 'yoga', label: '瑜伽 🧘', caloriesPerMin: 3 },
  { value: 'walking', label: '步行 🚶', caloriesPerMin: 4 },
  { value: 'jumping', label: '跳绳 ⏫', caloriesPerMin: 12 },
  { value: 'hiit', label: 'HIIT ⚡', caloriesPerMin: 14 },
]

const showAddDialog = ref(false)
const selectedDate = ref(formatDate(new Date()))
const selectedType = ref('running')
const inputDuration = ref('')

const reversedExercises = computed(() => {
  return [...store.exercises].reverse().slice(0, 20)
})

const calculatedCalories = computed(() => {
  const duration = parseInt(inputDuration.value) || 0
  const type = exerciseTypes.find(t => t.value === selectedType.value)
  return duration * (type?.caloriesPerMin || 0)
})

function onDateChange(e: any) {
  selectedDate.value = e.detail.value
}

function openAddDialog() {
  selectedDate.value = formatDate(new Date())
  selectedType.value = 'running'
  inputDuration.value = ''
  showAddDialog.value = true
}

function saveExercise() {
  const duration = parseInt(inputDuration.value) || 0
  if (duration > 0) {
    const type = exerciseTypes.find(t => t.value === selectedType.value)!
    const [typeName, typeIcon] = type.label.split(' ')
    store.addExercise({
      date: selectedDate.value,
      type: selectedType.value,
      typeName,
      typeIcon,
      duration,
      calories: calculatedCalories.value
    })
    showAddDialog.value = false
    uni.showToast({ title: '记录成功', icon: 'success' })
  }
}
</script>

<style scoped>
.container {
  padding: 20rpx;
  background-color: #F5F5F5;
  min-height: 100vh;
}

.today-card {
  background: rgba(16, 185, 129, 0.1);
  border-radius: 20rpx;
  padding: 40rpx;
  text-align: center;
  margin-bottom: 20rpx;
}

.today-title {
  font-weight: bold;
  font-size: 28rpx;
  display: block;
  margin-bottom: 16rpx;
}

.today-value {
  font-size: 72rpx;
  font-weight: bold;
  color: #10B981;
  display: block;
}

.today-label {
  font-size: 24rpx;
  color: #666;
  display: block;
}

.add-btn {
  width: 100%;
  background: #8B5CF6;
  color: white;
  border-radius: 16rpx;
  padding: 24rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 30rpx;
  font-weight: bold;
  border: none;
  margin-bottom: 20rpx;
}

.btn-icon {
  margin-right: 10rpx;
  font-size: 36rpx;
}

.history-card {
  background: white;
  border-radius: 16rpx;
  padding: 24rpx;
}

.history-title {
  font-weight: bold;
  font-size: 30rpx;
  display: block;
  margin-bottom: 16rpx;
}

.empty-text {
  text-align: center;
  padding: 40rpx;
  color: #999;
}

.history-list {
  display: flex;
  flex-direction: column;
}

.history-item {
  display: flex;
  align-items: center;
  padding: 20rpx 0;
  border-bottom: 1rpx solid #f0f0f0;
}

.history-item:last-child {
  border-bottom: none;
}

.exercise-icon {
  font-size: 40rpx;
  margin-right: 16rpx;
}

.exercise-info {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.exercise-name {
  font-size: 28rpx;
  color: #333;
}

.exercise-sub {
  font-size: 24rpx;
  color: #999;
}

.exercise-calories {
  font-weight: bold;
  color: #F97316;
  font-size: 28rpx;
}

/* 弹窗样式 */
.modal-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 999;
}

.modal-content {
  width: 85%;
  max-height: 80vh;
  background: white;
  border-radius: 20rpx;
  padding: 40rpx;
  overflow-y: auto;
}

.modal-title {
  font-size: 34rpx;
  font-weight: bold;
  display: block;
  text-align: center;
  margin-bottom: 30rpx;
}

.form-group {
  margin-bottom: 24rpx;
}

.form-label {
  font-size: 28rpx;
  color: #666;
  display: block;
  margin-bottom: 12rpx;
}

.form-input {
  width: 100%;
  height: 80rpx;
  border: 2rpx solid #e0e0e0;
  border-radius: 12rpx;
  padding: 0 20rpx;
  font-size: 28rpx;
  box-sizing: border-box;
}

.picker-value {
  height: 80rpx;
  line-height: 80rpx;
  border: 2rpx solid #e0e0e0;
  border-radius: 12rpx;
  padding: 0 20rpx;
  font-size: 28rpx;
}

.type-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 12rpx;
}

.type-item {
  padding: 16rpx 24rpx;
  border-radius: 12rpx;
  background: #f5f5f5;
  font-size: 26rpx;
}

.type-item.selected {
  background: #8B5CF6;
  color: white;
}

.calories-preview {
  text-align: center;
  padding: 16rpx;
  background: #f0f9ff;
  border-radius: 12rpx;
  color: #3B82F6;
  margin-bottom: 20rpx;
}

.modal-actions {
  display: flex;
  gap: 20rpx;
  margin-top: 30rpx;
}

.cancel-btn {
  flex: 1;
  background: #f0f0f0;
  color: #666;
  border-radius: 12rpx;
  border: none;
  padding: 20rpx;
}

.confirm-btn {
  flex: 1;
  background: #8B5CF6;
  color: white;
  border-radius: 12rpx;
  border: none;
  padding: 20rpx;
}
</style>
