import './../style/style.scss';

import Vue from 'vue';
import App from './../vue/index.vue'
import VueNativeSock from 'vue-native-websocket';

Vue.use(VueNativeSock,'ws://localhost:3000', {
  format: 'json',
  reconnection: true,
  reconnectionAttempts: 5,
  reconnectionDelay: 3000,
});

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    render: h => h(App),
  }).$mount('#app');
});
