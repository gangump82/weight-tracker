import { reactive } from 'vue'

// 数据类型定义
interface WeightRecord {
  date: string
  weight: number
  createdAt: string
}

interface CheckIn {
  date: string
  createdAt: string
}

interface ExerciseRecord {
  id: string
  date: string
  type: string
  typeName: string
  typeIcon: string
  duration: number
  calories: number
  createdAt: string
}

interface DietRecord {
  id: string
  date: string
  mealType: string
  mealName: string
  mealIcon: string
  calories: number
  createdAt: string
}

interface UserGoal {
  targetWeight?: number
  height?: number
  age?: number
  gender?: string
}

interface Recipe {
  name: string
  calories: number
  protein: number
  carbs: number
  fat: number
  fiber: number
}

interface DayMealPlan {
  dayIndex: number
  breakfast: Recipe
  lunch: Recipe
  dinner: Recipe
  snack: Recipe
  totalCalories: number
}

// 格式化日期
function formatDate(date: Date): string {
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  return `${year}-${month}-${day}`
}

// 创建响应式store
const store = reactive({
  weightRecords: [] as WeightRecord[],
  checkIns: [] as CheckIn[],
  exercises: [] as ExerciseRecord[],
  diets: [] as DietRecord[],
  userGoal: {} as UserGoal,
  mealPlans: [] as DayMealPlan[],

  // 计算属性
  get currentWeight(): number | null {
    return this.weightRecords.length > 0 ? this.weightRecords[this.weightRecords.length - 1].weight : null
  },

  get startWeight(): number | null {
    return this.weightRecords.length > 0 ? this.weightRecords[0].weight : null
  },

  get weightLost(): number {
    if (this.startWeight === null || this.currentWeight === null) return 0
    return this.startWeight - this.currentWeight
  },

  get bmi(): number | null {
    if (this.currentWeight === null || !this.userGoal.height) return null
    const heightM = this.userGoal.height / 100.0
    return this.currentWeight / (heightM * heightM)
  },

  get streakDays(): number {
    if (this.checkIns.length === 0) return 0
    const sortedDates = [...this.checkIns].map(c => c.date).sort((a, b) => b.localeCompare(a))
    let streak = 0
    let checkDate = new Date()
    checkDate = new Date(checkDate.getFullYear(), checkDate.getMonth(), checkDate.getDate())

    for (let i = 0; i < sortedDates.length; i++) {
      const expectedDate = formatDate(checkDate)
      if (sortedDates.includes(expectedDate)) {
        streak++
        checkDate = new Date(checkDate.getTime() - 24 * 60 * 60 * 1000)
      } else {
        break
      }
    }
    return streak
  },

  get todayExerciseCalories(): number {
    const today = formatDate(new Date())
    return this.exercises
      .filter(e => e.date === today)
      .reduce((sum, e) => sum + e.calories, 0)
  },

  get todayDietCalories(): number {
    const today = formatDate(new Date())
    return this.diets
      .filter(d => d.date === today)
      .reduce((sum, d) => sum + d.calories, 0)
  },

  get isCheckedInToday(): boolean {
    const today = formatDate(new Date())
    return this.checkIns.some(c => c.date === today)
  },

  // 初始化
  async init() {
    try {
      const weightData = uni.getStorageSync('weight_records')
      if (weightData) this.weightRecords = JSON.parse(weightData)

      const checkInData = uni.getStorageSync('check_ins')
      if (checkInData) this.checkIns = JSON.parse(checkInData)

      const exerciseData = uni.getStorageSync('exercises')
      if (exerciseData) this.exercises = JSON.parse(exerciseData)

      const dietData = uni.getStorageSync('diets')
      if (dietData) this.diets = JSON.parse(dietData)

      const goalData = uni.getStorageSync('user_goal')
      if (goalData) this.userGoal = JSON.parse(goalData)
    } catch (e) {
      console.error('初始化数据失败', e)
    }
  },

  // 保存数据
  saveData() {
    try {
      uni.setStorageSync('weight_records', JSON.stringify(this.weightRecords))
      uni.setStorageSync('check_ins', JSON.stringify(this.checkIns))
      uni.setStorageSync('exercises', JSON.stringify(this.exercises))
      uni.setStorageSync('diets', JSON.stringify(this.diets))
      uni.setStorageSync('user_goal', JSON.stringify(this.userGoal))
    } catch (e) {
      console.error('保存数据失败', e)
    }
  },

  // 体重操作
  addWeightRecord(date: string, weight: number) {
    this.weightRecords = this.weightRecords.filter(r => r.date !== date)
    this.weightRecords.push({
      date,
      weight,
      createdAt: new Date().toISOString()
    })
    this.weightRecords.sort((a, b) => a.date.localeCompare(b.date))
    this.saveData()
  },

  deleteWeightRecord(date: string) {
    this.weightRecords = this.weightRecords.filter(r => r.date !== date)
    this.saveData()
  },

  // 打卡操作
  toggleCheckIn() {
    const today = formatDate(new Date())
    if (this.checkIns.some(c => c.date === today)) {
      this.checkIns = this.checkIns.filter(c => c.date !== today)
    } else {
      this.checkIns.push({
        date: today,
        createdAt: new Date().toISOString()
      })
    }
    this.saveData()
  },

  // 运动操作
  addExercise(record: Omit<ExerciseRecord, 'id' | 'createdAt'>) {
    this.exercises.push({
      ...record,
      id: Date.now().toString(),
      createdAt: new Date().toISOString()
    })
    this.saveData()
  },

  deleteExercise(id: string) {
    this.exercises = this.exercises.filter(e => e.id !== id)
    this.saveData()
  },

  // 饮食操作
  addDiet(record: Omit<DietRecord, 'id' | 'createdAt'>) {
    this.diets.push({
      ...record,
      id: Date.now().toString(),
      createdAt: new Date().toISOString()
    })
    this.saveData()
  },

  deleteDiet(id: string) {
    this.diets = this.diets.filter(d => d.id !== id)
    this.saveData()
  },

  // 用户目标
  setUserGoal(goal: Partial<UserGoal>) {
    this.userGoal = { ...this.userGoal, ...goal }
    this.saveData()
  },

  // 生成食谱
  generateMealPlans() {
    const breakfastRecipes: Recipe[] = [
      { name: '燕麦粥+鸡蛋+牛奶', calories: 380, protein: 18, carbs: 45, fat: 12, fiber: 5 },
      { name: '全麦面包+煎蛋+酸奶', calories: 420, protein: 20, carbs: 48, fat: 15, fiber: 4 },
      { name: '小米粥+肉包子+豆浆', calories: 450, protein: 18, carbs: 60, fat: 14, fiber: 3 },
      { name: '鸡蛋灌饼+豆浆', calories: 480, protein: 16, carbs: 55, fat: 20, fiber: 2 },
      { name: '杂粮馒头+鸡蛋+牛奶', calories: 400, protein: 18, carbs: 50, fat: 12, fiber: 6 },
    ]

    const lunchRecipes: Recipe[] = [
      { name: '米饭+清蒸鱼+炒青菜', calories: 550, protein: 28, carbs: 70, fat: 15, fiber: 5 },
      { name: '米饭+红烧鸡块+炒西兰花', calories: 620, protein: 30, carbs: 75, fat: 20, fiber: 4 },
      { name: '面条+番茄牛腩+青菜', calories: 600, protein: 25, carbs: 80, fat: 18, fiber: 4 },
      { name: '杂粮饭+豆腐烧肉+炒时蔬', calories: 580, protein: 24, carbs: 72, fat: 18, fiber: 6 },
      { name: '米饭+宫保鸡丁+凉拌黄瓜', calories: 560, protein: 26, carbs: 68, fat: 18, fiber: 3 },
    ]

    const dinnerRecipes: Recipe[] = [
      { name: '小米粥+清炒时蔬+煎饺', calories: 450, protein: 16, carbs: 58, fat: 16, fiber: 4 },
      { name: '米饭+蒜蓉虾+炒豆苗', calories: 520, protein: 26, carbs: 65, fat: 15, fiber: 4 },
      { name: '杂粮粥+肉末茄子+凉菜', calories: 480, protein: 18, carbs: 60, fat: 16, fiber: 5 },
      { name: '馒头+冬瓜排骨汤+炒青菜', calories: 500, protein: 22, carbs: 62, fat: 16, fiber: 4 },
      { name: '米饭+香菇滑鸡+炒西兰花', calories: 530, protein: 24, carbs: 65, fat: 17, fiber: 5 },
    ]

    const snackRecipes: Recipe[] = [
      { name: '苹果', calories: 95, protein: 0, carbs: 25, fat: 0, fiber: 4 },
      { name: '酸奶', calories: 120, protein: 6, carbs: 15, fat: 4, fiber: 0 },
      { name: '坚果一小把', calories: 150, protein: 5, carbs: 6, fat: 13, fiber: 2 },
      { name: '香蕉', calories: 105, protein: 1, carbs: 27, fat: 0, fiber: 3 },
      { name: '牛奶', calories: 150, protein: 8, carbs: 12, fat: 8, fiber: 0 },
    ]

    const random = Date.now()
    this.mealPlans = Array.from({ length: 7 }, (_, index) => {
      const breakfast = breakfastRecipes[(random + index) % breakfastRecipes.length]
      const lunch = lunchRecipes[(random + index + 1) % lunchRecipes.length]
      const dinner = dinnerRecipes[(random + index + 2) % dinnerRecipes.length]
      const snack = snackRecipes[(random + index + 3) % snackRecipes.length]
      return {
        dayIndex: index,
        breakfast,
        lunch,
        dinner,
        snack,
        totalCalories: breakfast.calories + lunch.calories + dinner.calories + snack.calories
      }
    })
  }
})

export default store
export { formatDate }
export type { WeightRecord, CheckIn, ExerciseRecord, DietRecord, UserGoal, Recipe, DayMealPlan }
