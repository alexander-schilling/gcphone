import PhoneAPI from './../../PhoneAPI'

const state = {
  mdtUsername: localStorage['gcphone_mdt_username'],
  mdtPassword: localStorage['gcphone_mdt_password'],
  mdtJob: localStorage['gcphone_mdt_job'],
  mdtID: localStorage['gcphone_mdt_ID'],
  mdtAdmin: localStorage['gcphone_mdt_Admin'],
  mdtCitName: localStorage['gcphone_mdt_CitName'],
  mdtCitSurName: localStorage['gcphone_mdt_CitSurName'],
  mdtCitDOB: localStorage['gcphone_mdt_CitDOB'],
  mdtCitSex: localStorage['gcphone_mdt_CitSex'],
  mdtCitHeight: localStorage['gcphone_mdt_CitHeight'],
  mdtCitID: localStorage['gcphone_mdt_CitID'],
  mdtVehPlate: localStorage['gcphone_mdt_VehPlate'],
  mdtVehModel: localStorage['gcphone_mdt_VehModel'],
}

const getters = {
  mdtUsername: ({ mdtUsername }) => mdtUsername,
  mdtPassword: ({ mdtPassword }) => mdtPassword,
  mdtJob: ({ mdtJob }) => mdtJob,
  mdtID: ({ mdtID }) => mdtID,
  mdtAdmin: ({ mdtAdmin }) => mdtAdmin,
  mdtCitName: ({ mdtCitName }) => mdtCitName,
  mdtCitSurName: ({ mdtCitSurName }) => mdtCitSurName,
  mdtCitDOB: ({ mdtCitDOB }) => mdtCitDOB,
  mdtCitSex: ({ mdtCitSex }) => mdtCitSex,
  mdtCitHeight: ({ mdtCitHeight }) => mdtCitHeight,
  mdtCitID: ({ mdtCitID }) => mdtCitID,
  mdtVehPlate: ({ mdtVehPlate }) => mdtVehPlate,
  mdtVehModel: ({ mdtVehModel }) => mdtVehModel
}

const actions = {
  mdtLoginRequest (state, { username, password }) {
    PhoneAPI.mdtLoginRequest(username, password)
  },
  mdtCitizenRequest (state, {firstname, lastname}) {
    PhoneAPI.mdtCitizenRequest(firstname, lastname)
    console.log('First Name: ' + firstname + ', Surname: ' + lastname)
  },
  mdtVehicleRequest (state {}) {
    PhoneAPI.mdtVehicleRequest(plate)
  },
  mdtLog (state, { message }) {
    console.log('Log: ' + message)
  },
  mdtLogin ({ commit }, data) {
    localStorage['gcphone_mdt_username'] = data.username
    localStorage['gcphone_mdt_password'] = data.password
    localStorage['gcphone_mdt_job'] = data.work
    localStorage['gcphone_mdt_ID'] = data.id
    localStorage['gcphone_mdt_Admin'] = data.adminlevel
    commit('UPDATE_ACC', data)
  },
  mdtUpdateCitizen ({ commit }, data) {
    localStorage['gcphone_mdt_CitName'] = data.firstname
    localStorage['gcphone_mdt_CitSurName'] = data.lastname
    localStorage['gcphone_mdt_CitDOB'] = data.dateofbirth
    if (data.sex === 'm') {
      localStorage['gcphone_mdt_CitSex'] = 'Male'
    } else {
      localStorage['gcphone_mdt_CitSex'] = 'Female'
    }
    localStorage['gcphone_mdt_CitHeight'] = data.height
    localStorage['gcphone_mdt_CitID'] = data.identifier
    commit('UPDATE_CITIZEN', data)
  },
  mdtUpdateVehicle ({ commit }, data) {
    localStorage['gcphone_mdt_CitName'] = data.firstname
    localStorage['gcphone_mdt_CitSurName'] = data.lastname
    localStorage['gcphone_mdt_VehPlate'] = data.plate
    localStorage['gcphone_mdt_VehModel'] = data.model
    commit('UPDATE_VEHICLE', data)
  }
}

const mutations = {
  UPDATE_ACC (state, { username, password, work, id, adminlevel }) {
    state.mdtUsername = username
    state.mdtPassword = password
    state.mdtJob = work
    state.mdtID = id
    state.mdtAdmin = adminlevel
  },
  UPDATE_CITIZEN (state, {firstname, lastname, dateofbirth, sex, height, identifier}) {
    state.mdtCitName = firstname
    state.mdtCitSurName = lastname
    state.mdtCitDOB = dateofbirth
    if (sex === 'm') {
      state.mdtCitSex = 'Male'
    } else {
      state.mdtCitSex = 'Female'
    }
    state.mdtCitHeight = height
    state.mdtCitID = identifier
  },
  UPDATE_VEHICLE(state, {firstname, lastname, plate, model}) {
    state.mdtCitName = firstname
    state.mdtCitSurName = lastname
    state.mdtVehPlate = plate
    state.mdtVehModel = model
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}
