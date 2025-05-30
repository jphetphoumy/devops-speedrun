<?php 
echo '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Challenge 4</title>
    <style>
        body {
          background-color: #0d1117;
          color: #c9d1d9;
          font-family: monospace;
          display: flex;
          flex-direction: column;
          align-items: center;
          justify-content: center;
          height: 100vh;
          margin: 0;
        }
    
        .container {
          border: 2px dashed #58a6ff;
          padding: 2rem;
          max-width: 600px;
          text-align: center;
          background-color: #161b22;
          box-shadow: 0 0 20px rgba(88, 166, 255, 0.2);
        }
    
        h1 {
          color: #58a6ff;
          margin-bottom: 1rem;
        }
    
        p {
          margin: 0.5rem 0;
        }
    
        .flag {
          margin-top: 1.5rem;
          font-weight: bold;
          font-size: 1.1rem;
          color: #3fb950;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Challenge 4 Complete!</h1>
        <p>You have set up basic authentication.</p>
        <div class="flag">
            Flag: CTF{BASIC_AUTH_SECURES_YOUR_CONTENT}
        </div>
    </div>
</body>
</html>';
?>
