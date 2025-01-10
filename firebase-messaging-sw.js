importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js');

firebase.initializeApp({
    apiKey: "AIzaSyBDp7xn0md_Z9yJgo_x368k71J1F5MLSwU",
    authDomain: "rivus-flutter.firebaseapp.com",
    databaseURL: "https://rivus-flutter-default-rtdb.asia-southeast1.firebasedatabase.app",
    projectId: "rivus-flutter",
    storageBucket: "rivus-flutter.appspot.com",
    messagingSenderId: "615943697958",
    appId: "1:615943697958:web:b6f5fe1a3329adddb618e7",
    measurementId: "G-1VJZM36NLD"
})

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function (payload) {
    console.log('[firebase-messaging-sw.js] Received background message ', payload);
    const notificationTitle = payload.notification.title;
    const notificationOptions = {
        body: payload.notification.body,
        icon: '/firebase-logo.png'
    };

    self.registration.showNotification(notificationTitle, notificationOptions);
});
