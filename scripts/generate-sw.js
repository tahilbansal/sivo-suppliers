const fs = require('fs');

// Read the template
let swTemplate = fs.readFileSync('web/firebase-messaging-sw.template.js', 'utf8');

// Replace placeholders with environment variables
swTemplate = swTemplate
    .replace('{{FIREBASE_API_KEY}}', process.env.FIREBASE_API_KEY)
    .replace('{{FIREBASE_AUTH_DOMAIN}}', process.env.FIREBASE_AUTH_DOMAIN)
    .replace('{{FIREBASE_DATABASE_URL}}', process.env.FIREBASE_DATABASE_URL)
    .replace('{{FIREBASE_PROJECT_ID}}', process.env.FIREBASE_PROJECT_ID)
    .replace('{{FIREBASE_STORAGE_BUCKET}}', process.env.FIREBASE_STORAGE_BUCKET)
    .replace('{{FIREBASE_MESSAGING_SENDER_ID}}', process.env.FIREBASE_MESSAGING_SENDER_ID)
    .replace('{{FIREBASE_APP_ID}}', process.env.FIREBASE_APP_ID)
    .replace('{{FIREBASE_MEASUREMENT_ID}}', process.env.FIREBASE_MEASUREMENT_ID);

// Write to the output file
fs.writeFileSync('web/firebase-messaging-sw.js', swTemplate);
console.log('firebase-messaging-sw.js generated successfully.');
