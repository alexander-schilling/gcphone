import PhoneAPI from './../../PhoneAPI'
// const LOCAL_NAME = 'gc_mdt'

const state = {
  mdtUsername: localStorage['gcphone_mdt_username'],
  mdtPassword: localStorage['gcphone_mdt_password']
}

const getters = {
  mdtUsername: ({ mdtUsername }) => mdtUsername,
  mdtPassword: ({ mdtPassword }) => mdtPassword
}

const actions = {
  mdtLoginRequest (state, { username, password }) {
    PhoneAPI.mdtLoginRequest(username, password)
    console.log('Username ' + username + ', Password: ' + password)
  },
  mdtLogin ({ commit }, data) {
    localStorage['gcphone_mdt_username'] = data.username
    localStorage['gcphone_mdt_password'] = data.password
    commit('UPDATE_ACC', data)
  }
}

const mutations = {
  UPDATE_ACC (state, { username, password }) {
    state.mdtUsername = username
    state.mdtPassword = password
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}
