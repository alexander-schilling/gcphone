import PhoneAPI from './../../PhoneAPI'

const state = {
  mdtUsername: localStorage['gcphone_mdt_username'],
  mdtPassword: localStorage['gcphone_mdt_password'],
  mdtWork: localStorage['gcphone_mdt_work'],
  mdtID: localStorage['gcphone_mdt_ID'],
  mdtAdmin: localStorage['gcphone_mdt_Admin'],
  mdtCitName: localStorage['gcphone_mdt_CitName'],
  mdtCitSurName: localStorage['gcphone_mdt_CitSurName'],
  mdtCitDOB: localStorage['gcphone_mdt_CitDOB'],
  mdtCitSex: localStorage['gcphone_mdt_CitSex'],
  mdtCitHeight: localStorage['gcphone_mdt_CitHeight'],
  mdtCitID: localStorage['gcphone_mdt_CitID'],
  mdtCitLicenses: localStorage['gcphone_mdt_CitLicenses'],
  mdtCitCrimRec: localStorage['gcphone_mdt_CitCrimRec'],
  mdtVehPlate: localStorage['gcphone_mdt_VehPlate'],
  mdtVehModel: localStorage['gcphone_mdt_VehModel'],
  mdtJobs: []
}

const getters = {
  mdtUsername: ({ mdtUsername }) => mdtUsername,
  mdtPassword: ({ mdtPassword }) => mdtPassword,
  mdtWork: ({ mdtWork }) => mdtWork,
  mdtID: ({ mdtID }) => mdtID,
  mdtAdmin: ({ mdtAdmin }) => mdtAdmin,
  mdtCitName: ({ mdtCitName }) => mdtCitName,
  mdtCitSurName: ({ mdtCitSurName }) => mdtCitSurName,
  mdtCitDOB: ({ mdtCitDOB }) => mdtCitDOB,
  mdtCitSex: ({ mdtCitSex }) => mdtCitSex,
  mdtCitHeight: ({ mdtCitHeight }) => mdtCitHeight,
  mdtCitID: ({ mdtCitID }) => mdtCitID,
  mdtCitLicenses: ({ mdtCitLicenses }) => mdtCitLicenses,
  mdtCitCrimRec: ({ mdtCitCrimRec }) => mdtCitCrimRec,
  mdtVehPlate: ({ mdtVehPlate }) => mdtVehPlate,
  mdtVehModel: ({ mdtVehModel }) => mdtVehModel,
  mdtJobs: ({ mdtJobs }) => mdtJobs
}

const actions = {
  mdtResetData ({ commit }) {
    localStorage.removeItem('gcphone_mdt_CitName')
    localStorage.removeItem('gcphone_mdt_CitSurName')
    localStorage.removeItem('gcphone_mdt_CitDOB')
    localStorage.removeItem('gcphone_mdt_CitSex')
    localStorage.removeItem('gcphone_mdt_CitHeight')
    localStorage.removeItem('gcphone_mdt_CitID')
    localStorage.removeItem('gcphone_mdt_CitLicenses')
    localStorage.removeItem('gcphone_mdt_CitCrimRec')
    localStorage.removeItem('gcphone_mdt_VehPlate')
    localStorage.removeItem('gcphone_mdt_VehModel')

    commit('RESET_DATA', {type: undefined})
  },
  mdtLoginRequest (state, { username, password }) {
    PhoneAPI.mdtLoginRequest(username, password)
  },
  mdtCitizenRequest (state, { firstname, lastname }) {
    PhoneAPI.mdtCitizenRequest(firstname, lastname)
    console.log('First Name: ' + firstname + ', Surname: ' + lastname)
  },
  mdtVehicleRequest (state, { plate }) {
    PhoneAPI.mdtVehicleRequest(plate)
  },
  mdtLog (state, { message }) {
    console.log('Log: ' + message)
  },
  mdtLogin ({ commit }, data) {
    localStorage['gcphone_mdt_username'] = data.username
    localStorage['gcphone_mdt_password'] = data.password
    localStorage['gcphone_mdt_work'] = data.work
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
    localStorage['gcphone_mdt_CitLicenses'] = data.license
    commit('UPDATE_CITIZEN', data)
  },
  mdtUpdateVehicle ({ commit }, data) {
    localStorage['gcphone_mdt_CitName'] = data.firstname
    localStorage['gcphone_mdt_CitSurName'] = data.lastname
    localStorage['gcphone_mdt_VehPlate'] = data.plate
    localStorage['gcphone_mdt_VehModel'] = data.model
    commit('UPDATE_VEHICLE', data)
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
    commit('ADD_JOB', job)
  }
}

const mutations = {
  UPDATE_ACC (state, { username, password, work, id, adminlevel }) {
    state.mdtUsername = username
    state.mdtPassword = password
    state.mdtWork = work
    state.mdtID = id
    state.mdtAdmin = adminlevel
  },
  UPDATE_CITIZEN (state, {firstname, lastname, dateofbirth, sex, height, identifier, license}) {
    state.mdtCitName = firstname
    state.mdtCitSurName = lastname
    state.mdtCitDOB = dateofbirth
    if (sex === 'm') {
      state.mdtCitSex = 'Male'
    } else if (sex === 'f') {
      state.mdtCitSex = 'Female'
    } else {
      state.mdtCitSex = undefined
    }
    state.mdtCitHeight = height
    state.mdtCitID = identifier
    state.mdtCitLicenses = license

    console.log('UPDATE_CITIZEN: ' + state.mdtCitName + ' ' + state.mdtCitSurName)
  },
  UPDATE_VEHICLE (state, {firstname, lastname, plate, model}) {
    state.mdtCitName = firstname
    state.mdtCitSurName = lastname
    state.mdtVehPlate = plate
    state.mdtVehModel = model
  },
  MDT_ADD_JOB (state, {message, department, isAssigned, coordX, coordY, coordZ, jobID}) {
    console.log('Commit stage: ' + message)

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
  RESET_DATA (state, {type}) {
    state.mdtCitName = type
    state.mdtCitSurName = type
    state.mdtCitDOB = type
    state.mdtCitSex = type
    state.mdtCitHeight = type
    state.mdtCitID = type
    state.mdtCitLicenses = type
    state.mdtCitCrimRec = type
    state.mdtVehPlate = type
    state.mdtVehModel = type
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}
