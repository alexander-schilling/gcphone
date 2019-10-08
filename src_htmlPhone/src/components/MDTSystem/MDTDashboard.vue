<template>
  <div class="phone_app">
    <PhoneTitle :title="IntlString('APP_MDTSYSTEM_DASHBOARD_TITLE')" @back="onQuit"/>
    <template v-if="state === STATES.MAIN_POLICE">
      <div class="main-panel">
        <div class="info-area">
          <span>Username: {{ mdtUsername }} | Account ID: {{ mdtID }}</span>
        </div>
        <div class="button-area">
          <div class="button-item">1</div>
          <div class="button-item">2</div>
          <div class="button-item">3</div>
          <div class="button-item">4</div>
          <div class="button-item">5</div>
          <div class="button-item">6</div>
        </div>
      </div>
    </template>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import PhoneTitle from './../PhoneTitle'

const STATES = Object.freeze({
  MAIN_POLICE: 0,
  MAIN_EMS: 1,
  MAIN_FIREDEPT: 2,
  NAME_DATABASE: 3,
  VEHICLE_DATABASE: 4,
  JOBS_MENU: 5,
  SHIFT_CHANGE: 6,
  ADMIN_VIEW: 7,
  WANTED_LIST: 8
})

export default {
  components: {
    PhoneTitle
  },
  data () {
    return {
      STATES,
      state: STATES.MAIN_POLICE,
      localAccount: {
        username: '',
        password: '',
        id: '',
        userBadge: '',
        userRank: ''
      }
    }
  },
  computed: {
    ...mapGetters(['IntlString', 'useMouse', 'mdtUsername', 'mdtJob', 'mdtID'])
  },
  methods: {
    onBack () {
      if (this.state !== this.STATES.MENU) {
        this.state = this.STATES.MENU
      } else {
        this.onQuit()
      }
    },
    onQuit () {
      this.$router.push({ name: 'mdt' })
    }
    // ...mapActions(['mdtLoginRequest'])
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

/*PANEL SECTION ================================= */
.main-panel {
  width: 100%;
  height: 100%;
  background: #3b3b3b;
}

.info-area {
  width: 100%;
  height: 20%;
  background: #3b3b3b;

  box-shadow: 0px 8px 10px grey;
}

.button-area {
  width: 100%;
  height: 40%;
  background: #3b3b3b;

  display: grid;
  grid-row-gap: 10px;
  grid-column-gap: 10px;
  grid-template-columns: auto auto auto;
  padding: 10px;
}

.button-item {
  background-color: #ffffff;
  padding: 20px;
  font-size: 30px;
  text-align: center;
  box-shadow: 0px 6px 10px grey;
}

</style>
