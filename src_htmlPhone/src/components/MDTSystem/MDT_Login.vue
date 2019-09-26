<template>
  <div class="phone_app">
    <PhoneTitle :title="IntlString('APP_MDTSYSTEM_TITLE')" @back="quit"/>
    <div class="logn_form">

    </div>
  </div>
</template>


<script>
import PhoneTitle from './../PhoneTitle'
export default {

  components: {
    PhoneTitle
  },
  data () {
    return {

    }
  }

}
</script>
