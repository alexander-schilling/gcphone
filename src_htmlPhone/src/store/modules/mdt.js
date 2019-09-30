// import PhoneAPI from './../../PhoneAPI'
// const LOCAL_NAME = 'gc_mdt'

const state = {
  mdtInfo: []
}

const getters = {
  mdtInfo: ({ mdtInfo }) => mdtInfo
}

const actions = {
  loginRequest (state, { username, password }) {
    console.log(username)
  }
}

const mutations = {

}

export default {
  state,
  getters,
  actions,
  mutations
}
