<template>
  <div class="text-center container">
    <div class="row">
      <div class="col-sm-9 col-md-7 col-lg-5 mx-auto">
        <div class="card card-signin my-5">
          <div class="card-body">
            <h3 class="card-title text-center">新規登録</h3>
            <form @submit.prevent="signup">
              <div class="text-danger" v-if="error">{{ error }}</div>

              <div class="m-2">
                <label for="email" class="label">メールアドレス</label>
                <input type="email" v-model="email" class="form-control" id="email" placeholder="メールアドレス打ってね">
              </div>

              <div class="m-2">
                <label for="password" class="label">パスワード</label>
                <input type="password" v-model="password" class="form-control" id="password" placeholder="パスワード打ってね">
              </div>

              <div class="m-2">
                <label for="password_confirmation" class="label">パスワード確認用</label>
                <input type="password" v-model="password_confirmation" class="form-control" id="password_confirmation" placeholder="もう一度打ってね">
              </div>
              <button type="submit" class="btn btn-lg btn-primary btn-block">新規登録ありがとうございます</button>

              <div class="my-4"><router-link to="/" class="m-4">ログインはこちら</router-link></div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Signup',
  data () {
    return {
      email: '',
      password: '',
      password_confirmation: '',
      error: ''
    }
  },
  created () {
    this.checkedSignedIn()
  },
  updated () {
    this.checkedSignedIn()
  },
  methods: {
    signup () {
      this.$http.plain.post('/signup', { email: this.email, password: this.password, password_confirmation: this.password_confirmation })
        .then(response => this.signupSuccessful(response))
        .catch(error => this.signupFailed(error))
    },
    signupSuccessful (response) {
      if (!response.data.csrf) {
        this.signupFailed(response)
        return
      }
      localStorage.csrf = response.data.csrf
      localStorage.signedIn = true
      this.error = ''
      this.$router.replace('/details')
      location.reload()
    },
    signupFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || 'Something went wrong'
      delete localStorage.csrf
      delete localStorage.signedIn
    },
    checkedSignedIn () {
      if (localStorage.signedIn) {
        this.$router.replace('/details')
      }
    }
  }
}
</script>

<style scoped>

</style>
