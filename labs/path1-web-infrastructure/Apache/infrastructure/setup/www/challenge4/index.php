<?php
$valid_user = 'admin';
$valid_pass = 'SuperPassword';

$authenticated = isset($_SERVER['PHP_AUTH_USER']) &&
                 $_SERVER['PHP_AUTH_USER'] === $valid_user &&
                 $_SERVER['PHP_AUTH_PW'] === $valid_pass;
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Validator Access</title>
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
      border: 2px dashed <?php echo $authenticated ? '#ff7b72' : '#f0ad4e'; ?>;
      padding: 2rem;
      max-width: 600px;
      text-align: center;
      background-color: #161b22;
      box-shadow: 0 0 20px rgba(255, 123, 114, 0.2);
    }

    h1 {
      color: <?php echo $authenticated ? '#ff7b72' : '#f0ad4e'; ?>;
      margin-bottom: 1rem;
    }

    p {
      margin: 0.5rem 0;
    }

    .flag {
      margin-top: 1.5rem;
      font-weight: bold;
      font-size: 1.1rem;
      color: #58a6ff;
    }
  </style>
</head>
<body>
  <div class="container">
    <?php if ($authenticated): ?>
      <h1>Access Granted</h1>
      <p>Welcome, authenticated DevOps warrior.</p>
      <p>You’ve successfully passed the Basic Auth validation challenge.</p>
      <div class="flag">
        Here's your flag: CTF{BASIC_AUTH_FTW}
      </div>
    <?php else: ?>
      <h1>Setup the Basic auth configuration</h1>
      <p>This page need to be protected with HTTP Basic Auth.</p>
      <p>Please Create the configuration to setup basic auth. Username should be admin and password SuperPassword</p>
      <div class="flag">
        Hint: Use <code>admin</code> <code>SuperPassword</code>
      </div>
    <?php endif; ?>
  </div>
</body>
</html>