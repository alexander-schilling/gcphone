<template>
  <div class="phone_app">
    <PhoneTitle :title="IntlString('APP_MDTSYSTEM_TITLE')" @back="onQuit"/>
    <div class="logn_form">
      <img src="/html/static/img/app_mdt/login_screen.png" alt="" class="img_center">

      <span><label for="uname"><b>Username</b></label></span>
      <span><input type="text" :placeholder="IntlString('APP_LOGIN_USERNAME_LABEL')" v-model="username" required></span>

      <span><label for="psw"><b>Password</b></label></span>
      <span><input type="password" :placeholder="IntlString('APP_LOGIN_PASSWORD_LABEL')" v-model="password" required></span>

      <span ><button type="submit" v-on:click="login">Login</button></span>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import PhoneTitle from './../PhoneTitle'

export default {
  components: {
    PhoneTitle
  },
  data () {
    return {
      username: '',
      password: '',
      currentSelect: 0
    }
  },
  computed: {
    ...mapGetters(['IntlString', 'useMouse', 'mdtUsername', 'mdtPassword'])
  },
  methods: {
    onBack () {
      if (this.useMouse === true && document.activeElement.tagName !== 'BODY') return
      this.onQuit()
    },
    onQuit () {
      this.$router.push({ name: 'home' })
    },
    ...mapActions(['mdtLoginRequest']),
    login () {
      const username = this.username.trim()
      const password = this.password.trim()
      if (username.length !== 0 && password.length !== 0) {
        this.mdtLoginRequest({
          username,
          password
        })

        this.TryConnection()
      }
    },
    TryConnection () {
      setTimeout(() => {
        if (this.username === this.mdtUsername && this.password === this.mdtPassword) {
          this.$router.push({ name: 'mdt.dashboard' })
        } else {
          this.TryConnection()
        }
      }, 250)
    }
  },
  created () {
    if (!this.useMouse) {
      this.$bus.$on('keyUpArrowDown', this.onDown)
      this.$bus.$on('keyUpArrowUp', this.onUp)
      this.$bus.$on('keyUpEnter', this.onEnter)
    }
    this.$bus.$on('keyUpBackspace', this.onBack)
  },
  beforeDestroy () {
    this.$bus.$off('keyUpArrowDown', this.onDown)
    this.$bus.$off('keyUpArrowUp', this.onUp)
    this.$bus.$off('keyUpEnter', this.onEnter)
    this.$bus.$off('keyUpBackspace', this.onBack)
  }
}
</script>

<style scoped>
  .logn_form {
    margin: 6px 10px;
    margin-top: 28px;
    height: calc(100% - 48px);
    display: flex;
    flex-direction: column;
  }
  input[type=text], input[type=password] {
    width: 100%;
    padding: 12px 20px;
    margin: 8px 0;
    display: inline-block;
    border: 1px solid #ccc;
    box-sizing: border-box;
    font-size: 16px;
  }
  button {
    background: #ad3333;
    color: white;
    padding: 14px 20px;
    margin: 8px 0;
    border: none;
    cursor: pointer;
    width: 100%;
    font-size: 16px;
  }
  button:hover {
    opacity: 0.8;
  }
  .img_center {
    display: block;
    margin-left: auto;
    margin-right: auto;
    width: 50%;
    animation-name: zoom;
    animation-duration: 0.6s;
    animation-fill-mode: forwards;
  }
  @keyframes zoom {
    from {width: 200px;}
      to {width: 250px;}
  }
</style>
