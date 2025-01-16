importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js');

firebase.initializeApp({
    apiKey: "AIzaSyDa12MRCZSQUlNCg9hcy3XGm9Dk1AWC07Y",
    authDomain: "rivus-flutter.firebaseapp.com",
    databaseURL: "https://rivus-flutter-default-rtdb.asia-southeast1.firebasedatabase.app",
    projectId: "rivus-flutter",
    storageBucket: "rivus-flutter.appspot.com",
    messagingSenderId: "615943697958",
    appId: "1:615943697958:web:a4171a969ee78012b618e7",
    measurementId: "G-SQ1BE51PK1"
});

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
