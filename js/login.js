// Login Form Validation and Handling

// Sample user credentials for demo (in real app, this would be server-side)
const demoUsers = [
    { email: 'user@example.com', password: 'password123' },
    { email: 'admin@example.com', password: 'admin123' },
    { email: 'test@example.com', password: 'test123' }
];

function handleLogin(event) {
    event.preventDefault();
    
    // Get form elements
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const rememberInput = document.getElementById('remember');
    const emailError = document.getElementById('emailError');
    const passwordError = document.getElementById('passwordError');
    const loginForm = document.getElementById('loginForm');
    
    // Reset error messages
    emailError.textContent = '';
    passwordError.textContent = '';
    emailError.classList.remove('show');
    passwordError.classList.remove('show');
    emailInput.classList.remove('error');
    passwordInput.classList.remove('error');
    
    // Get values
    const email = emailInput.value.trim();
    const password = passwordInput.value.trim();
    
    // Validation flags
    let isValid = true;
    
    // Email validation
    if (!email) {
        emailError.textContent = 'Email is required';
        emailError.classList.add('show');
        emailInput.classList.add('error');
        isValid = false;
    } else if (!isValidEmail(email)) {
        emailError.textContent = 'Please enter a valid email address';
        emailError.classList.add('show');
        emailInput.classList.add('error');
        isValid = false;
    }
    
    // Password validation
    if (!password) {
        passwordError.textContent = 'Password is required';
        passwordError.classList.add('show');
        passwordInput.classList.add('error');
        isValid = false;
    } else if (password.length < 6) {
        passwordError.textContent = 'Password must be at least 6 characters';
        passwordError.classList.add('show');
        passwordInput.classList.add('error');
        isValid = false;
    }
    
    // If valid, check credentials
    if (isValid) {
        // Check if user exists in demo users
        const user = demoUsers.find(u => u.email === email && u.password === password);
        
        if (user) {
            // Login successful
            showSuccessMessage(email, rememberInput.checked);
            
            // Store login info if remember me is checked
            if (rememberInput.checked) {
                localStorage.setItem('rememberedEmail', email);
                localStorage.setItem('isLoggedIn', 'true');
            }
            
            // Reset form
            loginForm.reset();
            
            // Redirect after 2 seconds
            setTimeout(() => {
                window.location.href = 'index.html';
            }, 2000);
        } else {
            // Invalid credentials
            showErrorAlert('Invalid email or password. Please try again.');
            passwordInput.classList.add('error');
            passwordError.textContent = 'Invalid credentials';
            passwordError.classList.add('show');
        }
    }
}

// Email validation helper function
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

// Show success message
function showSuccessMessage(email, rememberMe) {
    const loginBox = document.querySelector('.login-box');
    const successMessage = document.createElement('div');
    successMessage.className = 'success-message show';
    successMessage.innerHTML = `
        <strong>✓ Login Successful!</strong><br>
        Welcome back, <strong>${email.split('@')[0]}</strong>!<br>
        <small>Redirecting to home page...</small>
    `;
    
    // Remove any existing success messages
    const existingSuccess = loginBox.querySelector('.success-message');
    if (existingSuccess) {
        existingSuccess.remove();
    }
    
    loginBox.insertBefore(successMessage, loginBox.firstChild);
    
    // Also log to console for demo purposes
    console.log(`✓ User logged in: ${email}`, { rememberMe: rememberMe });
}

// Show error alert
function showErrorAlert(message) {
    alert(message);
}

// Real-time email validation on blur
document.addEventListener('DOMContentLoaded', function() {
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const emailError = document.getElementById('emailError');
    const passwordError = document.getElementById('passwordError');
    
    // Check if user was previously logged in
    if (localStorage.getItem('isLoggedIn') === 'true') {
        const rememberedEmail = localStorage.getItem('rememberedEmail');
        if (rememberedEmail && emailInput) {
            emailInput.value = rememberedEmail;
        }
    }
    
    // Email blur validation
    if (emailInput) {
        emailInput.addEventListener('blur', function() {
            if (this.value && !isValidEmail(this.value)) {
                emailError.textContent = 'Please enter a valid email address';
                emailError.classList.add('show');
                this.classList.add('error');
            } else {
                emailError.classList.remove('show');
                this.classList.remove('error');
            }
        });
        
        // Clear error on focus
        emailInput.addEventListener('focus', function() {
            emailError.classList.remove('show');
            this.classList.remove('error');
        });
    }
    
    // Password length validation
    if (passwordInput) {
        passwordInput.addEventListener('blur', function() {
            if (this.value && this.value.length < 6) {
                passwordError.textContent = 'Password must be at least 6 characters';
                passwordError.classList.add('show');
                this.classList.add('error');
            } else {
                passwordError.classList.remove('show');
                this.classList.remove('error');
            }
        });
        
        // Clear error on focus
        passwordInput.addEventListener('focus', function() {
            passwordError.classList.remove('show');
            this.classList.remove('error');
        });
    }
    
    // Add event listener to show/hide password toggle (if you add it)
    const passwordToggle = document.getElementById('passwordToggle');
    if (passwordToggle) {
        passwordToggle.addEventListener('change', function() {
            const type = this.checked ? 'text' : 'password';
            passwordInput.type = type;
        });
    }
});

// Logout functionality
function logout() {
    localStorage.removeItem('isLoggedIn');
    localStorage.removeItem('rememberedEmail');
    console.log('User logged out');
    alert('You have been logged out successfully!');
    window.location.href = 'login.html';
}

// Demo credentials display (for testing)
function showDemoCredentials() {
    console.log('Demo Credentials:');
    console.log('================');
    demoUsers.forEach((user, index) => {
        console.log(`${index + 1}. Email: ${user.email}, Password: ${user.password}`);
    });
}

// Toggle password visibility
function togglePasswordVisibility() {
    const passwordInput = document.getElementById('password');
    const toggleIcon = document.getElementById('toggleIcon');
    
    if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        toggleIcon.textContent = '🙈';
    } else {
        passwordInput.type = 'password';
        toggleIcon.textContent = '👁️';
    }
}

// Call demo credentials on page load
showDemoCredentials();

console.log('Login functionality loaded successfully');
