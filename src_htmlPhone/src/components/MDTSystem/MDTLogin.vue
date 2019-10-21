<template>
  <div class="phone_app">
    <PhoneTitle :title="IntlString('APP_MDTSYSTEM_TITLE')" @back="onQuit"/>
    <div class="login-form">
      <img src="/html/static/img/app_mdt/login_screen.png" alt="" class="img_center">

      <div class="group inputText" data-type="text" data-maxlength='64' data-defaultValue="Username">
        <label for="uname"><b>Username</b></label>
        <input type="text" :placeholder="IntlString('APP_LOGIN_USERNAME_LABEL')" :value="localAccount.username" @change="setLocalAccount($event, 'username')">
        <!--<span class="highlight"></span>-->
        <span class="bar"></span>
      </div>

      <div class="group inputText" data-type="text" data-model='password' data-maxlength='18' data-defaultValue="Password">
        <label for="psw"><b>Password</b></label>
        <input autocomplete="new-password" type="password" :placeholder="IntlString('APP_LOGIN_PASSWORD_LABEL')" :value="localAccount.password" @change="setLocalAccount($event, 'password')">
        <!--<span class="highlight"></span>-->
        <span class="bar"></span>
      </div>

      <div class="group" data-type="button" @click.stop="login">
        <input type='button' class="btn" @click.stop="login" value="Login" />
        <span class="bar"></span>
      </div>

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
      localAccount: {
        username: '',
        password: ''
      },
      currentSelect: 0
    }
  },
  computed: {
    ...mapGetters(['IntlString', 'useMouse', 'mdtUsername', 'mdtPassword'])
  },
  methods: {
    onUp: function () {
      if (this.ignoreControls === true) return
      let select = document.querySelector('.group.select')
      if (select === null) {
        select = document.querySelector('.group')
        select.classList.add('select')
        return
      }
      while (select.previousElementSibling !== null) {
        if (select.previousElementSibling.classList.contains('group')) {
          break
        }
        select = select.previousElementSibling
      }
      if (select.previousElementSibling !== null) {
        document.querySelectorAll('.group').forEach(elem => {
          elem.classList.remove('select')
        })
        select.previousElementSibling.classList.add('select')
        let i = select.previousElementSibling.querySelector('input')
        if (i !== null) {
          i.focus()
        }
      }
    },
    onDown: function () {
      if (this.ignoreControls === true) return
      let select = document.querySelector('.group.select')
      if (select === null) {
        select = document.querySelector('.group')
        select.classList.add('select')
        return
      }
      while (select.nextElementSibling !== null) {
        if (select.nextElementSibling.classList.contains('group')) {
          break
        }
        select = select.nextElementSibling
      }
      if (select.nextElementSibling !== null) {
        document.querySelectorAll('.group').forEach(elem => {
          elem.classList.remove('select')
        })
        select.nextElementSibling.classList.add('select')
        let i = select.nextElementSibling.querySelector('input')
        if (i !== null) {
          i.focus()
        }
      }
    },
    onEnter: function () {
      if (this.ignoreControls === true) return

      console.log('I just hit Enter')
      let select = document.querySelector('.group.select')
      if (select === null) return

      if (select.dataset !== null) {
        if (select.dataset.type === 'text') {
          const $input = select.querySelector('input')
          let options = {
            limit: parseInt(select.dataset.maxlength) || 64,
            text: select.dataset.defaultValue || ''
          }
          this.$phoneAPI.getReponseText(options).then(data => {
            $input.value = data.text
            $input.dispatchEvent(new window.Event('change'))
          })
        }
        if (select.dataset.type === 'button') {
          console.log('I just hit Enter on a Button')
          select.click()
        }
      }
    },
    setLocalAccount ($event, key) {
      this.localAccount[key] = $event.target.value
    },
    onBack () {
      if (this.useMouse === true && document.activeElement.tagName !== 'BODY') return
      this.onQuit()
    },
    onQuit () {
      this.$router.push({ name: 'home' })
    },
    ...mapActions(['mdtLoginRequest']),
    login () {
      console.log('I was called')
      if (this.localAccount.username.length !== 0 && this.localAccount.password.length !== 0) {
        console.log('I was called in the if statement')
        console.log(this.localAccount.username)
        console.log(this.localAccount.password)
        this.mdtLoginRequest({
          username: this.localAccount.username,
          password: this.localAccount.password
        })

        this.TryConnection()
      }
    },
    TryConnection () {
      setTimeout(() => {
        if (this.localAccount.username === this.mdtUsername && this.localAccount.password === this.mdtPassword) {
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
  .login-form {
    margin: 6px 12px;
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
    font-size: 18px;
  }

  .btn {
    background: #ad3333;
    color: white;
    padding: 8px 20px;
    margin: 8px 0;
    border: none;
    cursor: pointer;
    width: 100%;
    height: 48px;
    font-size: 16px;
  }
  .btn:hover {
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

  .group {
    position:relative;
    margin: 4px 4px;
  }
  .group.inputText {
    position:relative;
    margin-top:20px;
  }

  /* BOTTOM BARS ================================= */
  .bar 	{ position:relative; display:block; width:100%; }
  .bar:before, .bar:after 	{
    content:'';
    height:2px;
    width:0;
    bottom:1px;
    position:absolute;
    background:#631e1e;
    transition:0.2s ease all;
    -moz-transition:0.2s ease all;
    -webkit-transition:0.2s ease all;
  }
  .bar:before {
    left:50%;
  }
  .bar:after {
    right:50%;
  }

  /* active state */
  input:focus ~ .bar:before, input:focus ~ .bar:after,
  .group.select input ~ .bar:before, .group.select input ~ .bar:after{
    width:50%;
  }

  /* HIGHLIGHTER ================================== */
  .highlight {
    position:absolute;
    height:60%;
    width:100px;
    top:25%;
    left:0;
    pointer-events:none;
    opacity:0.5;
  }

  /* active state */
  input:focus ~ .highlight {
    -webkit-animation:inputHighlighter 0.3s ease;
    -moz-animation:inputHighlighter 0.3s ease;
    animation:inputHighlighter 0.3s ease;
  }

  /* ANIMATIONS ================ */
  @-webkit-keyframes inputHighlighter {
  	from { background:#ad3333; }
    to 	{ width:0; background:transparent; }
  }
  @-moz-keyframes inputHighlighter {
  	from { background:#ad3333; }
    to 	{ width:0; background:transparent; }
  }
  @keyframes inputHighlighter {
  	from { background:#ad3333; }
    to 	{ width:0; background:transparent; }
  }
</style>
