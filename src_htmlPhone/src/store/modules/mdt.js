import PhoneAPI from './../../PhoneAPI'
// const LOCAL_NAME = 'gc_mdt'

const state = {
  mdtUsername: localStorage['gcphone_mdt_username'],
  mdtPassword: localStorage['gcphone_mdt_password']
}

const getters = {
  mdtInfo: ({ mdtInfo }) => mdtInfo
}

const actions = {
  mdtLoginRequest (state, { username, password }) {
    PhoneAPI.mdtLoginRequest(username, password)
    console.log(username)
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
