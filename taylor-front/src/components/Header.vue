<template>
  <div class="d-flex flex-column flex-md-row align-items-center p-3 px-md-4 mb-3 bg-dark border-bottom box-shadow">
    <h5 class="my-0 mr-md-auto font-weight-normal"><a href="/" class="text-white">taYlor</a></h5>
    <nav class="my-2 my-md-0 mr-md-3">
      <router-link to="/" class="p-2 text-white" v-if="!signedIn()">ログイン</router-link>
      <router-link to="/signup" class="p-2 text-white" v-if="!signedIn()">新規登録</router-link>
      <router-link to="/details" class="p-2 text-white" v-if="signedIn()">詳細</router-link>
      <router-link to="/record_tags" class="p-2 text-white" v-if="signedIn()">プログラミング言語</router-link>
      <a href="#" @click.prevent="signOut" class="p-2 text-white" v-if="signedIn()">ログアウト</a>
    </nav>
  </div>
</template>

<script>
export default {
  name: 'Header',
  created () {
    this.signedIn()
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    signedIn () {
      return localStorage.signedIn
    },
    signOut () {
      this.$http.secured.delete('/signin')
        .then(response => {
          delete localStorage.csrf
          delete localStorage.signedIn
          this.$router.replace('/')
          location.reload()
        })
        .catch(error => this.setError(error, 'Cannot sign out'))
    }
  }
}
</script>
