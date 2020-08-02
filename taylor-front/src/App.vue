<template>
  <div id="app">
    <Header />
    <router-view/>
  </div>
</template>

<script>
import Header from '@/components/Header.vue'

export default {
  name: 'App',
  components: {
    Header
  }
}
</script>

<style scoped>
  #app {
    background: #553055;
    /* bottom: 0; */
    padding-bottom: 18%;
    min-height: 100%;
  }
</style>
