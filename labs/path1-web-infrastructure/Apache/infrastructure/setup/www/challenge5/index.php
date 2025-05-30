<?php
// Check that user accessed this via /getflag (i.e. via rewrite)
$uri = $_SERVER['REQUEST_URI'];
$rewritten = ($uri === '/getflag');
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>URL Rewrite Challenge</title>
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
      border: 2px dashed <?php echo $rewritten ? '#3fb950' : '#f0ad4e'; ?>;
      padding: 2rem;
      max-width: 600px;
      text-align: center;
      background-color: #161b22;
      box-shadow: 0 0 20px rgba(63, 185, 80, 0.2);
    }

    h1 {
      color: <?php echo $rewritten ? '#3fb950' : '#f0ad4e'; ?>;
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
    <?php if ($rewritten): ?>
      <h1>Rewrite Success!</h1>
      <p>You correctly rewrote <code>/getflag</code> to <code>flag.php</code>.</p>
      <div class="flag">Here's your flag: CTF{REWRITE_SUCCESS}</div>
    <?php else: ?>
      <h1>Rewrite Not Detected</h1>
      <p>This page must be accessed via <code>/getflag</code> using an Apache rewrite rule.</p>
      <p>Please setup a RewriteRule so <code>/getflag</code> redirects to <code>flag.php</code>.</p>
      <div class="flag">Hint: Use <code>RewriteRule ^getflag$ flag.php [L]</code></div>
    <?php endif; ?>
  </div>
</body>
</html>