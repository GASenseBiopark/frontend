importScripts(
  "https://www.gstatic.com/firebasejs/9.23.0/firebase-app-compat.js"
);
importScripts(
  "https://www.gstatic.com/firebasejs/9.23.0/firebase-messaging-compat.js"
);

const firebaseConfig = {
  apiKey: "AIzaSyAPhq3RUec-l1xkQWY9N8TBC0uOKvwnJSQ",
  authDomain: "gasense-ee5d9.firebaseapp.com",
  projectId: "gasense-ee5d9",
  storageBucket: "gasense-ee5d9.firebasestorage.app",
  messagingSenderId: "389857741035",
  appId: "1:389857741035:web:4d08955f89abb329e096ae",
  measurementId: "G-CP1JPHTD27",
};

// Inicializa o Firebase dentro do Service Worker:
firebase.initializeApp(firebaseConfig);

// Inicializa o Messaging:
const messaging = firebase.messaging();

// (Opcional) Tratamento para mensagens em background:
messaging.onBackgroundMessage(function (payload) {
  console.log(
    "[firebase-messaging-sw.js] Mensagem recebida no background:",
    payload
  );
  // Você pode mostrar uma notificação manual aqui, se quiser:
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: "/logo2.png", // (coloque o seu ícone opcional)
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
