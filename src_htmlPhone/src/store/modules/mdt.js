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
  mdtCitID: localStorage['gcphone_mdt_CitID']
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
  mdtCitID: ({ mdtCitID }) => mdtCitID
}

const actions = {
  mdtLoginRequest (state, { username, password }) {
    PhoneAPI.mdtLoginRequest(username, password)
  },
  mdtLog (state, { message }) {
    console.log('Log: ' + message)
  },
  mdtCitizenRequest (state, {firstname, lastname}) {
    PhoneAPI.mdtCitizenRequest(firstname, lastname)
    console.log('First Name: ' + firstname + ', Surname: ' + lastname)
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
    localStorage['gcphone_mdt_CitSex'] = data.sex
    localStorage['gcphone_mdt_CitHeight'] = data.height
    localStorage['gcphone_mdt_CitID'] = data.identifier
    commit('UPDATE_CITIZEN', data)
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
    state.mdtCitSex = sex
    state.mdtCitHeight = height
    state.mdtCitID = identifier
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}
