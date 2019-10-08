import PhoneAPI from './../../PhoneAPI'

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
    console.log('mdt.js actions: Username: ' + username + ', Password: ' + password)
    PhoneAPI.mdtLoginRequest(username, password)
  },
  mdtLogin ({ commit }, data) {
    localStorage['gcphone_mdt_username'] = data.username
    localStorage['gcphone_mdt_password'] = data.password
    commit('UPDATE_ACC', data)
    console.log('mdt.js mdtLogin: Username: ' + data.username + ', Password: ' + localStorage['gcphone_mdt_password'])
  }
}

const mutations = {
  UPDATE_ACC (state, { username, password }) {
    state.mdtUsername = username
    state.mdtPassword = password
    this.$router.push({ name: 'mdt.dashboard' })
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}
