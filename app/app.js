const express = require('express');
const os = require('os');

const app = express();

// Environment Variables
const PORT = process.env.PORT || 3000;
const APP_VERSION = process.env.APP_VERSION || "1.0.0";

// Middleware
app.use(express.json());

// Root Route
app.get('/', (req, res) => {
    res.json({
        message: "🚀 CI/CD Application Deployed Successfully!",
        version: APP_VERSION,
        hostname: os.hostname(),
        timestamp: new Date().toISOString()
    });
});

// Health Check (Very Important for Kubernetes)
app.get('/health', (req, res) => {
    res.status(200).json({
        status: "UP",
        uptime: process.uptime()
    });
});

// Info Route
app.get('/info', (req, res) => {
    res.json({
        app: "EKS CI/CD Demo App",
        environment: process.env.NODE_ENV || "development",
        container: os.hostname()
    });
});

// Start Server
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});