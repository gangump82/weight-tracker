<template>
  <view class="container">
    <!-- 打卡卡片 -->
    <view class="checkin-card">
      <view class="checkin-left">
        <text class="fire-emoji">🔥</text>
        <view class="streak-info">
          <text class="streak-count">{{ store.streakDays }}</text>
          <text class="streak-label">连续打卡</text>
        </view>
      </view>
      <button
        class="checkin-btn"
        :class="{ 'checked': store.isCheckedInToday }"
        @click="store.toggleCheckIn"
      >
        {{ store.isCheckedInToday ? '✅ 已打卡' : '📅 今日打卡' }}
      </button>
    </view>

    <!-- 统计卡片 -->
    <view class="stats-row">
      <view class="stat-card purple">
        <text class="stat-value">{{ store.currentWeight ? store.currentWeight.toFixed(1) + 'kg' : '--' }}</text>
        <text class="stat-label">当前体重</text>
      </view>
      <view class="stat-card green">
        <text class="stat-value">{{ store.userGoal.targetWeight ? store.userGoal.targetWeight.toFixed(1) + 'kg' : '--' }}</text>
        <text class="stat-label">目标体重</text>
      </view>
    </view>
    <view class="stats-row">
      <view class="stat-card blue">
        <text class="stat-value">{{ store.weightLost.toFixed(1) }}kg</text>
        <text class="stat-label">已减重</text>
      </view>
      <view class="stat-card orange">
        <text class="stat-value">{{ store.bmi ? store.bmi.toFixed(1) : '--' }}</text>
        <text class="stat-label">BMI</text>
      </view>
    </view>

    <!-- 记录按钮 -->
    <button class="add-btn" @click="showAddDialog = true">
      <text class="btn-icon">+</text>
      <text>记录体重</text>
    </button>

    <!-- 历史记录 -->
    <view class="history-card">
      <text class="history-title">📋 历史记录</text>
      <view v-if="store.weightRecords.length === 0" class="empty-text">
        <text>暂无记录</text>
      </view>
      <view v-else class="history-list">
        <view
          v-for="(record, index) in reversedRecords"
          :key="record.date"
          class="history-item"
        >
          <text class="record-weight">{{ record.weight.toFixed(1) }}kg</text>
          <text class="record-date">{{ record.date }}</text>
        </view>
      </view>
    </view>

    <!-- 添加弹窗 -->
    <view v-if="showAddDialog" class="modal-mask" @click="showAddDialog = false">
      <view class="modal-content" @click.stop>
        <text class="modal-title">记录体重</text>
        <view class="form-group">
          <text class="form-label">日期</text>
          <picker
            mode="date"
            :value="selectedDate"
            @change="onDateChange"
          >
            <view class="picker-value">{{ selectedDate }}</view>
          </picker>
        </view>
        <view class="form-group">
          <text class="form-label">体重 (kg)</text>
          <input
            type="digit"
            v-model="inputWeight"
            placeholder="请输入体重"
            class="form-input"
          />
        </view>
        <view class="modal-actions">
          <button class="cancel-btn" @click="showAddDialog = false">取消</button>
          <button class="confirm-btn" @click="saveWeight">保存</button>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import store, { formatDate } from '../../store/index'

const showAddDialog = ref(false)
const selectedDate = ref(formatDate(new Date()))
const inputWeight = ref('')

const reversedRecords = computed(() => {
  return [...store.weightRecords].reverse().slice(0, 10)
})

function onDateChange(e: any) {
  selectedDate.value = e.detail.value
}

function saveWeight() {
  const weight = parseFloat(inputWeight.value)
  if (weight > 0) {
    store.addWeightRecord(selectedDate.value, weight)
    showAddDialog.value = false
    inputWeight.value = ''
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

.checkin-card {
  background: linear-gradient(135deg, #8B5CF6 0%, #A78BFA 100%);
  border-radius: 20rpx;
  padding: 30rpx;
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20rpx;
}

.checkin-left {
  display: flex;
  align-items: center;
}

.fire-emoji {
  font-size: 60rpx;
  margin-right: 20rpx;
}

.streak-info {
  display: flex;
  flex-direction: column;
}

.streak-count {
  font-size: 48rpx;
  font-weight: bold;
  color: white;
}

.streak-label {
  font-size: 24rpx;
  color: rgba(255, 255, 255, 0.8);
}

.checkin-btn {
  background: white;
  color: #8B5CF6;
  border-radius: 30rpx;
  padding: 16rpx 32rpx;
  font-size: 26rpx;
  font-weight: bold;
  border: none;
}

.checkin-btn.checked {
  background: #10B981;
  color: white;
}

.stats-row {
  display: flex;
  gap: 16rpx;
  margin-bottom: 16rpx;
}

.stat-card {
  flex: 1;
  border-radius: 16rpx;
  padding: 24rpx;
  text-align: center;
}

.stat-card.purple { background: rgba(139, 92, 246, 0.1); }
.stat-card.green { background: rgba(16, 185, 129, 0.1); }
.stat-card.blue { background: rgba(59, 130, 246, 0.1); }
.stat-card.orange { background: rgba(249, 115, 22, 0.1); }

.stat-value {
  font-size: 36rpx;
  font-weight: bold;
  display: block;
}

.stat-card.purple .stat-value { color: #8B5CF6; }
.stat-card.green .stat-value { color: #10B981; }
.stat-card.blue .stat-value { color: #3B82F6; }
.stat-card.orange .stat-value { color: #F97316; }

.stat-label {
  font-size: 24rpx;
  color: #999;
  display: block;
  margin-top: 8rpx;
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
  justify-content: space-between;
  padding: 20rpx 0;
  border-bottom: 1rpx solid #f0f0f0;
}

.history-item:last-child {
  border-bottom: none;
}

.record-weight {
  font-size: 30rpx;
  color: #333;
}

.record-date {
  font-size: 26rpx;
  color: #999;
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
  width: 80%;
  background: white;
  border-radius: 20rpx;
  padding: 40rpx;
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
