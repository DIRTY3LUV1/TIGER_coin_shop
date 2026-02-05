// Объявляем переменные и ключи
const usersKey = 'users';
const sessionKey = 'currentUser';

// Объекты для обработки элементов
const showRegisterBtn = document.getElementById('show-register');
const showLoginBtn = document.getElementById('show-login');
const registerForm = document.getElementById('register-form');
const loginForm = document.getElementById('login-form');
const mainSection = document.getElementById('main-section');

const registerBtn = document.getElementById('register-btn');
const loginBtn = document.getElementById('login-btn');

const closeButtons = document.querySelectorAll('.close-btn');

const userNameSpan = document.getElementById('user-name');
const userBalanceSpan = document.getElementById('user-balance');
const walletBalanceSpan = document.getElementById('wallet-balance');

const promoCodeInput = document.getElementById('promo-code');
const applyPromoBtn = document.getElementById('apply-promo');
const promoMessage = document.getElementById('promo-message');

const logoutBtn = document.getElementById('logout-btn');

const tabButtons = document.querySelectorAll('.tabbtn');
const tabContents = document.querySelectorAll('.tabcontent');

// Показывать/скрывать элементы
function showElement(el) { el.classList.remove('hidden'); }
function hideElement(el) { el.classList.add('hidden'); }

// Работа с пользователями
function getUsers() {
    const data = localStorage.getItem(usersKey);
    return data ? JSON.parse(data) : {};
}
function saveUsers(users) {
    localStorage.setItem(usersKey, JSON.stringify(users));
}
function getCurrentUser() {
    const user = localStorage.getItem(sessionKey);
    return user ? JSON.parse(user) : null;
}
function setCurrentUser(user) {
    localStorage.setItem(sessionKey, JSON.stringify(user));
}
function clearCurrentUser() {
    localStorage.removeItem(sessionKey);
}

// Регистрация
document.getElementById('show-register').onclick = () => {
    hideElement(document.getElementById('auth-section'));
    showElement(registerForm);
};
document.querySelectorAll('.close-btn').forEach(btn => {
    btn.onclick = () => {
        hideElement(registerForm);
        hideElement(loginForm);
        showElement(document.getElementById('auth-section'));
    };
});
document.getElementById('register-btn').onclick = () => {
    const username = document.getElementById('register-username').value.trim();
    const password = document.getElementById('register-password').value.trim();
    if (!username || !password) {
        alert('Пожалуйста, заполните все поля.');
        return;
    }
    const users = getUsers();
    if (users[username]) {
        alert('Этот пользователь уже есть! Попробуйте другое имя.');
        return;
    }
    users[username] = { password, balance: 0, walletBalance: 0 };
    saveUsers(users);
    alert('Регистрация успешна! Войдите в систему.');
    hideElement(registerForm);
    showElement(document.getElementById('auth-section'));
};

// Вход
document.getElementById('show-login').onclick = () => {
    hideElement(document.getElementById('auth-section'));
    showElement(loginForm);
};
document.getElementById('login-btn').onclick = () => {
    const username = document.getElementById('login-username').value.trim();
    const password = document.getElementById('login-password').value.trim();
    const users = getUsers();
    if (users[username] && users[username].password === password) {
        setCurrentUser({ username });
        loadUserData();
        hideElement(loginForm);
        showElement(mainSection);
    } else {
        alert('Неверное имя или пароль.');
    }
};

// Выход
document.getElementById('logout-btn').onclick = () => {
    clearCurrentUser();
    hideElement(mainSection);
    showElement(document.getElementById('auth-section'));
};

// Загрузка данных пользователя
function loadUserData() {
    const user = getCurrentUser();
    if (!user) return;
    const users = getUsers();
    const data = users[user.username];
    userNameSpan.textContent = user.username;
    userBalanceSpan.textContent = data.balance;
    walletBalanceSpan.textContent = data.walletBalance;
}

// Вкладки
tabButtons.forEach(btn => {
    btn.onclick = () => {
        document.querySelectorAll('.tabbtn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');

        const tab = btn.dataset.tab;
        document.querySelectorAll('.tabcontent').forEach(tc => {
            tc.style.display = (tc.id === tab) ? 'block' : 'none';
        });
    };
});

// Обработка промокода
applyPromoBtn.onclick = () => {
    const code = promoCodeInput.value.trim().toUpperCase();
    const user = getCurrentUser();
    if (!user) return;
    const users = getUsers();
    const userData = users[user.username];

    // Пример промокода
    if (code === 'TIGR100') {
        const bonus = 100;
        userData.walletBalance += bonus;
        users[user.username] = userData;
        saveUsers(users);
        loadUserData();
        promoMessage.textContent = `Ура! Вы получили +${bonus} Тигр Коин!`;
    } else {
        promoMessage.textContent = 'Некорректный промокод.';
    }
};

// Авто-загрузка при запуске
window.onload = () => {
    const user = getCurrentUser();
    if (user) {
        loadUserData();
        showElement(mainSection);
    }
};
