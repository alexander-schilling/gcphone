<template>
  <div class="phone_app">
    <PhoneTitle :title="IntlString('APP_MDTSYSTEM_DASHBOARD_TITLE')" @back="onBack"/>
    <template v-if="state === STATES.MAIN_POLICE">
      <div class="main-panel">
        <div class="main-info-area">
          <div class="logo">
            <img src="/html/static/img/app_mdt/police.png" alt="">
          </div>
          <span>Username: {{ mdtUsername }}</span>
          <span>Account ID: {{ mdtID }}</span>
          <span>Admin Level: {{ mdtAdmin }}</span>
        </div>
        <div class="main-button-area">

          <div class="main-button-item">
            <div class="group" data-type="button" @click.stop="state = STATES.MANAGE_ACCOUNT">
              Manage Account
              <span class="bar"></span>
            </div>
          </div>

          <div class="main-button-item">
            <div class="group" data-type="button" @click.stop="state = STATES.JOBS_MENU">
              Jobs
              <span class="bar"></span>
            </div>
          </div>

          <div class="main-button-item">
            <div class="group" data-type="button" @click.stop="state = STATES.NAME_DATABASE">
              Name Database
              <span class="bar"></span>
            </div>
          </div>

          <div class="main-button-item">
            <div class="group" data-type="button" @click.stop="state = STATES.VEHICLE_DATABASE">
              Plate Database
              <span class="bar"></span>
            </div>
          </div>

          <div class="main-button-item">
            <div class="group" data-type="button" @click.stop="state = STATES.WANTED_LIST">
              Wanted List
              <span class="bar"></span>
            </div>
          </div>

          <div v-if="isAdmin" class="main-button-item">
            <div class="group" data-type="button" @click.stop="state = STATES.ADMIN_VIEW">
              Admin
              <span class="bar"></span>
            </div>
          </div>

        </div>
      </div>
    </template>

    <template v-else-if="state === STATES.MAIN_EMS">
      <div class="main-panel">
        <div class="logo">
          <img src="/html/static/img/app_mdt/ems.png" alt="">
        </div>
        <div class="main-info-area">
          <span>Username: {{ mdtUsername }}</span>
          <span>Account ID: {{ mdtID }}</span>
          <span>Admin Level: {{ mdtAdmin }}</span>
        </div>
        <div class="main-button-area">
          <div class="main-button-item">
            <div class="group" data-type="button" @click.stop="state = STATES.MANAGE_ACCOUNT">
              Manage Account
              <span class="bar"></span>
            </div>
          </div>

          <div class="main-button-item">
            <div class="group" data-type="button" @click.stop="state = STATES.JOBS_MENU">
              Jobs
              <span class="bar"></span>
            </div>
          </div>

          <div class="main-button-item">
            <div class="group" data-type="button" @click.stop="state = STATES.NAME_DATABASE">
              Name Database
              <span class="bar"></span>
            </div>
          </div>

          <div v-if="isAdmin" class="main-button-item">
            <div class="group" data-type="button" @click.stop="state = STATES.ADMIN_VIEW">
              Admin
              <span class="bar"></span>
            </div>
          </div>
        </div>
      </div>
    </template>

    <template v-else-if="state === STATES.MAIN_FIREDEPT">
      <div class="main-panel">
        <div class="logo">
          <img src="/html/static/img/app_mdt/firedept.png" alt="">
        </div>
        <div class="main-info-area">
          <span>Username: {{ mdtUsername }}</span>
          <span>Account ID: {{ mdtID }}</span>
          <span>Admin Level: {{ mdtAdmin }}</span>
        </div>
        <div class="main-button-area">
          <div class="main-button-item">
            <div class="group" data-type="button" @click.stop="state = STATES.MANAGE_ACCOUNT">
              Manage Account
              <span class="bar"></span>
            </div>
          </div>

          <div class="main-button-item">
            <div class="group" data-type="button" @click.stop="state = STATES.JOBS_MENU">
              Jobs
              <span class="bar"></span>
            </div>
          </div>

          <div v-if="isAdmin" class="button-item">
            <div class="group" data-type="button" @click.stop="state = STATES.ADMIN_VIEW">
              Admin
              <span class="bar"></span>
            </div>
          </div>
        </div>
      </div>
    </template>

    <template v-else-if="state === STATES.NAME_DATABASE">
      <div class="main-panel">
        <div class="input-area">
          <div class="group inputText" data-type="text" data-maxlength='64' data-defaultValue="First Name">
            <input type="text" :placeholder="IntlString('APP_USER_NAME_LABEL')" v-model="firstname">
            <!--<span class="highlight"></span>-->
            <span class="bar"></span>
          </div>

          <div class="group inputText" data-type="text" data-maxlength='64' data-defaultValue="Last Name">
            <input type="text" :placeholder="IntlString('APP_USER_SURNAME_LABEL')" v-model="surname">
            <!--<span class="highlight"></span>-->
            <span class="bar"></span>
          </div>

          <div class="group" data-type="button" v-on:click="checkCitizen">
            <input type='button' class="btn" @click.stop="checkCitizen" value="Lookup" />
            <!--<span class="highlight"></span>-->
            <span class="bar"></span>
          </div>

        </div>
        <div class="result-area">
          <table>
            <tr>
              <td>Name:</td>
              <td>{{ mdtCitName }} {{ mdtCitSurName }}</td>
            </tr>
            <tr>
              <td>Date Of Birth:</td>
              <td>{{ mdtCitDOB }}</td>
            </tr>
            <tr>
              <td>Sex:</td>
              <td>{{ mdtCitSex }}</td>
            </tr>
            <tr>
              <td>Height:</td>
              <td>{{ mdtCitHeight }}</td>
            </tr>
          </table>
          {{ mdtCitID }}
        </div>
      </div>
    </template>

    <template v-else-if="state === STATES.VEHICLE_DATABASE">
      <div class="main-panel">
        <div class="main-panel">
          <div class="input-area">
            <div class="group inputText" data-type="text" data-maxlength='64' data-defaultValue="First Name">
              <input type="text" :placeholder="IntlString('APP_VEHICLE_PLATE_LABEL')" v-model="plate">
              <!--<span class="highlight"></span>-->
              <span class="bar"></span>
            </div>

            <div class="group" data-type="button" v-on:click="checkVehicle">
              <input type='button' class="btn" @click.stop="checkVehicle" value="Lookup" />
              <!--<span class="highlight"></span>-->
              <span class="bar"></span>
            </div>

          </div>
          <div class="result-area">
            <table>
              <tr>
                <td>Owner:</td>
                <td>{{ mdtCitName }} {{ mdtCitSurName }}</td>
              </tr>
              <tr>
                <td>Plate:</td>
                <td>{{ mdtVehPlate }}</td>
              </tr>
              <tr>
                <td>Model:</td>
                <td>{{ mdtVehModel }}</td>
              </tr>
            </table>
          </div>
        </div>
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
import { mapGetters, mapActions } from 'vuex'
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
    ...mapGetters([
    'IntlString', 'useMouse', 'mdtUsername',
    'mdtJob', 'mdtID', 'mdtAdmin',
    'mdtCitName', 'mdtCitSurName', 'mdtCitDOB',
    'mdtCitSex', 'mdtCitHeight', 'mdtCitID',
    'mdtVehPlate', 'mdtVehModel'
    ]),
    isAdmin () {
      return this.mdtAdmin >= 1
    }
  },
  methods: {
    ...mapActions(['mdtLog']),
    onBack () {
      if (this.state !== this.STATES.MAIN_POLICE && this.mdtJob === '0') {
        this.state = this.STATES.MAIN_POLICE
      } else if (this.state !== this.STATES.MAIN_EMS && this.mdtJob === '1') {
        this.state = this.STATES.MAIN_EMS
      } else if (this.state !== this.STATES.MAIN_FIREDEPT && this.mdtJob === '2') {
        this.state = this.STATES.MAIN_FIREDEPT
      } else {
        this.onQuit()
      }
    },
    checkCitizen () {
      const firsname = this.firsname.trim()
      const lastname = this.lastname.trim()
      if (firstname.length !== 0 && lastname.length !== 0) {
        this.mdtCitizenRequest({
          firsname,
          lastname
        })
      }
    },
    checkVehicle () {
      const plate = this.plate
      if (plate.length !== 0) {
        this.mdtVehicleRequest({
          plate
        })
      }
    }
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

/*MAIN PANEL SECTION =========================== */
.main-panel {
  width: 100%;
  height: 100%;
  background: #dbdbdb;
}

.main-info-area {
  width: 100%;
  height: 20%;
  background: #dbdbdb;

  box-shadow: 0px 8px 10px grey;
}

.main-info-area span {
  padding-left: 1%;
  display: block;
}

.logo img {
  float: left;
  width: 30%;
}

.main-button-area {
  width: 100%;
  height: 80%;
  background: #dbdbdb;

  display: block;
  padding: 10px;
}

.main-button-item {
  background-color: #080808;
  color: #dbdbdb;
  padding: 10px;
  font-size: 30px;
  text-align: center;
  box-shadow: 0px 5px 5px grey;

  margin-top: 2%;
}
/*NAMEDB PANEL SECTION ========================= */
.input-area {
  width: 100%;
  height: 35%;
  background: #dbdbdb;

  box-shadow: 0px 8px 10px grey;
}

.result-area {
  width: 100%;
  height: 65%;
  background: #dbdbdb;

  display: block;
  padding: 10px;
}

.result-area table {
  width: 100%;
}

.result-area td {
  border: 2px solid #ad3333;
  text-align: left;
  padding: 8px;
}

.result-area tr:nth-child(even) {
  background-color: #cfcfcf;
}

/*BUTTON DESIGN ================================ */
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
