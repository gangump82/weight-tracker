<template>
  <view class="container">
    <!-- 综合统计 -->
    <view class="stats-card">
      <text class="card-title">📊 综合统计</text>
      <view class="stats-row">
        <view class="stat-item">
          <text class="stat-value purple">{{ store.weightRecords.length }}</text>
          <text class="stat-label">记录天数</text>
        </view>
        <view class="stat-item">
          <text class="stat-value green">{{ store.todayExerciseCalories }}</text>
          <text class="stat-label">今日消耗</text>
        </view>
        <view class="stat-item">
          <text class="stat-value orange">{{ store.todayDietCalories }}</text>
          <text class="stat-label">今日摄入</text>
        </view>
      </view>
    </view>

    <!-- 体重进度 -->
    <view class="progress-card">
      <text class="card-title">⚖️ 体重进度</text>
      <view v-if="hasGoal" class="progress-content">
        <view class="progress-bar">
          <view class="progress-fill" :style="{ width: progressPercent + '%' }"></view>
        </view>
        <view class="progress-labels">
          <text class="progress-label">起始: {{ store.startWeight?.toFixed(1) }}kg</text>
          <text class="progress-label">当前: {{ store.currentWeight?.toFixed(1) }}kg</text>
          <text class="progress-label">目标: {{ store.userGoal.targetWeight?.toFixed(1) }}kg</text>
        </view>
        <text class="progress-percent">完成度: {{ progressPercent }}%</text>
      </view>
      <view v-else class="no-goal">
        <text>请先设置目标体重</text>
      </view>
    </view>

    <!-- 热量平衡 -->
    <view class="balance-card">
      <text class="card-title">⚖️ 今日热量平衡</text>
      <view class="balance-row">
        <view class="balance-item">
          <text class="balance-value orange">{{ store.todayDietCalories }}</text>
          <text class="balance-label">摄入</text>
        </view>
        <text class="balance-operator">-</text>
        <view class="balance-item">
          <text class="balance-value green">{{ store.todayExerciseCalories }}</text>
          <text class="balance-label">消耗</text>
        </view>
        <text class="balance-operator">=</text>
        <view class="balance-item">
          <text class="balance-value" :class="netCaloriesColor">{{ netCalories }}</text>
          <text class="balance-label">净热量</text>
        </view>
      </view>
    </view>

    <!-- 设置目标 -->
    <view class="goal-card">
      <text class="card-title">🎯 目标设置</text>
      <view class="goal-form">
        <view class="goal-row">
          <text class="goal-label">目标体重 (kg)</text>
          <input
            type="digit"
            v-model="targetWeight"
            placeholder="请输入"
            class="goal-input"
          />
        </view>
        <view class="goal-row">
          <text class="goal-label">身高 (cm)</text>
          <input
            type="number"
            v-model="height"
            placeholder="请输入"
            class="goal-input"
          />
        </view>
        <button class="save-goal-btn" @click="saveGoal">保存目标</button>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import store from '../../store/index'

const targetWeight = ref(store.userGoal.targetWeight?.toString() || '')
const height = ref(store.userGoal.height?.toString() || '')

const hasGoal = computed(() => {
  return store.startWeight !== null &&
    store.userGoal.targetWeight !== undefined &&
    store.currentWeight !== null
})

const progressPercent = computed(() => {
  if (!hasGoal.value) return 0
  const totalToLose = store.startWeight! - store.userGoal.targetWeight!
  const lost = store.startWeight! - store.currentWeight!
  if (totalToLose <= 0) return 0
  return Math.min(100, Math.max(0, Math.round((lost / totalToLose) * 100)))
})

const netCalories = computed(() => {
  return store.todayDietCalories - store.todayExerciseCalories
})

const netCaloriesColor = computed(() => {
  return netCalories.value > 0 ? 'red' : 'blue'
})

function saveGoal() {
  const tw = parseFloat(targetWeight.value)
  const h = parseInt(height.value)

  if (tw > 0 || h > 0) {
    store.setUserGoal({
      targetWeight: tw > 0 ? tw : undefined,
      height: h > 0 ? h : undefined
    })
    uni.showToast({ title: '保存成功', icon: 'success' })
  }
}
</script>

<style scoped>
.container {
  padding: 20rpx;
  background-color: #F5F5F5;
  min-height: 100vh;
}

.stats-card,
.progress-card,
.balance-card,
.goal-card {
  background: white;
  border-radius: 16rpx;
  padding: 24rpx;
  margin-bottom: 20rpx;
}

.card-title {
  font-size: 32rpx;
  font-weight: bold;
  display: block;
  margin-bottom: 20rpx;
}

.stats-row {
  display: flex;
  justify-content: space-around;
}

.stat-item {
  text-align: center;
}

.stat-value {
  font-size: 40rpx;
  font-weight: bold;
  display: block;
}

.stat-value.purple { color: #8B5CF6; }
.stat-value.green { color: #10B981; }
.stat-value.orange { color: #F97316; }
.stat-value.red { color: #EF4444; }
.stat-value.blue { color: #3B82F6; }

.stat-label {
  font-size: 24rpx;
  color: #999;
}

.progress-content {
  display: flex;
  flex-direction: column;
}

.progress-bar {
  height: 16rpx;
  background: #e0e0e0;
  border-radius: 8rpx;
  overflow: hidden;
  margin-bottom: 16rpx;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #8B5CF6, #A78BFA);
  border-radius: 8rpx;
  transition: width 0.3s;
}

.progress-labels {
  display: flex;
  justify-content: space-between;
  margin-bottom: 16rpx;
}

.progress-label {
  font-size: 24rpx;
  color: #999;
}

.progress-percent {
  text-align: center;
  font-weight: bold;
  color: #8B5CF6;
  font-size: 30rpx;
}

.no-goal {
  text-align: center;
  padding: 40rpx;
  color: #999;
}

.balance-row {
  display: flex;
  justify-content: space-around;
  align-items: center;
}

.balance-item {
  text-align: center;
}

.balance-value {
  font-size: 44rpx;
  font-weight: bold;
  display: block;
}

.balance-label {
  font-size: 24rpx;
  color: #999;
}

.balance-operator {
  font-size: 36rpx;
  color: #333;
}

.goal-form {
  display: flex;
  flex-direction: column;
}

.goal-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20rpx;
}

.goal-label {
  font-size: 28rpx;
  color: #333;
}

.goal-input {
  width: 200rpx;
  height: 70rpx;
  border: 2rpx solid #e0e0e0;
  border-radius: 12rpx;
  padding: 0 20rpx;
  font-size: 28rpx;
  text-align: right;
}

.save-goal-btn {
  background: #8B5CF6;
  color: white;
  border-radius: 12rpx;
  border: none;
  padding: 20rpx;
  font-size: 28rpx;
  margin-top: 10rpx;
}
</style>
