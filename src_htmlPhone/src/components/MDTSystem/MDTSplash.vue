<template>
  <div class="splash">
    <img src="/html/static/img/app_mdt/login_screen.png">
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  computed: {
    ...mapGetters(['mdtAccount']),
    isLogin () {
      return this.mdtAccount.username !== undefined && this.mdtAccount.username !== ''
    }
  },
  created: function () {
    setTimeout(() => {
      if (this.isLogin) {
        this.$router.push({ name: 'mdt.dashboard' })
      } else {
        this.$router.push({ name: 'mdt' })
      }
    }, 500)
  }
}
</script>

<style scoped>
  .splash{
    width: 100%;
    height: 100%;
    background-color: white; /*#1da1f2;*/
    display: flex;
    justify-content: center;
    align-items: center;
  }
  img {
    width: 80px;
    animation-name: zoom;
    animation-duration: 0.35s;
    animation-fill-mode: forwards;
  }
  @keyframes zoom {
    from {width: 180px;}
      to {width: 250px;}
  }
</style>
