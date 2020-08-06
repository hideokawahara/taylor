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
                <!-- <p class="errors" v-for="error in errors.email" :key="error">{{error}}</p> -->
                <input type="email" v-model="email" class="form-control" id="email" placeholder="メールアドレス打ってね">
              </div>

              <div class="m-2">
                <label for="password" class="label">パスワード</label>
                <!-- <p class="errors" v-for="error in errors.password" :key="error">{{error}}</p> -->
                <errors :errors="errors.password"></errors>
                <input type="password" v-model="password" class="form-control" id="password" placeholder="パスワード打ってね" @input="validator('password', 15)">
              </div>

              <div class="m-2">
                <label for="password_confirmation" class="label">パスワード確認用</label>
                <!-- <p class="errors" v-for="error in errors.password_confirmation" :key="error">{{error}}</p> -->
                <errors :errors="errors.password_confirmation"></errors>
                <input type="password" v-model="password_confirmation" class="form-control" id="password_confirmation" placeholder="もう一度打ってね" @input="validator('password_confirmation', 16)">
              </div>
              <button type="submit" @click.prevent="validate" class="btn btn-lg btn-primary btn-block">新規登録ありがとうございます</button>

              <div class="my-4"><router-link to="/" class="m-4 logininside">ログインはこちら</router-link></div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import errors from './errors'

export default {
  name: 'Signup',
  components: {
    errors
  },
  data () {
    return {
      email: '',
      password: '',
      password_confirmation: '',
      error: '',
      errors: {
        email: [],
        password: [],
        password_confirmation: []
      }
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
    },
    validator (type, max) {
      let email = []
      let password = []
      let passwordConfirmation = []
      let message = max + '文字内で入力してね'
      if (type === 'email') {
        if (this.email.length > max) {
          email.push(message)
        }
        this.errors.email = email
      } else if (type === 'password') {
        if (this.password.length > max) {
          password.push(message)
        }
        this.errors.password = password
      } else if (type === 'password_confirmation') {
        if (this.password_confirmation.length > max) {
          passwordConfirmation.push(message)
        }
        this.errors.password_confirmation = passwordConfirmation
      }
    },
    validate () {
      let errors = {
        password: [],
        passwordConfirmation: []
      }
      if (!this.password) {
        errors.password.push('パスワードが入力されてません')
        this.errors.password = errors.password
      } else if (this.password.length > 15) {
        errors.password.push('15文字以内に入力しましょう')
      }
      if (!this.password_confirmation) {
        console.log(1, this.password_confirmation)
        console.log(2, errors.passwordConfirmation)
        errors.passwordConfirmation.push('確認パスワードが入力されてません')
        console.log(3, errors.passwordConfirmation)
        this.errors.password_confirmation = errors.passwordConfirmation
        console.log(4, this.errors.password_confirmation)
      } else if (this.ppassword_confirmation.length > 15) {
        errors.passwordConfirmation.push('16文字以内に入力しましょう')
      }
      // this.errors = errors
      // console.log(5, errors.passwordConfirmation)
      // console.log(6, this.errors.password_confirmation)
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

.errors {
  color: red;
  font-size: 1.5rem;
}
</style>
