<template>
  <view class="container">
    <!-- 头部卡片 -->
    <view class="header-card">
      <text class="header-title">👨‍⚕️ 顶级营养师</text>
      <text class="header-sub">为您量身定制一周营养食谱</text>
    </view>

    <!-- 生成按钮 -->
    <button class="generate-btn" @click="store.generateMealPlans()">
      <text>🧬 生成专属食谱</text>
    </button>

    <!-- 食谱展示 -->
    <view v-if="store.mealPlans.length > 0" class="meal-plans">
      <!-- 日期选择器 -->
      <scroll-view scroll-x class="day-selector">
        <view
          v-for="(day, index) in days"
          :key="index"
          class="day-item"
          :class="{ 'selected': selectedDay === index }"
          @click="selectedDay = index"
        >
          <text>{{ day }}</text>
        </view>
      </scroll-view>

      <!-- 当日食谱 -->
      <view v-if="currentPlan" class="plan-card">
        <view class="meal-row">
          <view class="meal-info">
            <text class="meal-name">🌅 早餐</text>
            <text class="meal-food">{{ currentPlan.breakfast.name }}</text>
          </view>
          <text class="meal-calories">{{ currentPlan.breakfast.calories }} kcal</text>
        </view>

        <view class="meal-row">
          <view class="meal-info">
            <text class="meal-name">☀️ 午餐</text>
            <text class="meal-food">{{ currentPlan.lunch.name }}</text>
          </view>
          <text class="meal-calories">{{ currentPlan.lunch.calories }} kcal</text>
        </view>

        <view class="meal-row">
          <view class="meal-info">
            <text class="meal-name">🌙 晚餐</text>
            <text class="meal-food">{{ currentPlan.dinner.name }}</text>
          </view>
          <text class="meal-calories">{{ currentPlan.dinner.calories }} kcal</text>
        </view>

        <view class="meal-row">
          <view class="meal-info">
            <text class="meal-name">🍎 加餐</text>
            <text class="meal-food">{{ currentPlan.snack.name }}</text>
          </view>
          <text class="meal-calories">{{ currentPlan.snack.calories }} kcal</text>
        </view>

        <view class="total-row">
          <text class="total-text">当日总计: {{ currentPlan.totalCalories }} kcal</text>
        </view>
      </view>
    </view>

    <view v-else class="empty-state">
      <text class="empty-icon">🍽️</text>
      <text class="empty-text">点击上方按钮生成专属食谱</text>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import store from '../../store/index'

const days = ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
const selectedDay = ref(0)

const currentPlan = computed(() => {
  if (store.mealPlans.length > selectedDay.value) {
    return store.mealPlans[selectedDay.value]
  }
  return null
})
</script>

<style scoped>
.container {
  padding: 20rpx;
  background-color: #F5F5F5;
  min-height: 100vh;
}

.header-card {
  background: rgba(16, 185, 129, 0.1);
  border-radius: 20rpx;
  padding: 30rpx;
  margin-bottom: 20rpx;
}

.header-title {
  font-size: 36rpx;
  font-weight: bold;
  display: block;
  margin-bottom: 8rpx;
}

.header-sub {
  font-size: 26rpx;
  color: #666;
}

.generate-btn {
  width: 100%;
  background: #8B5CF6;
  color: white;
  border-radius: 16rpx;
  padding: 24rpx;
  font-size: 30rpx;
  font-weight: bold;
  border: none;
  margin-bottom: 20rpx;
}

.meal-plans {
  margin-top: 20rpx;
}

.day-selector {
  white-space: nowrap;
  margin-bottom: 20rpx;
}

.day-item {
  display: inline-block;
  padding: 16rpx 32rpx;
  margin-right: 12rpx;
  border-radius: 12rpx;
  background: white;
  font-size: 28rpx;
}

.day-item.selected {
  background: #8B5CF6;
  color: white;
}

.plan-card {
  background: white;
  border-radius: 16rpx;
  padding: 24rpx;
}

.meal-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20rpx 0;
  border-bottom: 1rpx solid #f0f0f0;
}

.meal-row:last-of-type {
  border-bottom: none;
}

.meal-info {
  display: flex;
  flex-direction: column;
}

.meal-name {
  font-weight: bold;
  font-size: 28rpx;
  margin-bottom: 4rpx;
}

.meal-food {
  font-size: 24rpx;
  color: #666;
}

.meal-calories {
  font-weight: bold;
  color: #F97316;
  font-size: 28rpx;
}

.total-row {
  margin-top: 20rpx;
  padding-top: 20rpx;
  border-top: 2rpx solid #f0f0f0;
  text-align: center;
}

.total-text {
  font-weight: bold;
  color: #8B5CF6;
  font-size: 30rpx;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 100rpx 0;
}

.empty-icon {
  font-size: 80rpx;
  margin-bottom: 20rpx;
}

.empty-text {
  color: #999;
  font-size: 28rpx;
}
</style>
