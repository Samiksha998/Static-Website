# Static Website

A simple, modern, and responsive static website built with HTML, CSS, and JavaScript.

## 📋 Table of Contents

- [Features](#features)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Customization](#customization)
- [Technologies Used](#technologies-used)
- [Browser Support](#browser-support)
- [License](#license)

## ✨ Features

- **Responsive Design** - Fully responsive layout that works on all devices (desktop, tablet, mobile)
- **Modern Styling** - Clean and professional design with smooth animations
- **Smooth Navigation** - Sticky navbar with smooth scrolling between sections
- **Interactive Elements** - Form validation and dynamic interactions with JavaScript
- **Performance Optimized** - Fast loading times and efficient code
- **Easy to Customize** - Simple structure for quick modifications
- **Cross-browser Compatible** - Works on all modern browsers

## 📁 Project Structure

```
Static-Website/
├── index.html          # Main HTML file with page structure
├── css/
│   └── style.css       # All CSS styling and responsive design
├── js/
│   └── script.js       # JavaScript for interactivity
├── images/             # Directory for images (currently empty)
└── README.md           # This file
```

## 🚀 Getting Started

### Prerequisites
- A modern web browser (Chrome, Firefox, Safari, Edge, etc.)
- A text editor (VS Code, Sublime Text, etc.) for customization

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Samiksha998/Static-Website.git
   cd Static-Website
   ```

2. **Open in browser:**
   - Simply open `index.html` in your web browser
   - Or use a local server for better experience:
     ```bash
     # Using Python 3
     python -m http.server 8000
     
     # Using Python 2
     python -m SimpleHTTPServer 8000
     
     # Using Node.js (if installed)
     npx http-server
     ```
   - Then visit `http://localhost:8000` in your browser

## 💻 Usage

### Sections

1. **Navigation Bar** - Main navigation with links to all sections
2. **Hero Section** - Eye-catching welcome section with call-to-action button
3. **About Section** - Information about the website with feature highlights
4. **Services Section** - Display of available services
5. **Contact Section** - Contact form for user inquiries
6. **Footer** - Social links and copyright information

### Features in Detail

#### Navigation
- Sticky navbar that remains visible while scrolling
- Smooth scroll navigation between sections
- Responsive menu design for mobile devices

#### Hero Section
- Gradient background with animation
- Call-to-action button with smooth scroll functionality

#### Interactive Elements
- Form validation on contact form
- Success message upon form submission
- Smooth animations on scroll

## 🎨 Customization

### Change Colors
Edit the color values in `css/style.css`:
```css
--primary-color: #3498db;    /* Blue */
--dark-color: #2c3e50;        /* Dark gray */
--light-color: #f8f9fa;       /* Light gray */
```

### Update Content
Edit text content in `index.html`:
- Logo: Update the `.logo` div in the navbar
- Headings: Modify `<h1>`, `<h2>` tags
- Paragraphs: Update `<p>` tags
- Links: Change `href` attributes in navigation

### Add Images
1. Place images in the `images/` directory
2. Reference them in HTML:
   ```html
   <img src="images/your-image.jpg" alt="Description">
   ```

### Modify Styling
- Update colors, fonts, and layouts in `css/style.css`
- Add new sections by creating new `<section>` tags
- Apply responsive design using media queries

## 🛠️ Technologies Used

- **HTML5** - Semantic markup and page structure
- **CSS3** - Modern styling, flexbox, grid, and animations
- **JavaScript (Vanilla)** - DOM manipulation and interactivity
- **Responsive Design** - Mobile-first approach with media queries

## 📱 Browser Support

- ✅ Google Chrome (latest)
- ✅ Mozilla Firefox (latest)
- ✅ Safari (latest)
- ✅ Microsoft Edge (latest)
- ✅ Mobile browsers (iOS Safari, Chrome Mobile)

## 📝 File Descriptions

### index.html
- Contains the complete HTML structure
- Includes all sections: navigation, hero, about, services, contact, footer
- Links to CSS and JavaScript files

### css/style.css
- Complete styling for all elements
- Responsive design with media queries for tablets and mobile devices
- Animations and transitions
- Color scheme and typography

### js/script.js
- Smooth scroll functionality
- Form submission handling
- Intersection Observer API for scroll animations
- Event listeners for navigation links

## 🔧 Development Tips

1. **Use browser DevTools** - F12 or right-click → Inspect to debug
2. **Test responsiveness** - Use DevTools device emulation (Ctrl+Shift+M)
3. **Validate HTML** - Use W3C HTML Validator
4. **Optimize images** - Compress images before adding to `images/` folder
5. **Version control** - Use git to track changes: `git add`, `git commit`, `git push`

## 📦 Deployment

### Deploy on GitHub Pages
1. Push your code to GitHub
2. Go to repository Settings
3. Scroll to "GitHub Pages"
4. Select `main` branch as source
5. Your site will be live at `https://Samiksha998.github.io/Static-Website/`

### Deploy on Other Platforms
- **Netlify**: Drag and drop the folder to Netlify
- **Vercel**: Connect your GitHub repository
- **Firebase Hosting**: Follow Firebase deployment guide
- **AWS S3**: Upload files to S3 bucket with static website hosting

## 📄 License

This project is open source and available under the MIT License.

## 👤 Author

**Samiksha Gurav**
- GitHub: [@Samiksha998](https://github.com/Samiksha998)

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to fork and create a pull request.

## 📧 Contact

For questions or suggestions, please reach out through GitHub Issues or contact directly.

---

**Last Updated:** November 11, 2025

Enjoy building with your static website! 🎉
