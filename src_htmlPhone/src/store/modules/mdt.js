import PhoneAPI from './../../PhoneAPI'

const state = {
  mdtUsername: localStorage['gcphone_mdt_username'],
  mdtPassword: localStorage['gcphone_mdt_password'],
  mdtJob: localStorage['gcphone_mdt_job'],
  mdtID: localStorage['gcphone_mdt_ID'],
  mdtAdmin: localStorage['gcphone_mdt_Admin']
}

const getters = {
  mdtUsername: ({ mdtUsername }) => mdtUsername,
  mdtPassword: ({ mdtPassword }) => mdtPassword,
  mdtJob: ({ mdtJob }) => mdtJob,
  mdtID: ({ mdtID }) => mdtID,
  mdtAdmin: ({ mdtAdmin }) => mdtAdmin
}

const actions = {
  mdtLoginRequest (state, { username, password }) {
    PhoneAPI.mdtLoginRequest(username, password)
  },
  mdtLogin ({ commit }, data) {
    localStorage['gcphone_mdt_username'] = data.username
    localStorage['gcphone_mdt_password'] = data.password
    localStorage['gcphone_mdt_job'] = data.work
    localStorage['gcphone_mdt_ID'] = data.id
    localStorage['gcphone_mdt_Admin'] = data.adminlevel
    commit('UPDATE_ACC', data)

    console.log(localStorage['gcphone_mdt_Admin'])
  }
}

const mutations = {
  UPDATE_ACC (state, { username, password, work, id, adminlevel }) {
    state.mdtUsername = username
    state.mdtPassword = password
    state.mdtJob = work
    state.mdtID = id
    state.mdtAdmin = adminlevel
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}
