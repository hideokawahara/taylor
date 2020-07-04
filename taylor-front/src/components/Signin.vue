<template>
  <div class="text-center container">
    <div class="row">
      <div class="col-sm-9 col-md-7 col-lg-5 mx-auto">
        <div class="card card-signin my-5">
          <div class="card-body">
            <h3 class="card-title text-center">ログイン</h3>
            <form @submit.prevent="signin">
              <div class="text-danger" v-if="error">{{ error }}</div>

              <div class="m-2">
                <label for="email" class="">メールアドレス</label>
                <input type="email" v-model="email" class="form-control" id="email" placeholder="アドレス打ってね">
              </div>

              <div class="m-2">
                <label for="password" class="">パスワード</label>
                <input type="password" v-model="password" class="form-control" id="password" placeholder="パスワード打ってね">
              </div>

              <button type="submit" class="btn btn-lg btn-primary btn-block" @click="reload">ログインする</button>

              <div class="my-4"><router-link to="/signup" class="m-4">新規登録はこちら</router-link></div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Signin',
  data () {
    return {
      email: '',
      password: '',
      error: ''
    }
  },
  created () {
    this.checkSignedIn()
  },
  updated () {
    this.checkSignedIn()
  },
  methods: {
    signin () {
      this.$http.plain.post('/signin', { email: this.email, password: this.password })
        .then(response => this.signinSuccessful(response))
        .catch(error => this.signinFailed(error))
    },
    signinSuccessful (response) {
      if (!response.data.csrf) {
        this.signinFailed(response)
        return
      }
      localStorage.csrf = response.data.csrf
      localStorage.signedIn = true
      this.error = ''
      this.$router.replace('/details')
      location.reload()
    },
    signinFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      delete localStorage.csrf
      delete localStorage.signedIn
    },
    checkSignedIn () {
      if (localStorage.signedIn) {
        this.$router.replace('/details')
      }
    },
    reload () {
      console.log('test')
    }
  }
}
</script>

<style scoped>
.bg-green {
  background-color: aqua;
}

.bg-green:hover {
  background-color: aquamarine;
}
</style>
