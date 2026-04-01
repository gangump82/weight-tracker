<script setup lang="ts">
import { onLaunch, onShow, onHide } from '@dcloudio/uni-app'
import store from './store/index'

onLaunch(() => {
  console.log('App Launch')
  store.init()
})

onShow(() => {
  console.log('App Show')
})

onHide(() => {
  console.log('App Hide')
})
</script>

<style>
/* 全局样式 */
page {
  background-color: #F5F5F5;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
}

button {
  margin: 0;
  padding: 0;
  background: none;
  border: none;
}

button::after {
  border: none;
}
</style>
