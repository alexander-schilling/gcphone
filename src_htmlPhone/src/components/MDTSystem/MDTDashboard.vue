<template>
  <div class="phone_app">
    <PhoneTitle :title="IntlString('APP_MDTSYSTEM_DASHBOARD_TITLE')" @back="onQuit"/>
    <template v-if="state === STATES.MAIN_POLICE">
      <div class="main-panel">
        <div class="main-info-area">
          <div class="logo">
            <img src="/html/static/img/app_mdt/police.png" alt="">
          </div>
          <span>Username: {{ mdtAccount.username }}</span>
          <span>Account ID: {{ mdtAccount.id }}</span>
          <span>Admin Level: {{ mdtAccount.adminlevel }}</span>
        </div>
        <div class="main-button-area">

          <div class="group main-button-item" data-type="button" @click.stop="state = STATES.MANAGE_ACCOUNT">
              <input type='button' class="mainBtn" @click.stop="state = STATES.MANAGE_ACCOUNT" value="Manage Account" />
              <span class="bar"></span>
          </div>

          <div class="group main-button-item" data-type="button" @click.stop="state = STATES.JOBS_MENU">
            <input type='button' class="mainBtn" @click.stop="state = STATES.JOBS_MENU" value="Jobs" />
            <span class="bar"></span>
          </div>

          <div class="group main-button-item" data-type="button" @click.stop="state = STATES.NAME_DATABASE">
            <input type='button' class="mainBtn" @click.stop="state = STATES.NAME_DATABASE" value="Name Database" />
            <span class="bar"></span>
          </div>

          <div class="group main-button-item" data-type="button" @click.stop="state = STATES.VEHICLE_DATABASE">
            <input type='button' class="mainBtn" @click.stop="state = STATES.VEHICLE_DATABASE" value="Plate Database" />
            <span class="bar"></span>
          </div>

          <div v-if="isAdmin" class="main-button-item" data-type="button" @click.stop="state = STATES.ADMIN_VIEW">
            <input type='button' class="mainBtn" @click.stop="state = STATES.ADMIN_VIEW" value="Admin" />
            <span class="bar"></span>
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
          <span>Username: {{ mdtAccount.username }}</span>
          <span>Account ID: {{ mdtAccount.id }}</span>
          <span>Admin Level: {{ mdtAccount.adminlevel }}</span>
        </div>
        <div class="main-button-area">

          <div class="group main-button-item" data-type="button" @click.stop="state = STATES.MANAGE_ACCOUNT">
              <input type='button' class="mainBtn" @click.stop="state = STATES.MANAGE_ACCOUNT" value="Manage Account" />
              <span class="bar"></span>
          </div>

          <div class="group main-button-item" data-type="button" @click.stop="state = STATES.JOBS_MENU">
            <input type='button' class="mainBtn" @click.stop="state = STATES.JOBS_MENU" value="Jobs" />
            <span class="bar"></span>
          </div>

          <div class="group main-button-item" data-type="button" @click.stop="state = STATES.NAME_DATABASE">
            <input type='button' class="mainBtn" @click.stop="state = STATES.NAME_DATABASE" value="Name Database" />
            <span class="bar"></span>
          </div>

          <div v-if="isAdmin" class="main-button-item" data-type="button" @click.stop="state = STATES.ADMIN_VIEW">
            <input type='button' class="mainBtn" @click.stop="state = STATES.ADMIN_VIEW" value="Admin" />
            <span class="bar"></span>
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
          <span>Username: {{ mdtAccount.username }}</span>
          <span>Account ID: {{ mdtAccount.id }}</span>
          <span>Admin Level: {{ mdtAccount.adminlevel }}</span>
        </div>
        <div class="main-button-area">

          <div class="group main-button-item" data-type="button" @click.stop="state = STATES.MANAGE_ACCOUNT">
              <input type='button' class="mainBtn" @click.stop="state = STATES.MANAGE_ACCOUNT" value="Manage Account" />
              <span class="bar"></span>
          </div>

          <div class="group main-button-item" data-type="button" @click.stop="state = STATES.JOBS_MENU">
            <input type='button' class="mainBtn" @click.stop="state = STATES.JOBS_MENU" value="Jobs" />
            <span class="bar"></span>
          </div>

          <div v-if="isAdmin" class="main-button-item" data-type="button" @click.stop="state = STATES.ADMIN_VIEW">
            <input type='button' class="mainBtn" @click.stop="state = STATES.ADMIN_VIEW" value="Admin" />
            <span class="bar"></span>
          </div>

        </div>
      </div>
    </template>

    <template v-else-if="state === STATES.NAME_DATABASE">
      <div class="main-panel">
        <div class="input-area">
          <div class="group inputText" data-type="text" data-maxlength='64' data-defaultValue="First Name">
            <input type="text" :placeholder="IntlString('APP_USER_NAME_LABEL')" v-model="firstname">
            <span class="bar"></span>
          </div>

          <div class="group inputText" data-type="text" data-maxlength='64' data-defaultValue="Last Name">
            <input type="text" :placeholder="IntlString('APP_USER_SURNAME_LABEL')" v-model="surname">
            <span class="bar"></span>
          </div>

          <div class="group" data-type="button" @click.stop="checkCitizen">
            <input type='button' class="btn" @click.stop="checkCitizen" value="Lookup" />
            <span class="bar"></span>
          </div>

        </div>
        <div class="result-area">
          <table>
            <tr>
              <td>Name</td>
              <td>{{ mdtCitizen.firstname }} {{ mdtCitizen.lastname }}</td>
            </tr>
            <tr>
              <td>Date Of Birth</td>
              <td>{{ mdtCitizen.dateofbirth }}</td>
            </tr>
            <tr>
              <td>Sex</td>
              <td>{{ mdtCitizen.sex }}</td>
            </tr>
            <tr>
              <td>Height</td>
              <td>{{ mdtCitizen.height }}</td>
            </tr>
            <tr>
              <td>Licenses</td>
              <td>{{ mdtCitizen.license }}</td>
            </tr>
            <tr>
              <td>Criminal Records</td>
              <td>WIP</td>
            </tr>
          </table>
          {{ mdtCitizen.id }}
        </div>
      </div>
    </template>

    <template v-else-if="state === STATES.VEHICLE_DATABASE">
      <div class="main-panel">
        <div class="main-panel">
          <div class="input-area">

            <div class="group inputText" data-type="text" data-maxlength='64' data-defaultValue="First Name">
              <input type="text" :placeholder="IntlString('APP_VEHICLE_PLATE_LABEL')" v-model="plate">
              <span class="bar"></span>
            </div>

            <div class="group" data-type="button" @click.stop="checkVehicle">
              <input type='button' class="btn" @click.stop="checkVehicle" value="Lookup" />
              <span class="bar"></span>
            </div>

          </div>
          <div class="result-area">
            <table>
              <tr>
                <td>Owner</td>
                <td>{{ mdtVehicle.firstname }} {{ mdtVehicle.lastname }}</td>
              </tr>
              <tr>
                <td>Plate</td>
                <td>{{ mdtVehicle.plate }}</td>
              </tr>
              <tr>
                <td>Model</td>
                <td>{{ mdtVehicle.model }}</td>
              </tr>
            </table>
          </div>
        </div>
      </div>
    </template>

    <template v-else-if="state === STATES.JOBS_MENU">
      <div class="job-main-panel">
        <div v-for="job in mdtJobs">
          <div class="jobPanel" v-bind:class="{ assigned: job.isAssigned }">
            <div class="jobtextArea">
              <p>
                ID: {{ job.jobID }} <br>
                Message: {{ job.message }}
              </p>
            </div>
            <div class="jobButtonArea">
              <div class="group" data-type="button" @click.stop="selectJob(job)">
                <input type='button' class="jobBtn" @click.stop="selectJob(job)" value="Take job" />
              </div>

              <div class="group" data-type="button" @click.stop="completeJob(job)">
                <input type='button' class="jobBtn" @click.stop="completeJob(job)" value="Complete" />
              </div>

            </div>
          </div>
        </div>
      </div>
    </template>

    <template v-else-if="state === STATES.ADMIN_VIEW">
      <div class="main-panel">
        Admin View WIP
      </div>
    </template>

    <template v-else-if="state === STATES.MANAGE_ACCOUNT">
      <div class="main-panel">
        Manage Account WIP
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
  MANAGE_ACCOUNT: 7
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
    ...mapGetters(['IntlString', 'useMouse', 'mdtAccount', 'mdtVehicle', 'mdtCitizen', 'mdtJobs']),
    isAdmin () {
      return this.mdtAccount.adminlevel >= 1
    }
  },
  methods: {
    scrollIntoViewIfNeeded () {
      this.$nextTick(() => {
        const elem = this.$el.querySelector('.select')
        if (elem !== null) {
          elem.scrollIntoViewIfNeeded()
        }
      })
    },
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
          select.click()
        }
      }
    },
    onBack () {
      if (this.useMouse === true && document.activeElement.tagName !== 'BODY') return
      this.onQuit()
    },
    onQuit () {
      if (this.state !== this.STATES.MAIN_POLICE && this.mdtAccount.work === '0') {
        this.state = this.STATES.MAIN_POLICE
      } else if (this.state !== this.STATES.MAIN_EMS && this.mdtAccount.work === '1') {
        this.state = this.STATES.MAIN_EMS
      } else if (this.state !== this.STATES.MAIN_FIREDEPT && this.mdtAccount.work === '2') {
        this.state = this.STATES.MAIN_FIREDEPT
      } else {
        this.$router.push({ name: 'mdt' })
      }
      this.mdtResetData()
      this.loadJobs()
    },
    ...mapActions(['mdtLog', 'mdtCitizenRequest', 'mdtVehicleRequest', 'mdtResetData', 'mdtJobsRequest', 'mdtJobSelected', 'mdtJobComplete']),
    checkCitizen () {
      const firstname = this.firstname.trim()
      const lastname = this.surname.trim()
      if (firstname.length !== 0 && lastname.length !== 0) {
        this.mdtCitizenRequest({
          firstname,
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
    },
    selectJob (job) {
      job.isAssigned = true
      const user = this.mdtAccount.username
      this.mdtJobSelected({
        job,
        user
      })
    },
    completeJob (job) {
      console.log('Removing user')
      for (var i = 0; i < this.mdtJobs.length; i++) {
        if (this.mdtJobs[i].jobID === job.jobID) {
          this.mdtJobs.splice(i, 1)
          i--
        }
      }
      this.mdtJobComplete({
        job
      })
    },
    loadJobs () {
      let department = ''
      switch (this.mdtAccount.work) {
        case '0':
          department = 'police'
          break
        case '1':
          department = 'ambulance'
          break
        case '2':
          department = 'firedept'
          break
      }
      this.mdtJobsRequest({ department })
    },
    onLoad () {
      switch (this.mdtAccount.work) {
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
      this.mdtResetData()
      this.loadJobs()
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

.group.main-button-item {
  background-color: #080808;
  color: #dbdbdb;
  height: 70px;
  font-size: 30px;
  text-align: center;
  box-shadow: 0px 5px 5px grey;

  margin-top: 2%;
}

.mainBtn {
  width: 100%;
  height: 65px;
  font-size: 30px;
  background-color: #080808;
  color: #dbdbdb;

  border-style: none;
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

/* JobsPanel =================================== */
.job-main-panel {
  width: 100%;
  background: #dbdbdb;
  overflow-y: auto;
}

.jobPanel {
  background: #ad3333;
  padding: 10px;
  margin-top: 10px;
}

.jobtextArea {
  float: left;
  width: 100%;
}

.jobButtonArea {
  width: 70%;
}

.jobPanel.assigned {
  background: #33ad35;
  padding: 10px;
  margin-top: 10px;
}

.jobBtn {
  background: #161616;
  color: white;
  padding: 8px 20px;
  margin: 8px 0;
  border: none;
  width: 100%;
  height: 48px;
  font-size: 16px;
}

.jobBtn:hover {
  opacity: 0.8;
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
