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

              <div class="my-4"><router-link to="/" class="m-4 logininside">ログインはこちら</router-link></div>
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
.card.card-signin.my-5 {
  border-radius: 240px 15px 100px 15px / 15px 200px 15px 185px;
  border: 2px solid #333;
  color: #ffffff;
  background: #6d3d6d;
}

.btn.btn-lg.btn-primary.btn-block {
  background: #3c1f3c;
  border-color: gold;
}

.btn.btn-lg.btn-primary.btn-block:hover {
  background-color: rgb(240, 41, 230);
  color: gold;
  opacity: 0.5;
}

.logininside {
  color: #ffffff;
  /* transition-property: color;
  transition-duration: 0.3s;
  transition-timing-function: ease;
  transition-delay: 0s; */
  transition: color .3s, background.3s, box-shadow .3s, transform .3s;
}

.logininside:hover {
  color: rgb(240, 41, 230);
  animation: flash 1s;
}

@keyframes flash {
  0% { color: #cca90c; }
  10% { color: rgb(240, 41, 230); }
  100% { color: #ebaf0d; }
}
</style>
