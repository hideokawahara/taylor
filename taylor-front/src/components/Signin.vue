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
                <!-- <p class="errors" v-for="error in errors.email" :key="error">{{error}}</p> -->
                <input type="email" v-model="email" class="form-control" id="email" placeholder="アドレス打ってね">
              </div>

              <div class="m-2">
                <label for="password" class="">パスワード</label>
                <input type="password" v-model="password" class="form-control" id="password" placeholder="パスワード打ってね">
              </div>

              <button type="submit" class="btn btn-lg btn-primary btn-block" @click="reload">ログインする</button>

              <div class="my-4 signup"><router-link to="/signup" class="m-4 signupinside">新規登録はこちら</router-link></div>
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
      // errors: {
      //   email: [],
      //   password: []
      // }
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
    // validator (type, max) {
    //   let email = []
    //   let password = []
    //   let message = max + '文字内で入力してね'
    //   if (type === 'email') {
    //     if (this.email.length > max) {
    //       email.push(message)
    //     }
    //     this.errors.email = email
    //   } else if (type === 'password') {
    //     if (this.password.length > max) {
    //       password.push(message)
    //     }
    //     this.errors.password = password
    //   }
    // }
  }
}
</script>

<style scoped>
.card.card-signin.my-5 {
  background: #6d3d6d;
  color: #ffffff;
  border-radius: 240px 15px 100px 15px / 15px 200px 15px 185px;
  border: 6px solid rgb(20, 17, 19);
}
/* .bg-green {
  background: #6d3d6d;
} */

/* .bg-green:hover {
  background-color: aquamarine;
} */
.btn.btn-lg.btn-primary.btn-block {
  background: #3c1f3c;
  border-color: gold;
}

.btn.btn-lg.btn-primary.btn-block:hover {
  background-color: rgb(240, 41, 230);
  color: gold;
  opacity: 0.5;
}

.signupinside {
  color: #ffffff;
  /* transition-property: color;
  transition-duration: 0.3s;
  transition-timing-function: ease;
  transition-delay: 0s; */
  transition: color .3s, background.3s, box-shadow .3s, transform .3s;
}

.signupinside:hover {
  /* color: rgb(255, 136, 0); */
  color: rgb(240, 41, 230);
  animation: flash 1s;
}

@keyframes flash {
  0% { color: #cca90c; }
  10% { color: rgb(240, 41, 230); }
  100% { color: #ebaf0d; }
}

</style>
