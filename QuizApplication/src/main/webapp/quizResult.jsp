<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quiz Result</title>
    <style>
        body { font-family: Arial, sans-serif; background:#f4f6f9; margin:0; }
        .container { max-width: 600px; margin:40px auto; background:white; padding:20px;
                     border-radius:10px; box-shadow:0 2px 8px rgba(0,0,0,0.1); text-align:center; }
        h2 { color:#2c3e50; }
        .score { font-size:1.2rem; margin:20px 0; color:#27ae60; }
        a { text-decoration:none; padding:10px 20px; background:#3498db; color:white; border-radius:6px; }
        a:hover { background:#2980b9; }
    </style>
</head>
<body>
    <div class="container">
        <h2>🎉 Quiz Completed!</h2>
        <div class="score">
            Your Score: <b><%= request.getAttribute("score") %></b> /
            <b><%= request.getAttribute("total") %></b>
        </div>
        <a href="index.jsp">Go to Dashboard</a>
        <a href="results.jsp">See Previous Results</a>
    </div>
</body>
</html>
