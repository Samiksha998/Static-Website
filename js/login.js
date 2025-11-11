// Login Form Validation and Handling

function handleLogin(event) {
    event.preventDefault();
    
    // Get form elements
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const emailError = document.getElementById('emailError');
    const passwordError = document.getElementById('passwordError');
    
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
    
    // If valid, show success message
    if (isValid) {
        showSuccessMessage(email);
        setTimeout(() => {
            // In a real app, you would send credentials to server
            // For demo, just reset the form
            document.getElementById('loginForm').reset();
            // Redirect to home page after 2 seconds
            setTimeout(() => {
                window.location.href = 'index.html';
            }, 2000);
        }, 1500);
    }
}

// Email validation helper function
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

// Show success message
function showSuccessMessage(email) {
    const loginBox = document.querySelector('.login-box');
    const successMessage = document.createElement('div');
    successMessage.className = 'success-message show';
    successMessage.innerHTML = `
        <strong>Welcome back!</strong><br>
        Login successful for ${email}. Redirecting...
    `;
    loginBox.insertBefore(successMessage, loginBox.firstChild);
}

// Real-time email validation on blur
document.addEventListener('DOMContentLoaded', function() {
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const emailError = document.getElementById('emailError');
    const passwordError = document.getElementById('passwordError');
    
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
});

console.log('Login functionality loaded');
