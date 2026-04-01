<template>
  <view class="container">
    <!-- 今日统计 -->
    <view class="today-card">
      <text class="today-title">🥗 今日饮食</text>
      <text class="today-value">{{ store.todayDietCalories }}</text>
      <text class="today-label">摄入 kcal</text>
    </view>

    <!-- 记录按钮 -->
    <button class="add-btn" @click="openAddDialog">
      <text class="btn-icon">+</text>
      <text>记录饮食</text>
    </button>

    <!-- 历史记录 -->
    <view class="history-card">
      <text class="history-title">📋 饮食历史</text>
      <view v-if="store.diets.length === 0" class="empty-text">
        <text>暂无饮食记录</text>
      </view>
      <view v-else class="history-list">
        <view
          v-for="diet in reversedDiets"
          :key="diet.id"
          class="history-item"
        >
          <text class="diet-icon">{{ diet.mealIcon }}</text>
          <view class="diet-info">
            <text class="diet-name">{{ diet.mealName }}</text>
            <text class="diet-sub">{{ diet.date }}</text>
          </view>
          <text class="diet-calories">{{ diet.calories }} kcal</text>
        </view>
      </view>
    </view>

    <!-- 添加弹窗 -->
    <view v-if="showAddDialog" class="modal-mask" @click="showAddDialog = false">
      <view class="modal-content" @click.stop>
        <text class="modal-title">记录饮食</text>

        <view class="form-group">
          <text class="form-label">日期</text>
          <picker mode="date" :value="selectedDate" @change="onDateChange">
            <view class="picker-value">{{ selectedDate }}</view>
          </picker>
        </view>

        <view class="form-group">
          <text class="form-label">餐次</text>
          <view class="type-grid">
            <view
              v-for="meal in mealTypes"
              :key="meal.value"
              class="type-item"
              :class="{ 'selected': selectedMealType === meal.value }"
              @click="selectedMealType = meal.value"
            >
              <text>{{ meal.label }}</text>
            </view>
          </view>
        </view>

        <view class="form-group">
          <text class="form-label">食物名称</text>
          <input
            type="text"
            v-model="inputFood"
            placeholder="请输入食物名称"
            class="form-input"
          />
        </view>

        <view class="form-group">
          <text class="form-label">热量 (kcal)</text>
          <input
            type="number"
            v-model="inputCalories"
            placeholder="请输入热量"
            class="form-input"
          />
        </view>

        <view class="modal-actions">
          <button class="cancel-btn" @click="showAddDialog = false">取消</button>
          <button class="confirm-btn" @click="saveDiet">保存</button>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import store, { formatDate } from '../../store/index'

const mealTypes = [
  { value: 'breakfast', label: '早餐 🌅' },
  { value: 'lunch', label: '午餐 ☀️' },
  { value: 'dinner', label: '晚餐 🌙' },
  { value: 'snack', label: '加餐 🍎' },
]

const showAddDialog = ref(false)
const selectedDate = ref(formatDate(new Date()))
const selectedMealType = ref('breakfast')
const inputFood = ref('')
const inputCalories = ref('')

const reversedDiets = computed(() => {
  return [...store.diets].reverse().slice(0, 20)
})

function onDateChange(e: any) {
  selectedDate.value = e.detail.value
}

function openAddDialog() {
  selectedDate.value = formatDate(new Date())
  selectedMealType.value = 'breakfast'
  inputFood.value = ''
  inputCalories.value = ''
  showAddDialog.value = true
}

function saveDiet() {
  const calories = parseInt(inputCalories.value) || 0
  if (calories > 0) {
    const meal = mealTypes.find(m => m.value === selectedMealType.value)!
    const [mealName, mealIcon] = meal.label.split(' ')
    store.addDiet({
      date: selectedDate.value,
      mealType: selectedMealType.value,
      mealName: inputFood.value || mealName,
      mealIcon,
      calories
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
  background: rgba(249, 115, 22, 0.1);
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
  color: #F97316;
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

.diet-icon {
  font-size: 40rpx;
  margin-right: 16rpx;
}

.diet-info {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.diet-name {
  font-size: 28rpx;
  color: #333;
}

.diet-sub {
  font-size: 24rpx;
  color: #999;
}

.diet-calories {
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
