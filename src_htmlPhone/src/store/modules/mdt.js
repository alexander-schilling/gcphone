import PhoneAPI from './../../PhoneAPI'

const state = {
  mdtAccount: {},
  mdtJobs: [],
  mdtCitizen: {},
  mdtVehicle: {},
  mdtUsers: []
}

const getters = {
  mdtAccount: ({ mdtAccount }) => mdtAccount,
  mdtJobs: ({ mdtJobs }) => mdtJobs,
  mdtCitizen: ({ mdtCitizen }) => mdtCitizen,
  mdtVehicle: ({ mdtVehicle }) => mdtVehicle,
  mdtUsers: ({ mdtUsers }) => mdtUsers
}

const actions = {
  mdtResetData ({ commit }) {
    commit('RESET_DATA', {type: undefined})
  },
  mdtLoginRequest (state, { username, password }) {
    PhoneAPI.mdtLoginRequest(username, password)
  },
  mdtCitizenRequest (state, { firstname, lastname }) {
    PhoneAPI.mdtCitizenRequest(firstname, lastname)
  },
  mdtVehicleRequest (state, { plate }) {
    PhoneAPI.mdtVehicleRequest(plate)
  },
  mdtJobsRequest (state, { department }) {
    PhoneAPI.mdtJobsRequest(department)
  },
  mdtJobSelected (state, { job, user }) {
    PhoneAPI.mdtJobSelected(job, user)
  },
  mdtJobComplete (state, { job }) {
    PhoneAPI.mdtJobRemove(job)
  },
  mdtUpdateAccount (state, { username, password }) {
    PhoneAPI.mdtUpdateAccount(username, password)
  },
  mdtUsersRequest (state, { work, adminlevel }) {
    PhoneAPI.mdtUsersRequest(work, adminlevel)
  },
  mdtResetPassword (state, { user, id }) {
    PhoneAPI.mdtResetPassword(user, id)
  },
  mdtLog (state, { message }) {
    console.log('Log: ' + message)
  },
  mdtLogin ({ commit }, data) {
    var account = {
      username: data.username,
      password: data.password,
      work: data.work,
      id: data.id,
      adminlevel: data.adminlevel
    }
    commit('UPDATE_ACC', account)
  },
  mdtUpdateCitizen ({ commit }, data) {
    var sex_ = ''
    if (data.sex === 'm') {
      sex_ = 'Male'
    } else {
      sex_ = 'Female'
    }
    var citizen = {
      firstname: data.firstname,
      lastname: data.lastname,
      dateofbirth: data.dateofbirth,
      sex: sex_,
      height: data.height,
      identifier: data.identifier,
      license: data.license
    }
    commit('UPDATE_CITIZEN', citizen)
  },
  mdtUpdateVehicle ({ commit }, data) {
    var vehicle = {
      firstname: data.firstname,
      lastname: data.lastname,
      plate: data.plate,
      model: data.model
    }
    commit('UPDATE_VEHICLE', vehicle)
  },
  mdtAddJob ({ commit }, data) {
    var job = {
      message: data.message,
      department: data.department,
      isAssigned: data.isAssigned,
      coordX: data.coordX,
      coordY: data.coordY,
      coordZ: data.coordZ,
      jobID: data.jobID
    }
    commit('MDT_ADD_JOB', job)
  },
  mdtAddUser ({ commit }, data) {
    var user = {
      username: data.username,
      password: data.password,
      work: data.work,
      id: data.id,
      adminlevel: data.adminlevel
    }
    commit('MDT_ADD_USER', user)
  }
}

const mutations = {
  UPDATE_ACC (state, { username, password, work, id, adminlevel }) {
    state.mdtAccount = {
      username: username,
      password: password,
      work: work,
      id: id,
      adminlevel: adminlevel
    }
  },
  UPDATE_CITIZEN (state, { firstname, lastname, dateofbirth, sex, height, identifier, license }) {
    state.mdtCitizen = {
      firstname: firstname,
      lastname: lastname,
      dateofbirth: dateofbirth,
      sex: sex,
      height: height,
      identifier: identifier,
      license: license
    }
  },
  UPDATE_VEHICLE (state, { firstname, lastname, plate, model }) {
    state.mdtVehicle = {
      firstname: firstname,
      lastname: lastname,
      plate: plate,
      model: model
    }
  },
  MDT_ADD_JOB (state, { message, department, isAssigned, coordX, coordY, coordZ, jobID }) {
    state.mdtJobs.unshift({
      message: message,
      department: department,
      isAssigned: isAssigned,
      coordX: coordX,
      coordY: coordY,
      coordZ: coordZ,
      jobID: jobID
    })
  },
  MDT_ADD_USER (state, { username, password, work, id, adminlevel }) {
    state.mdtUsers.unshift({
      username: username,
      password: password,
      work: work,
      id: id,
      adminlevel: adminlevel
    })
  },
  RESET_DATA (state, {type}) {
    state.mdtJobs = []
    state.mdtCitizen = {}
    state.mdtVehicle = {}
    state.mdtUsers = []
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}
