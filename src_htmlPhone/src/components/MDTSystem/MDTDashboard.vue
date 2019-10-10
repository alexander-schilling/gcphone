<template>
  <div class="phone_app">
    <PhoneTitle :title="IntlString('APP_MDTSYSTEM_DASHBOARD_TITLE')" @back="onQuit"/>
    <template v-if="state === STATES.MAIN_POLICE">
      <div class="main-panel">
        <div class="info-area">
          <div class="logo">
            <img src="/html/static/img/app_mdt/police.png" alt="">
          </div>
          <span>Username: {{ mdtUsername }}</span>
          <span>Account ID: {{ mdtID }}</span>
          <span>Admin Level: {{ mdtAdmin }}</span>
        </div>
        <div class="button-area">
          <div class="button-item">Manage Account</div>
          <div class="button-item">Jobs</div>
          <div class="button-item">Name Database</div>
          <div class="button-item">Plate Database</div>
          <div class="button-item">Wanted List</div>
          <div v-if="isAdmin" class="button-item">Admin</div>
        </div>
      </div>
    </template>

    <template v-else-if="state === STATES.MAIN_EMS">
      <div class="main-panel">
        <div class="logo">
          <img src="/html/static/img/app_mdt/ems.png" alt="">
        </div>
        <div class="info-area">
          <span>Username: {{ mdtUsername }}</span>
          <span>Account ID: {{ mdtID }}</span>
          <span>Admin Level: {{ mdtAdmin }}</span>
        </div>
        <div class="button-area">
          <div class="button-item">Manage Account</div>
          <div class="button-item">Jobs</div>
          <div class="button-item">Name Database</div>
          <div v-if="isAdmin" class="button-item">Admin</div>
        </div>
      </div>
    </template>

    <template v-else-if="state === STATES.MAIN_FIREDEPT">
      <div class="main-panel">
        <div class="logo">
          <img src="/html/static/img/app_mdt/firedept.png" alt="">
        </div>
        <div class="info-area">
          <span>Username: {{ mdtUsername }}</span>
          <span>Account ID: {{ mdtID }}</span>
          <span>Admin Level: {{ mdtAdmin }}</span>
        </div>
        <div class="button-area">
          <div class="button-item">Manage Account</div>
          <div class="button-item">Jobs</div>
          <div class="button-item">Name Database</div>
          <div v-if="isAdmin" class="button-item">Admin</div>
        </div>
      </div>
    </template>

    <template v-else-if="state === STATES.NAME_DATABASE">
      <div class="main-panel">

      </div>
    </template>

    <template v-else-if="state === STATES.VEHICLE_DATABASE">
      <div class="main-panel">

      </div>
    </template>

    <template v-else-if="state === STATES.JOBS_MENU">
      <div class="main-panel">

      </div>
    </template>

    <template v-else-if="state === STATES.WANTED_LIST">
      <div class="main-panel">

      </div>
    </template>

    <template v-else-if="state === STATES.ADMIN_VIEW">
      <div class="main-panel">

      </div>
    </template>

    <template v-else-if="state === STATES.MANAGE_ACCOUNT">
      <div class="main-panel">

      </div>
    </template>

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
  ADMIN_VIEW: 6,
  WANTED_LIST: 7,
  MANAGE_ACCOUNT: 8
})

export default {
  components: {
    PhoneTitle
  },
  data () {
    return {
      STATES,
      state: STATES.MAIN_POLICE
    }
  },
  computed: {
    ...mapGetters(['IntlString', 'useMouse', 'mdtUsername', 'mdtJob', 'mdtID', 'mdtAdmin']),
    isAdmin () {
      return this.mdtAdmin >= 1 || this.mdtAdmin >= 2
    }
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
    },
    onLoad () {
      switch (this.mdtJob) {
        case '0':
          this.state = this.STATES.MAIN_POLICE
          break
        case '1':
          this.state = this.STATES.MAIN_EMS
          break
        case '2':
          this.state = this.STATES.MAIN_FIREDEPT
          break
      }
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
  },
  beforeMount () {
    this.onLoad()
  }
}
</script>

<style scoped>

/*PANEL SECTION ================================= */
.main-panel {
  width: 100%;
  height: 100%;
  background: #dbdbdb;
}

.info-area {
  width: 100%;
  height: 20%;
  background: #dbdbdb;

  box-shadow: 0px 8px 10px grey;
}

.info-area span {
  padding-left: 1%;
  display: block;
}

.logo img {
  float: left;
  width: 30%;
}

.button-area {
  width: 100%;
  height: 80%;
  background: #dbdbdb;

  display: block;
  padding: 10px;
}

.button-item {
  background-color: #080808;
  color: #dbdbdb;
  padding: 10px;
  font-size: 30px;
  text-align: center;
  box-shadow: 0px 5px 5px grey;

  margin-top: 2%;
}

</style>
