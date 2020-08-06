<template>
  <div class="errors" v-if="errors">
    <div class="error" v-for="error in errors" :key="error">{{ error }}</div>
  </div>
</template>

<script>
export default {
  name: 'errors',
  props: ['errors']
}
</script>

<style>

</style>
